import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../database/app_database.dart';

final hadithChaptersProvider =
    FutureProvider.family<List<HadithChapter>, String>((ref, bookId) async {
  final db = ref.watch(appDatabaseProvider);
  return db.hadithDao.getChapters(bookId);
});

final hadithDetailProvider =
    FutureProvider.family<Hadith, (String, int)>((ref, args) async {
  final (bookId, hadithId) = args;
  final db = ref.watch(appDatabaseProvider);
  final result = await db.hadithDao.getHadithById(bookId, hadithId);
  if (result == null) throw Exception('الحديث غير موجود');
  return result;
});

final hadithSearchProvider =
    FutureProvider.family<List<Hadith>, String>((ref, query) async {
  if (query.length < 3) return [];
  final db = ref.watch(appDatabaseProvider);
  return db.hadithDao.searchHadiths(query);
});
