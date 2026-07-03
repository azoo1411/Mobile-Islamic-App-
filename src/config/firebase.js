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

// ── ضع إعدادات مشروعك هنا ────────────────────────────────────────────────────
const firebaseConfig = {
  apiKey:            'YOUR_API_KEY',
  authDomain:        'YOUR_PROJECT_ID.firebaseapp.com',
  projectId:         'YOUR_PROJECT_ID',
  storageBucket:     'YOUR_PROJECT_ID.appspot.com',
  messagingSenderId: 'YOUR_SENDER_ID',
  appId:             'YOUR_APP_ID',
  measurementId:     'YOUR_MEASUREMENT_ID',   // G-XXXXXXXXXX — from Analytics
};
// ─────────────────────────────────────────────────────────────────────────────

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
