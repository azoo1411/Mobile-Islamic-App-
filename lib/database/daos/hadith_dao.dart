import 'package:drift/drift.dart';
import '../app_database.dart';

part 'hadith_dao.g.dart';

@DriftAccessor(tables: [Hadiths, HadithChapters])
class HadithDao extends DatabaseAccessor<AppDatabase> with _$HadithDaoMixin {
  HadithDao(super.db);

  Future<List<HadithChapter>> getChapters(String bookId) =>
      (select(hadithChapters)
            ..where((c) => c.bookId.equals(bookId))
            ..orderBy([(c) => OrderingTerm.asc(c.chapterNumber)]))
          .get();

  Future<List<Hadith>> getHadithsByChapter(
          String bookId, int chapterId) =>
      (select(hadiths)
            ..where((h) =>
                h.bookId.equals(bookId) & h.chapterId.equals(chapterId))
            ..orderBy([(h) => OrderingTerm.asc(h.hadithNumber)]))
          .get();

  Future<Hadith?> getHadithById(String bookId, int hadithId) =>
      (select(hadiths)
            ..where((h) =>
                h.bookId.equals(bookId) & h.id.equals(hadithId)))
          .getSingleOrNull();

  Future<List<Hadith>> searchHadiths(String query, {String? bookId}) {
    final q = select(hadiths)
      ..where((h) {
        final textMatch = h.textArabic.contains(query);
        if (bookId != null) return textMatch & h.bookId.equals(bookId);
        return textMatch;
      })
      ..limit(100);
    return q.get();
  }

  Future<int> insertHadith(HadithsCompanion hadith) =>
      into(hadiths).insertOnConflictUpdate(hadith);

  Future<int> insertChapter(HadithChaptersCompanion chapter) =>
      into(hadithChapters).insertOnConflictUpdate(chapter);
}
