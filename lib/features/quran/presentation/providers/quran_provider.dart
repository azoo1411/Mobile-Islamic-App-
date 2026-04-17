import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../database/app_database.dart';
import '../../../../database/daos/quran_dao.dart';

// ─── Surah List ─────────────────────────────────────────────────────────────

final surahListProvider = FutureProvider<List<Surah>>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  return db.quranDao.getAllSurahs();
});

// ─── Surah Details ───────────────────────────────────────────────────────────

class SurahDetailsData {
  final Surah surah;
  final List<Ayah> ayahs;

  SurahDetailsData({required this.surah, required this.ayahs});
}

final surahDetailsProvider =
    FutureProvider.family<SurahDetailsData, int>((ref, surahNumber) async {
  final db = ref.watch(appDatabaseProvider);
  final surah = await db.quranDao.getSurahByNumber(surahNumber);
  final ayahs = await db.quranDao.getAyahsForSurah(surahNumber);
  return SurahDetailsData(surah: surah!, ayahs: ayahs);
});

// ─── Search ──────────────────────────────────────────────────────────────────

final quranSearchProvider =
    FutureProvider.family<List<Ayah>, String>((ref, query) async {
  if (query.length < 3) return [];
  final db = ref.watch(appDatabaseProvider);
  return db.quranDao.searchAyahs(query);
});

// ─── Font Size Preference ────────────────────────────────────────────────────

final quranFontSizeProvider = StateProvider<double>((ref) => 22.0);
