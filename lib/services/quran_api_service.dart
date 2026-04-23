import 'package:dio/dio.dart';
import 'package:drift/drift.dart';

import '../database/app_database.dart';

class QuranApiService {
  static const _baseUrl = 'https://api.alquran.cloud/v1';

  final Dio _dio = Dio(BaseOptions(
    baseUrl: _baseUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(minutes: 2),
  ));

  /// Fetches the complete Quran (6,236 ayahs) in Uthmani script.
  /// Calls [onProgress] with (downloaded, total) as parsing proceeds.
  Future<List<AyahsCompanion>> fetchCompleteQuran({
    void Function(int downloaded, int total)? onProgress,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/quran/quran-uthmani',
    );

    final body = response.data!;
    if (response.statusCode != 200 || body['code'] != 200) {
      throw Exception('AlQuran.cloud API error: ${body['status']}');
    }

    final surahs = (body['data']['surahs'] as List).cast<Map<String, dynamic>>();
    final companions = <AyahsCompanion>[];
    const total = 6236;

    for (final surah in surahs) {
      final surahNum = surah['number'] as int;
      final ayahs = (surah['ayahs'] as List).cast<Map<String, dynamic>>();

      for (final ayah in ayahs) {
        final hizbQuarter = (ayah['hizbQuarter'] as num).toInt();
        companions.add(AyahsCompanion(
          surahNumber: Value(surahNum),
          ayahNumber: Value((ayah['numberInSurah'] as num).toInt()),
          textArabic: Value(ayah['text'] as String),
          textUthmani: Value(ayah['text'] as String),
          pageNumber: Value((ayah['page'] as num).toInt()),
          juzNumber: Value((ayah['juz'] as num).toInt()),
          hizbNumber: Value((hizbQuarter - 1) ~/ 4 + 1),
        ));

        onProgress?.call(companions.length, total);
      }
    }

    return companions;
  }
}
