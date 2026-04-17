import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/quran/presentation/screens/quran_home_screen.dart';
import '../../features/quran/presentation/screens/surah_screen.dart';
import '../../features/quran/presentation/screens/quran_search_screen.dart';
import '../../features/hadith/presentation/screens/hadith_home_screen.dart';
import '../../features/hadith/presentation/screens/hadith_chapter_screen.dart';
import '../../features/hadith/presentation/screens/hadith_reader_screen.dart';
import '../../features/prayer_times/presentation/screens/prayer_times_screen.dart';
import '../../features/qibla/presentation/screens/qibla_screen.dart';
import '../../features/poetry/presentation/screens/poetry_home_screen.dart';
import '../../features/poetry/presentation/screens/poetry_reader_screen.dart';
import '../widgets/main_scaffold.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/home',
    routes: [
      ShellRoute(
        builder: (context, state, child) => MainScaffold(child: child),
        routes: [
          GoRoute(path: '/home', builder: (c, s) => const HomeScreen()),
          GoRoute(path: '/quran', builder: (c, s) => const QuranHomeScreen()),
          GoRoute(
            path: '/hadith',
            builder: (c, s) => const HadithHomeScreen(),
          ),
          GoRoute(
            path: '/prayer',
            builder: (c, s) => const PrayerTimesScreen(),
          ),
          GoRoute(
            path: '/poetry',
            builder: (c, s) => const PoetryHomeScreen(),
          ),
        ],
      ),

      // Detail routes (full screen, no bottom nav)
      GoRoute(
        path: '/quran/surah/:number',
        builder: (c, s) => SurahScreen(
          surahNumber: int.parse(s.pathParameters['number']!),
          startAyah: int.tryParse(s.uri.queryParameters['ayah'] ?? '') ?? 1,
        ),
      ),
      GoRoute(
        path: '/quran/search',
        builder: (c, s) => const QuranSearchScreen(),
      ),
      GoRoute(
        path: '/hadith/:bookId/chapters',
        builder: (c, s) =>
            HadithChapterScreen(bookId: s.pathParameters['bookId']!),
      ),
      GoRoute(
        path: '/hadith/:bookId/hadith/:hadithId',
        builder: (c, s) => HadithReaderScreen(
          bookId: s.pathParameters['bookId']!,
          hadithId: int.parse(s.pathParameters['hadithId']!),
        ),
      ),
      GoRoute(
        path: '/qibla',
        builder: (c, s) => const QiblaScreen(),
      ),
      GoRoute(
        path: '/poetry/:categoryId',
        builder: (c, s) =>
            PoetryReaderScreen(categoryId: s.pathParameters['categoryId']!),
      ),
    ],
  );
});
