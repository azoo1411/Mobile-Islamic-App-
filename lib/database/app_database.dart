import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  TextColumn get revelationType => text()();
  IntColumn get chronologicalOrder => integer()();

  @override
  Set<Column> get primaryKey => {number};
}

class Ayahs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get surahNumber => integer()();
  IntColumn get ayahNumber => integer()();
  TextColumn get textArabic => text()();
  TextColumn get textUthmani => text()();
  IntColumn get pageNumber => integer()();
  IntColumn get juzNumber => integer()();
  IntColumn get hizbNumber => integer()();
}

class Tafseers extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get surahNumber => integer()();
  IntColumn get ayahNumber => integer()();
  TextColumn get source => text()();
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
  TextColumn get poemText => text()();
  TextColumn get tags => text().nullable()();
}

class Bookmarks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get bookmarkType => text()();
  TextColumn get referenceId => text()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get savedAt => dateTime().withDefault(currentDateAndTime)();
}

class LastRead extends Table {
  TextColumn get contentType => text()();
  TextColumn get referenceId => text()();
  DateTimeColumn get lastRead => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {contentType, referenceId};
}

// ─── Database ──────────────────────────────────────────────────────────────

@DriftDatabase(
  tables: [
    Surahs, Ayahs, Tafseers,
    Hadiths, HadithChapters,
    Poems, Bookmarks, LastRead,
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
