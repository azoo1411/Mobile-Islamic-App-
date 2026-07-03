/**
 * Firestore operations for the Islamic app.
 * All functions are safe to call when user is null — they return defaults.
 *
 * Data model:
 *  users/{uid}/
 *    bookmarks: [ { surahId, ayahNumber, surahName, savedAt } ]
 *    readingProgress: { [surahId]: ayahNumber }
 *    settings: { notificationsEnabled, prayerAlerts: { fajr, dhuhr, asr, maghrib, isha } }
 *    adhkarCompleted: { [date]: [ categoryId ] }
 */

import {
  doc, getDoc, setDoc, updateDoc,
  arrayUnion, arrayRemove, serverTimestamp,
} from 'firebase/firestore';
import { db } from '../config/firebase';

// ── Internal helpers ──────────────────────────────────────────────────────────

function userRef(uid) {
  return doc(db, 'users', uid);
}

async function safeGet(uid) {
  if (!uid) return null;
  try {
    const snap = await getDoc(userRef(uid));
    return snap.exists() ? snap.data() : null;
  } catch (_) { return null; }
}

// ── Bookmarks ─────────────────────────────────────────────────────────────────

export async function addBookmark(uid, { surahId, ayahNumber, surahName }) {
  if (!uid) return;
  const entry = { surahId, ayahNumber, surahName, savedAt: Date.now() };
  await updateDoc(userRef(uid), { bookmarks: arrayUnion(entry) });
}

export async function removeBookmark(uid, { surahId, ayahNumber }) {
  if (!uid) return;
  const data = await safeGet(uid);
  if (!data) return;
  const toRemove = (data.bookmarks || []).find(
    b => b.surahId === surahId && b.ayahNumber === ayahNumber
  );
  if (toRemove) {
    await updateDoc(userRef(uid), { bookmarks: arrayRemove(toRemove) });
  }
}

export async function getBookmarks(uid) {
  const data = await safeGet(uid);
  return (data?.bookmarks || []).sort((a, b) => b.savedAt - a.savedAt);
}

export async function isBookmarked(uid, surahId, ayahNumber) {
  const data = await safeGet(uid);
  return (data?.bookmarks || []).some(
    b => b.surahId === surahId && b.ayahNumber === ayahNumber
  );
}

// ── Reading progress ──────────────────────────────────────────────────────────

export async function saveReadingProgress(uid, surahId, ayahNumber) {
  if (!uid) return;
  await updateDoc(userRef(uid), {
    [`readingProgress.${surahId}`]: ayahNumber,
    lastReadAt: serverTimestamp(),
  });
}

export async function getReadingProgress(uid) {
  const data = await safeGet(uid);
  return data?.readingProgress || {};
}

// ── Prayer notification settings ──────────────────────────────────────────────

export async function savePrayerSettings(uid, settings) {
  if (!uid) return;
  await updateDoc(userRef(uid), { 'settings.prayerAlerts': settings });
}

export async function getPrayerSettings(uid) {
  const data = await safeGet(uid);
  return data?.settings?.prayerAlerts || {
    fajr: true, dhuhr: true, asr: true, maghrib: true, isha: true,
  };
}

// ── Adhkar completion tracking ────────────────────────────────────────────────

export async function markAdhkarDone(uid, categoryId) {
  if (!uid) return;
  const today = new Date().toISOString().split('T')[0];
  await updateDoc(userRef(uid), {
    [`adhkarCompleted.${today}`]: arrayUnion(categoryId),
  });
}

export async function getTodayAdhkarStatus(uid) {
  const data  = await safeGet(uid);
  const today = new Date().toISOString().split('T')[0];
  return data?.adhkarCompleted?.[today] || [];
}
