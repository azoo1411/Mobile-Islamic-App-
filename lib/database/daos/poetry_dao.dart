import 'package:drift/drift.dart';
import '../app_database.dart';

part 'poetry_dao.g.dart';

@DriftAccessor(tables: [Poems])
class PoetryDao extends DatabaseAccessor<AppDatabase> with _$PoetryDaoMixin {
  PoetryDao(super.db);

  Future<List<Poem>> getPoemsByCategory(String categoryId) =>
      (select(poems)..where((p) => p.categoryId.equals(categoryId))).get();

  Future<Poem?> getPoemById(int id) =>
      (select(poems)..where((p) => p.id.equals(id))).getSingleOrNull();

  Future<List<Poem>> searchPoems(String query) =>
      (select(poems)
            ..where((p) =>
                p.poemText.contains(query) |
                p.title.contains(query) |
                p.poet.contains(query))
            ..limit(30))
          .get();

  Future<int> insertPoem(PoemsCompanion poem) =>
      into(poems).insertOnConflictUpdate(poem);

  Future<int> getPoemCount() =>
      (selectOnly(poems)..addColumns([poems.id.count()]))
          .map((r) => r.read(poems.id.count()) ?? 0)
          .getSingle();

  Future<List<Poem>> getAllPoems() => select(poems).get();

  Future<void> deleteAllPoems() => delete(poems).go();
}
