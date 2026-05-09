import 'package:drift/drift.dart';
import '../app_database.dart';

part 'bookmarks_dao.g.dart';

@DriftAccessor(tables: [Bookmarks, LastRead])
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
              b.bookmarkType.equals(type) &
              b.referenceId.equals(referenceId)))
        .getSingleOrNull();
    return result != null;
  }

  Future<int> addBookmark(BookmarksCompanion bookmark) =>
      into(bookmarks).insert(bookmark);

  Future<void> removeBookmark(String type, String referenceId) =>
      (delete(bookmarks)
            ..where((b) =>
                b.bookmarkType.equals(type) &
                b.referenceId.equals(referenceId)))
          .go();

  Stream<List<Bookmark>> watchByType(String type) =>
      (select(bookmarks)
            ..where((b) => b.bookmarkType.equals(type))
            ..orderBy([(b) => OrderingTerm.desc(b.savedAt)]))
          .watch();

  Future<void> saveProgress(String type, String referenceId) =>
      into(lastRead).insertOnConflictUpdate(
        LastReadCompanion(
          contentType: Value(type),
          referenceId: Value(referenceId),
        ),
      );

  Future<LastReadData?> getLastProgress(String type) =>
      (select(lastRead)
            ..where((r) => r.contentType.equals(type))
            ..orderBy([(r) => OrderingTerm.desc(r.lastRead)])
            ..limit(1))
          .getSingleOrNull();
}
