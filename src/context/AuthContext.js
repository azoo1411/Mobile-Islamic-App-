/**
 * Auth — automatic anonymous sign-in only.
 * The user never sees a login screen; they just open the app and get a
 * persistent anonymous UID that is used as the Firestore document key.
 *
 * The UID survives:
 *  ✓ App updates
 *  ✓ App restarts
 *  ✗ App uninstall / clear data  (new UID generated, preferences reset)
 */

import React, { createContext, useContext, useState, useEffect } from 'react';
import { signInAnonymously, onAuthStateChanged } from 'firebase/auth';
import { auth } from '../config/firebase';

const AuthContext = createContext(null);

export function AuthProvider({ children }) {
  const [uid,     setUid]     = useState(null);
  const [ready,   setReady]   = useState(false);

  useEffect(() => {
    const unsub = onAuthStateChanged(auth, async (user) => {
      if (user) {
        setUid(user.uid);
        setReady(true);
      } else {
        // Not signed in — sign in anonymously (transparent to user)
        try {
          const cred = await signInAnonymously(auth);
          setUid(cred.user.uid);
        } catch (_) {
          // Firebase not configured yet — app works offline without UID
          setUid(null);
        }
        setReady(true);
      }
    });
    return unsub;
  }, []);

  return (
    <AuthContext.Provider value={{ uid, ready }}>
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  return useContext(AuthContext);
}
