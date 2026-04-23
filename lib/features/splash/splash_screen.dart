import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../providers/initialization_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(initializationProvider.notifier).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final init = ref.watch(initializationProvider);

    ref.listen<InitState>(initializationProvider, (_, next) {
      if (next.phase == InitPhase.done) {
        context.go('/home');
      }
    });

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // App icon / bismillah
              Text(
                'بسم الله الرحمن الرحيم',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontFamily: 'AmiriQuran',
                      color: Colors.white,
                      fontSize: 28,
                    ),
              ),
              const SizedBox(height: 16),
              Text(
                'تطبيق إسلامي',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white70,
                      fontFamily: 'Amiri',
                    ),
              ),
              const Spacer(),

              if (init.phase == InitPhase.error) ...[
                _ErrorView(
                  message: init.errorMessage ?? 'حدث خطأ غير متوقع',
                  onRetry: () =>
                      ref.read(initializationProvider.notifier).retry(),
                ),
              ] else ...[
                _ProgressView(init: init),
              ],

              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProgressView extends StatelessWidget {
  final InitState init;
  const _ProgressView({required this.init});

  String get _label {
    switch (init.phase) {
      case InitPhase.idle:
        return 'جارٍ التحضير...';
      case InitPhase.seedingSurahs:
        return 'تحميل بيانات السور...';
      case InitPhase.downloadingQuran:
        final pct = (init.progress * 100).toStringAsFixed(0);
        return 'تحميل القرآن الكريم... $pct%';
      case InitPhase.done:
        return 'اكتمل التحميل';
      case InitPhase.error:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: init.phase == InitPhase.idle ? null : init.progress,
            minHeight: 8,
            backgroundColor: Colors.white24,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          _label,
          style: const TextStyle(
            color: Colors.white70,
            fontFamily: 'NotoNaskhArabic',
            fontSize: 14,
          ),
        ),
        if (init.phase == InitPhase.downloadingQuran) ...[
          const SizedBox(height: 8),
          Text(
            '${init.current} / ${init.total} آية',
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),
        ],
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(Icons.wifi_off_rounded, color: Colors.white70, size: 48),
        const SizedBox(height: 16),
        Text(
          'يتطلب التطبيق اتصالاً بالإنترنت عند أول تشغيل لتحميل القرآن الكريم.',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'NotoNaskhArabic',
            fontSize: 15,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white54, fontSize: 11),
        ),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh),
          label: const Text('إعادة المحاولة'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
