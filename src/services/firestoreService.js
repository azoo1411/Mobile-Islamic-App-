/**
 * Firestore — helper functions for reading/writing user data.
 * All user data lives under:  userPrefs/{uid}
 *
 * Use UserPrefsContext for reactive state — these helpers are for
 * one-off reads (e.g., from a screen that doesn't hold the context).
 */

import {
  doc, getDoc, updateDoc, arrayUnion, arrayRemove,
} from 'firebase/firestore';
import { db } from '../config/firebase';

function ref(uid) { return doc(db, 'userPrefs', uid); }

// ── Reading progress ──────────────────────────────────────────────────────────

export async function getLastRead(uid) {
  if (!uid) return null;
  try {
    const snap = await getDoc(ref(uid));
    return snap.exists() ? snap.data().lastRead ?? null : null;
  } catch (_) { return null; }
}

// ── Bookmarks ─────────────────────────────────────────────────────────────────

export async function addBookmark(uid, entry) {
  if (!uid) return;
  // entry: { surahId, ayahNumber, surahName, savedAt: Date.now() }
  await updateDoc(ref(uid), { bookmarks: arrayUnion(entry) });
}

export async function removeBookmark(uid, entry) {
  if (!uid) return;
  const snap = await getDoc(ref(uid));
  if (!snap.exists()) return;
  const match = (snap.data().bookmarks || []).find(
    b => b.surahId === entry.surahId && b.ayahNumber === entry.ayahNumber
  );
  if (match) await updateDoc(ref(uid), { bookmarks: arrayRemove(match) });
}

export async function getBookmarks(uid) {
  if (!uid) return [];
  try {
    const snap = await getDoc(ref(uid));
    return snap.exists()
      ? (snap.data().bookmarks || []).sort((a, b) => b.savedAt - a.savedAt)
      : [];
  } catch (_) { return []; }
}

// ── Adhkar completion ─────────────────────────────────────────────────────────

export async function markAdhkarDone(uid, categoryId) {
  if (!uid) return;
  const today = new Date().toISOString().split('T')[0];
  await updateDoc(ref(uid), {
    [`adhkarCompleted.${today}`]: arrayUnion(categoryId),
  });
}

export async function getTodayAdhkarStatus(uid) {
  if (!uid) return [];
  try {
    const snap  = await getDoc(ref(uid));
    const today = new Date().toISOString().split('T')[0];
    return snap.exists() ? (snap.data().adhkarCompleted?.[today] || []) : [];
  } catch (_) { return []; }
}
