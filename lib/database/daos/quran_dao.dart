import 'package:drift/drift.dart';
import '../app_database.dart';

part 'quran_dao.g.dart';

@DriftAccessor(tables: [Surahs, Ayahs, Tafseers])
class QuranDao extends DatabaseAccessor<AppDatabase> with _$QuranDaoMixin {
  QuranDao(super.db);

  Future<List<Surah>> getAllSurahs() => select(surahs).get();

  Future<Surah?> getSurahByNumber(int number) =>
      (select(surahs)..where((s) => s.number.equals(number)))
          .getSingleOrNull();

  Future<List<Ayah>> getAyahsForSurah(int surahNumber) =>
      (select(ayahs)
            ..where((a) => a.surahNumber.equals(surahNumber))
            ..orderBy([(a) => OrderingTerm.asc(a.ayahNumber)]))
          .get();

  Future<Ayah?> getAyah(int surahNumber, int ayahNumber) =>
      (select(ayahs)
            ..where((a) =>
                a.surahNumber.equals(surahNumber) &
                a.ayahNumber.equals(ayahNumber)))
          .getSingleOrNull();

  Future<List<Ayah>> getAyahsByJuz(int juzNumber) =>
      (select(ayahs)
            ..where((a) => a.juzNumber.equals(juzNumber))
            ..orderBy([
              (a) => OrderingTerm.asc(a.surahNumber),
              (a) => OrderingTerm.asc(a.ayahNumber),
            ]))
          .get();

  Future<List<Ayah>> searchAyahs(String query) =>
      (select(ayahs)
            ..where((a) => a.textArabic.contains(query))
            ..limit(50))
          .get();

  Future<Tafseer?> getTafseer(
          int surahNumber, int ayahNumber, String source) =>
      (select(tafseers)
            ..where((t) =>
                t.surahNumber.equals(surahNumber) &
                t.ayahNumber.equals(ayahNumber) &
                t.source.equals(source)))
          .getSingleOrNull();

  Future<int> insertSurah(SurahsCompanion surah) =>
      into(surahs).insertOnConflictUpdate(surah);

  Future<void> insertAllAyahs(List<AyahsCompanion> batch) async {
    await db.batch((b) {
      b.insertAllOnConflictUpdate(ayahs, batch);
    });
  }
}
