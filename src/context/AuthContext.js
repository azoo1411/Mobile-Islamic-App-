import React, { createContext, useContext, useState, useEffect } from 'react';
import {
  createUserWithEmailAndPassword,
  signInWithEmailAndPassword,
  signInAnonymously,
  signOut,
  onAuthStateChanged,
  updateProfile,
  sendPasswordResetEmail,
} from 'firebase/auth';
import { doc, setDoc, getDoc, serverTimestamp } from 'firebase/firestore';
import { auth, db } from '../config/firebase';
import { logEvent } from '../services/analyticsService';

const AuthContext = createContext(null);

export function AuthProvider({ children }) {
  const [user,    setUser]    = useState(null);
  const [profile, setProfile] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const unsub = onAuthStateChanged(auth, async (firebaseUser) => {
      setUser(firebaseUser);
      if (firebaseUser && !firebaseUser.isAnonymous) {
        await loadProfile(firebaseUser.uid);
      } else {
        setProfile(null);
      }
      setLoading(false);
    });
    return unsub;
  }, []);

  async function loadProfile(uid) {
    try {
      const snap = await getDoc(doc(db, 'users', uid));
      if (snap.exists()) setProfile(snap.data());
    } catch (_) {}
  }

  async function registerWithEmail(email, password, displayName) {
    const cred = await createUserWithEmailAndPassword(auth, email, password);
    await updateProfile(cred.user, { displayName });
    const profileData = {
      uid:         cred.user.uid,
      email,
      displayName,
      createdAt:   serverTimestamp(),
      bookmarks:   [],
      settings:    {},
    };
    await setDoc(doc(db, 'users', cred.user.uid), profileData);
    setProfile(profileData);
    logEvent('sign_up', { method: 'email' });
    return cred.user;
  }

  async function loginWithEmail(email, password) {
    const cred = await signInWithEmailAndPassword(auth, email, password);
    await loadProfile(cred.user.uid);
    logEvent('login', { method: 'email' });
    return cred.user;
  }

  async function loginAnonymously() {
    const cred = await signInAnonymously(auth);
    logEvent('login', { method: 'anonymous' });
    return cred.user;
  }

  async function resetPassword(email) {
    await sendPasswordResetEmail(auth, email);
  }

  async function logout() {
    logEvent('logout', {});
    setProfile(null);
    await signOut(auth);
  }

  const value = {
    user,
    profile,
    loading,
    isAnonymous: user?.isAnonymous ?? true,
    isLoggedIn:  !!user,
    registerWithEmail,
    loginWithEmail,
    loginAnonymously,
    resetPassword,
    logout,
  };

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
}

export function useAuth() {
  const ctx = useContext(AuthContext);
  if (!ctx) throw new Error('useAuth must be inside AuthProvider');
  return ctx;
}
