/**
 * Analytics wrapper — logs events when Firebase Analytics is available.
 * Falls back silently on Expo Go where Analytics isn't supported.
 */

import { logEvent as fbLog } from 'firebase/analytics';
import { analytics } from '../config/firebase';

export function logEvent(eventName, params = {}) {
  if (!analytics) return;
  try {
    fbLog(analytics, eventName, params);
  } catch (_) {}
}

// ── Preset events used across the app ────────────────────────────────────────

export const Analytics = {
  screenView: (screenName) =>
    logEvent('screen_view', { screen_name: screenName }),

  quranSurahOpen: (surahId, surahName) =>
    logEvent('quran_surah_open', { surah_id: surahId, surah_name: surahName }),

  adhkarCategoryOpen: (categoryId) =>
    logEvent('adhkar_category_open', { category_id: categoryId }),

  prayerTimeView: () =>
    logEvent('prayer_time_view', {}),

  bookmarkAdded: (surahId, ayahNumber) =>
    logEvent('bookmark_added', { surah_id: surahId, ayah: ayahNumber }),

  bookmarkRemoved: (surahId, ayahNumber) =>
    logEvent('bookmark_removed', { surah_id: surahId, ayah: ayahNumber }),

  searchQuery: (query) =>
    logEvent('search', { search_term: query }),

  themeChanged: (theme) =>
    logEvent('theme_changed', { theme }),

  notificationEnabled: (prayerName) =>
    logEvent('notification_enabled', { prayer: prayerName }),
};
