/**
 * UserPrefsContext — مزامنة تفضيلات المستخدم مع Firestore.
 *
 * ما يُحفظ تلقائياً:
 *  • آخر موقع في القرآن (السورة، الآية، الجزء)
 *  • الموقع الجغرافي (لحساب أوقات الصلاة)
 *  • تفعيل الأذان لكل صلاة
 *  • صوت المؤذن المختار
 *  • الإعدادات المظهرية (تُزامَن إضافةً للتخزين المحلي)
 *
 * تدفق العمل:
 *  1. عند الفتح: يُحمَّل من Firestore أولاً → إن فشل يُحمَّل من AsyncStorage
 *  2. عند كل تغيير: يُحفَظ محلياً فوراً + يُرسَل إلى Firestore
 *  3. تحديثات التطبيق لا تمس Firestore → تفضيلات المستخدم تبقى كما هي
 */

import React, { createContext, useContext, useState, useEffect, useCallback } from 'react';
import AsyncStorage from '@react-native-async-storage/async-storage';
import {
  doc, getDoc, setDoc, updateDoc, serverTimestamp,
} from 'firebase/firestore';
import { db } from '../config/firebase';
import { useAuth } from './AuthContext';

const UserPrefsContext = createContext(null);

// ── Default values ────────────────────────────────────────────────────────────
const DEFAULTS = {
  // آخر موقع قرآني
  lastRead: { surahId: 1, ayahNumber: 1, juzNumber: 1, surahName: 'الفاتحة' },

  // الموقع الجغرافي
  location: { lat: null, lng: null, city: '', country: '' },

  // تفعيل الأذان لكل صلاة
  prayerAlerts: {
    fajr:    true,
    dhuhr:   true,
    asr:     true,
    maghrib: true,
    isha:    true,
  },

  // صوت المؤذن
  adhanVoice: 'mecca',   // انظر ADHAN_VOICES أدناه

  // إعدادات العرض (تُزامَن مع Firestore أيضاً)
  theme:          'auto',
  arabicFontSize: 28,
  showTranslation: true,
  showTranslit:    false,
};

// ── خيارات صوت الأذان ─────────────────────────────────────────────────────────
export const ADHAN_VOICES = [
  { id: 'mecca',      nameAr: 'أذان مكة المكرمة'        },
  { id: 'medina',     nameAr: 'أذان المدينة المنورة'    },
  { id: 'afasy',      nameAr: 'مشاري راشد العفاسي'     },
  { id: 'basset',     nameAr: 'عبد الباسط عبد الصمد'   },
  { id: 'minshawi',   nameAr: 'محمد صديق المنشاوي'     },
  { id: 'husary',     nameAr: 'محمود خليل الحصري'      },
];

const STORAGE_KEY = '@user_prefs';

// ── Provider ──────────────────────────────────────────────────────────────────
export function UserPrefsProvider({ children }) {
  const { uid, ready: authReady } = useAuth();
  const [prefs,   setPrefs]   = useState(DEFAULTS);
  const [synced,  setSynced]  = useState(false);

  // ── Load prefs on startup ──────────────────────────────────────────────────
  useEffect(() => {
    if (!authReady) return;
    loadPrefs();
  }, [authReady, uid]);

  async function loadPrefs() {
    // 1. Load from AsyncStorage first (instant, works offline)
    let local = DEFAULTS;
    try {
      const raw = await AsyncStorage.getItem(STORAGE_KEY);
      if (raw) local = { ...DEFAULTS, ...JSON.parse(raw) };
    } catch (_) {}
    setPrefs(local);

    // 2. Try to load from Firestore (cloud, survives reinstall if same UID)
    if (uid) {
      try {
        const snap = await getDoc(doc(db, 'userPrefs', uid));
        if (snap.exists()) {
          const cloud = snap.data();
          // Merge: cloud overrides local (cloud is the source of truth)
          const merged = { ...local, ...cloud };
          delete merged.updatedAt;   // don't expose Firestore metadata
          setPrefs(merged);
          await AsyncStorage.setItem(STORAGE_KEY, JSON.stringify(merged));
        } else {
          // First launch for this UID — save defaults to Firestore
          await setDoc(doc(db, 'userPrefs', uid), {
            ...local,
            createdAt:  serverTimestamp(),
            updatedAt:  serverTimestamp(),
          });
        }
      } catch (_) {
        // Offline or Firebase not configured — local prefs are used
      }
    }

    setSynced(true);
  }

  // ── Save helper — local + cloud ────────────────────────────────────────────
  const save = useCallback(async (patch) => {
    const next = { ...prefs, ...patch };
    setPrefs(next);

    // Local (synchronous feel)
    try {
      await AsyncStorage.setItem(STORAGE_KEY, JSON.stringify(next));
    } catch (_) {}

    // Firestore (background, best-effort)
    if (uid) {
      try {
        await updateDoc(doc(db, 'userPrefs', uid), {
          ...patch,
          updatedAt: serverTimestamp(),
        });
      } catch (_) {}
    }
  }, [prefs, uid]);

  // ── Setters ───────────────────────────────────────────────────────────────
  const setLastRead = useCallback((surahId, ayahNumber, juzNumber, surahName) =>
    save({ lastRead: { surahId, ayahNumber, juzNumber, surahName } }), [save]);

  const setLocation = useCallback((lat, lng, city, country) =>
    save({ location: { lat, lng, city, country } }), [save]);

  const setPrayerAlerts = useCallback((alerts) =>
    save({ prayerAlerts: { ...prefs.prayerAlerts, ...alerts } }), [save, prefs.prayerAlerts]);

  const togglePrayerAlert = useCallback((prayer) =>
    save({ prayerAlerts: { ...prefs.prayerAlerts, [prayer]: !prefs.prayerAlerts[prayer] } }),
    [save, prefs.prayerAlerts]);

  const setAdhanVoice = useCallback((voice) => save({ adhanVoice: voice }), [save]);

  const setTheme = useCallback((theme) => save({ theme }), [save]);

  const setArabicFontSize = useCallback((arabicFontSize) => save({ arabicFontSize }), [save]);

  const setShowTranslation = useCallback((showTranslation) => save({ showTranslation }), [save]);

  const setShowTranslit = useCallback((showTranslit) => save({ showTranslit }), [save]);

  const value = {
    prefs,
    synced,
    // Convenience direct access
    lastRead:      prefs.lastRead,
    location:      prefs.location,
    prayerAlerts:  prefs.prayerAlerts,
    adhanVoice:    prefs.adhanVoice,
    // Setters
    setLastRead,
    setLocation,
    setPrayerAlerts,
    togglePrayerAlert,
    setAdhanVoice,
    setTheme,
    setArabicFontSize,
    setShowTranslation,
    setShowTranslit,
  };

  return (
    <UserPrefsContext.Provider value={value}>
      {children}
    </UserPrefsContext.Provider>
  );
}

export function useUserPrefs() {
  const ctx = useContext(UserPrefsContext);
  if (!ctx) throw new Error('useUserPrefs must be inside UserPrefsProvider');
  return ctx;
}
