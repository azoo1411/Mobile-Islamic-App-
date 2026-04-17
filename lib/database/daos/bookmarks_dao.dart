import 'package:drift/drift.dart';
import '../app_database.dart';

part 'bookmarks_dao.g.dart';

@DriftAccessor(tables: [Bookmarks, ReadingProgress])
class BookmarksDao extends DatabaseAccessor<AppDatabase>
    with _$BookmarksDaoMixin {
  BookmarksDao(super.db);

  Future<List<Bookmark>> getAllBookmarks() =>
      (select(bookmarks)
            ..orderBy([(b) => OrderingTerm.desc(b.savedAt)]))
          .get();

  Future<bool> isBookmarked(String type, String referenceId) async {
    final result = await (select(bookmarks)
          ..where((b) =>
              b.type.equals(type) & b.referenceId.equals(referenceId)))
        .getSingleOrNull();
    return result != null;
  }

  Future<int> addBookmark(BookmarksCompanion bookmark) =>
      into(bookmarks).insert(bookmark);

  Future<void> removeBookmark(String type, String referenceId) =>
      (delete(bookmarks)
            ..where((b) =>
                b.type.equals(type) & b.referenceId.equals(referenceId)))
          .go();

  Future<void> saveProgress(String type, String referenceId) =>
      into(readingProgress).insertOnConflictUpdate(
        ReadingProgressCompanion(
          type: Value(type),
          referenceId: Value(referenceId),
        ),
      );

  Future<ReadingProgres?> getLastProgress(String type) =>
      (select(readingProgress)
            ..where((r) => r.type.equals(type))
            ..orderBy([(r) => OrderingTerm.desc(r.lastRead)])
            ..limit(1))
          .getSingleOrNull();
}
