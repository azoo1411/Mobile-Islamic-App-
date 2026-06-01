import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/adhkar/presentation/screens/adhkar_home_screen.dart';
import '../../features/adhkar/presentation/screens/adhkar_reader_screen.dart';
import '../../features/contact/presentation/screens/contact_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/poetry/presentation/screens/poetry_home_screen.dart';
import '../../features/poetry/presentation/screens/poetry_reader_screen.dart';
import '../../features/prayer_times/presentation/screens/prayer_times_screen.dart';
import '../../features/qibla/presentation/screens/qibla_screen.dart';
import '../../features/quran/presentation/screens/quran_home_screen.dart';
import '../../features/quran/presentation/screens/quran_search_screen.dart';
import '../../features/quran/presentation/screens/surah_screen.dart';
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
          GoRoute(path: '/adhkar', builder: (c, s) => const AdhkarHomeScreen()),
          GoRoute(path: '/prayer', builder: (c, s) => const PrayerTimesScreen()),
          GoRoute(path: '/poetry', builder: (c, s) => const PoetryHomeScreen()),
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
        path: '/adhkar/:categoryId',
        builder: (c, s) =>
            AdhkarReaderScreen(categoryId: s.pathParameters['categoryId']!),
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
      GoRoute(
        path: '/contact',
        builder: (c, s) => const ContactScreen(),
      ),
    ],
  );
});
