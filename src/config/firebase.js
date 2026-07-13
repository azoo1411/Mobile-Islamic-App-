/**
 * Firebase configuration
 *
 * HOW TO FILL THIS FILE:
 * 1. Go to https://console.firebase.google.com
 * 2. Create a project (or open existing one)
 * 3. Click the web icon </> → Register app
 * 4. Copy the firebaseConfig object and paste below
 * 5. Enable the services you need in Firebase Console:
 *    - Authentication → Sign-in method → Email/Password + Anonymous
 *    - Firestore Database → Create database
 *    - Analytics (enabled by default)
 *    - Cloud Messaging (for push notifications)
 */

import { initializeApp, getApps } from 'firebase/app';
import { getAuth }                from 'firebase/auth';
import { getFirestore }           from 'firebase/firestore';
import { getAnalytics, isSupported } from 'firebase/analytics';

const firebaseConfig = {
  apiKey:            'AIzaSyCjvxOjoOC2CdxVrath3cPp0IoLcu_g-Q4',
  authDomain:        'islamic-app-akq.firebaseapp.com',
  projectId:         'islamic-app-akq',
  storageBucket:     'islamic-app-akq.firebasestorage.app',
  messagingSenderId: '109575143969',
  appId:             '1:109575143969:web:1d4ea97e5856017cf31960',
  measurementId:     'G-9SN5BFP9D1',
};

// Initialize once (avoids duplicate app error on hot-reload)
const app = getApps().length === 0 ? initializeApp(firebaseConfig) : getApps()[0];

export const auth = getAuth(app);
export const db   = getFirestore(app);

// Analytics is only supported in some environments (not Expo Go)
export let analytics = null;
isSupported().then(ok => {
  if (ok) analytics = getAnalytics(app);
}).catch(() => {});

export default app;
