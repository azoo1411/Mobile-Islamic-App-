import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../database/daos/quran_dao.dart';
import '../database/daos/hadith_dao.dart';
import '../database/daos/poetry_dao.dart';
import 'quran_api_service.dart';

/// Seeds the local SQLite database from bundled JSON assets and remote API.
/// Run once on first launch (no-op if already seeded).
class DatabaseSeeder {
  final AppDatabase _db;
  final QuranApiService _quranApi;

  DatabaseSeeder(this._db) : _quranApi = QuranApiService();

  Future<void> seedIfNeeded({
    void Function(String phase, int current, int total)? onProgress,
  }) async {
    final existing = await _db.quranDao.getAllSurahs();
    if (existing.isNotEmpty) return;

    onProgress?.call('surahs', 0, 1);
    await _seedSurahs();
    onProgress?.call('surahs', 1, 1);

    await _seedAyahsFromApi(onProgress: (c, t) => onProgress?.call('ayahs', c, t));
    await _seedHadiths();
    await _seedPoetry();
  }

  Future<void> _seedSurahs() async {
    final raw = await rootBundle.loadString('assets/data/surahs.json');
    final List data = json.decode(raw);
    for (final s in data) {
      await _db.quranDao.insertSurah(SurahsCompanion(
        number: Value(s['number'] as int),
        nameArabic: Value(s['name_arabic'] as String),
        nameTransliteration: Value(s['name_transliteration'] as String),
        ayahCount: Value(s['ayah_count'] as int),
        revelationType: Value(s['revelation_type'] as String),
        chronologicalOrder: Value(s['chronological_order'] as int),
      ));
    }
  }

  Future<void> _seedAyahsFromApi({
    void Function(int current, int total)? onProgress,
  }) async {
    final ayahs = await _quranApi.fetchCompleteQuran(onProgress: onProgress);

    // Insert in batches of 500 for performance
    for (var i = 0; i < ayahs.length; i += 500) {
      final batch = ayahs.sublist(i, (i + 500).clamp(0, ayahs.length));
      await _db.quranDao.insertAllAyahs(batch);
    }
  }

  Future<void> _seedHadiths() async {
    try {
      final raw = await rootBundle.loadString('assets/data/hadiths.json');
      final List data = json.decode(raw);
      for (final h in data) {
        await _db.hadithDao.insertHadith(HadithsCompanion(
          bookId: Value(h['book_id'] as String),
          chapterId: Value(h['chapter_id'] as int),
          hadithNumber: Value(h['number'] as int),
          textArabic: Value(h['text_arabic'] as String),
          narrator: Value(h['narrator'] as String),
          grade: Value(h['grade'] as String?),
        ));
      }
    } catch (_) {
      // Hadith data not bundled yet — will be fetched from API
    }
  }

  Future<void> _seedPoetry() async {
    try {
      final raw = await rootBundle.loadString('assets/data/poetry.json');
      final List data = json.decode(raw);
      for (final p in data) {
        await _db.poetryDao.insertPoem(PoemsCompanion(
          categoryId: Value(p['category_id'] as String),
          title: Value(p['title'] as String),
          poet: Value(p['poet'] as String),
          era: Value(p['era'] as String?),
          poemText: Value(p['text'] as String),
        ));
      }
    } catch (_) {
      // Poetry data not bundled yet
    }
  }
}
