import 'dart:convert';
import 'package:flutter/services.dart';

import '../database/app_database.dart';
import '../database/daos/quran_dao.dart';
import '../database/daos/hadith_dao.dart';
import '../database/daos/poetry_dao.dart';
import 'package:drift/drift.dart';

/// Seeds the local SQLite database from bundled JSON assets.
/// Run once on first launch. Data sources:
///   - assets/data/surahs.json    (tanzil.net metadata)
///   - assets/data/quran.json     (tanzil.net full Uthmani text)
///   - assets/data/hadiths.json   (curated subset from sunnah.com)
///   - assets/data/poetry.json    (curated Arabic poetry)
class DatabaseSeeder {
  final AppDatabase _db;

  DatabaseSeeder(this._db);

  Future<void> seedIfNeeded() async {
    final count = await _db.quranDao.getAllSurahs();
    if (count.isNotEmpty) return; // Already seeded

    await _seedSurahs();
    await _seedAyahs();
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

  Future<void> _seedAyahs() async {
    final raw = await rootBundle.loadString('assets/data/quran.json');
    final List data = json.decode(raw);
    final batch = <AyahsCompanion>[];

    for (final a in data) {
      batch.add(AyahsCompanion(
        surahNumber: Value(a['surah'] as int),
        ayahNumber: Value(a['ayah'] as int),
        textArabic: Value(a['text'] as String),
        textUthmani: Value(a['text_uthmani'] as String),
        pageNumber: Value(a['page'] as int),
        juzNumber: Value(a['juz'] as int),
        hizbNumber: Value((a['hizb'] ?? 1) as int),
      ));

      // Insert in batches of 500 for performance
      if (batch.length >= 500) {
        await _db.quranDao.insertAllAyahs(batch);
        batch.clear();
      }
    }
    if (batch.isNotEmpty) await _db.quranDao.insertAllAyahs(batch);
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
          text: Value(p['text'] as String),
        ));
      }
    } catch (_) {
      // Poetry data not bundled yet
    }
  }
}
