import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'daos/quran_dao.dart';
import 'daos/hadith_dao.dart';
import 'daos/poetry_dao.dart';
import 'daos/bookmarks_dao.dart';

part 'app_database.g.dart';

// ─── Tables ────────────────────────────────────────────────────────────────

class Surahs extends Table {
  IntColumn get number => integer()();
  TextColumn get nameArabic => text()();
  TextColumn get nameTransliteration => text()();
  IntColumn get ayahCount => integer()();
  TextColumn get revelationType => text()(); // 'meccan' | 'medinan'
  IntColumn get chronologicalOrder => integer()();

  @override
  Set<Column> get primaryKey => {number};
}

class Ayahs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get surahNumber => integer().references(Surahs, #number)();
  IntColumn get ayahNumber => integer()();
  TextColumn get textArabic => text()();
  TextColumn get textUthmani => text()(); // with full diacritics
  IntColumn get pageNumber => integer()();
  IntColumn get juzNumber => integer()();
  IntColumn get hizbNumber => integer()();

  @override
  List<Index> get indexes => [
        Index('idx_ayah_surah', ['surahNumber']),
        Index('idx_ayah_juz', ['juzNumber']),
      ];
}

class Tafseers extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get surahNumber => integer()();
  IntColumn get ayahNumber => integer()();
  TextColumn get source => text()(); // 'ibn_katheer' | 'saadi'
  TextColumn get textArabic => text()();
}

class Hadiths extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get bookId => text()();
  IntColumn get chapterId => integer()();
  IntColumn get hadithNumber => integer()();
  TextColumn get textArabic => text()();
  TextColumn get narrator => text()();
  TextColumn get grade => text().nullable()();
  IntColumn get referenceNumber => integer().nullable()();
}

class HadithChapters extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get bookId => text()();
  IntColumn get chapterNumber => integer()();
  TextColumn get titleArabic => text()();
  IntColumn get hadithCount => integer()();
}

class Poems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get categoryId => text()();
  TextColumn get title => text()();
  TextColumn get poet => text()();
  TextColumn get era => text().nullable()();
  TextColumn get text => text()(); // full poem, lines separated by \n
  TextColumn get tags => text().nullable()(); // JSON array
}

class Bookmarks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get type => text()(); // 'ayah' | 'hadith' | 'poem'
  TextColumn get referenceId => text()(); // e.g. "2:255" or "bukhari:1"
  TextColumn get note => text().nullable()();
  DateTimeColumn get savedAt => dateTime().withDefault(currentDateAndTime)();
}

class ReadingProgress extends Table {
  TextColumn get type => text()(); // 'quran' | 'hadith'
  TextColumn get referenceId => text()();
  DateTimeColumn get lastRead => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {type, referenceId};
}

// ─── Database ──────────────────────────────────────────────────────────────

@DriftDatabase(
  tables: [
    Surahs, Ayahs, Tafseers,
    Hadiths, HadithChapters,
    Poems, Bookmarks, ReadingProgress,
  ],
  daos: [QuranDao, HadithDao, PoetryDao, BookmarksDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'islamic_app_db');
  }
}

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError('Override in main()');
});
