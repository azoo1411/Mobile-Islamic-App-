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
