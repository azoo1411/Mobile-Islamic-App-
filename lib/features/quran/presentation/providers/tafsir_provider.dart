import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// quran.com API v4 — Tafsir Al-Saadi (Arabic), ID 169
const _kTafsirId = 169;

final _dio = Dio(
  BaseOptions(
    baseUrl: 'https://api.quran.com/api/v4',
    connectTimeout: const Duration(seconds: 12),
    receiveTimeout: const Duration(seconds: 12),
    headers: {'Accept': 'application/json'},
  ),
);

/// Returns cleaned tafsir text for a given (surah, ayah) pair.
/// Caches per ayah, auto-disposed when no longer watched.
final tafsirProvider =
    FutureProvider.autoDispose.family<String, (int, int)>((ref, key) async {
  final (surah, ayah) = key;
  try {
    final res = await _dio
        .get('/tafsirs/$_kTafsirId/by_ayah/$surah:$ayah');
    final text = res.data['tafsir']?['text'] as String? ?? '';
    return _clean(text);
  } on DioException catch (e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      throw Exception('انتهت مهلة الاتصال');
    }
    throw Exception('تعذّر تحميل التفسير');
  }
});

String _clean(String html) => html
    .replaceAll(RegExp(r'<[^>]*>'), '')
    .replaceAll(RegExp(r'\s{2,}'), ' ')
    .trim();
