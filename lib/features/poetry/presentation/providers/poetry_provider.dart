import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../database/app_database.dart';

final poetryCategoryProvider =
    FutureProvider.family<List<Poem>, String>((ref, categoryId) async {
  final db = ref.watch(appDatabaseProvider);
  return db.poetryDao.getPoemsByCategory(categoryId);
});

final poetrySearchProvider =
    FutureProvider.family<List<Poem>, String>((ref, query) async {
  if (query.length < 2) return [];
  final db = ref.watch(appDatabaseProvider);
  return db.poetryDao.searchPoems(query);
});

final dailyPoemProvider = FutureProvider<Poem?>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  final all = await db.poetryDao.getAllPoems();
  if (all.isEmpty) return null;
  final now = DateTime.now();
  final seed = now.year * 10000 + now.month * 100 + now.day;
  return all[seed % all.length];
});
