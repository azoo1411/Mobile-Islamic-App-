import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../database/app_database.dart';

const _kMushafPage = 'mushaf_page';

// Live stream of all mushaf-page bookmarks
final mushafBookmarksProvider = StreamProvider<List<Bookmark>>((ref) {
  return ref.watch(appDatabaseProvider).bookmarksDao.watchByType(_kMushafPage);
});

// Reactive bool — is this page bookmarked?
final isPageBookmarkedProvider = Provider.family<bool, int>((ref, page) {
  final list = ref.watch(mushafBookmarksProvider).valueOrNull ?? [];
  return list.any((b) => b.referenceId == page.toString());
});

// Actions
Future<void> toggleMushafBookmark(WidgetRef ref, int page) async {
  final dao = ref.read(appDatabaseProvider).bookmarksDao;
  final already = ref.read(isPageBookmarkedProvider(page));
  if (already) {
    await dao.removeBookmark(_kMushafPage, page.toString());
  } else {
    await dao.addBookmark(
      BookmarksCompanion(
        bookmarkType: const Value(_kMushafPage),
        referenceId: Value(page.toString()),
      ),
    );
  }
}
