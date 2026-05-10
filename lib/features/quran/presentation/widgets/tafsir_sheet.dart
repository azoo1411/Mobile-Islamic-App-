import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/arabic_utils.dart';
import '../providers/tafsir_provider.dart';

void showTafsirSheet(
  BuildContext context, {
  required int surahNumber,
  required int ayahNumber,
  required String ayahText,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _TafsirSheet(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      ayahText: ayahText,
    ),
  );
}

class _TafsirSheet extends ConsumerWidget {
  final int surahNumber;
  final int ayahNumber;
  final String ayahText;

  const _TafsirSheet({
    required this.surahNumber,
    required this.ayahNumber,
    required this.ayahText,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tafsir = ref.watch(tafsirProvider((surahNumber, ayahNumber)));

    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      minChildSize: 0.35,
      maxChildSize: 0.92,
      builder: (_, controller) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF0F1629),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          border: Border(
            top: BorderSide(color: Color(0x55D4AF37), width: 1),
          ),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 10),
              width: 36,
              height: 3,
              decoration: BoxDecoration(
                color: const Color(0x55D4AF37),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'تفسير الآية ${ArabicUtils.toArabicNumerals(ayahNumber)}',
                    style: const TextStyle(
                      fontFamily: 'NotoNaskhArabic',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFD4AF37),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0x22D4AF37),
                      border: Border.all(
                          color: const Color(0x55D4AF37), width: 1),
                    ),
                    child: const Text(
                      'تفسير السعدي',
                      style: TextStyle(
                        fontFamily: 'NotoNaskhArabic',
                        fontSize: 11,
                        color: Color(0xFFD4AF37),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1, color: Color(0x22FFFFFF)),

            // Content
            Expanded(
              child: ListView(
                controller: controller,
                padding: const EdgeInsets.all(20),
                children: [
                  // Ayah text
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppColors.primary.withOpacity(0.15)),
                    ),
                    child: Text(
                      ayahText,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.justify,
                      locale: const Locale('ar'),
                      style: const TextStyle(
                        fontFamily: 'AmiriQuran',
                        fontSize: 20,
                        height: 2.2,
                        color: Color(0xFF1B4D3E),
                        fontFeatures: [
                          FontFeature.enable('calt'),
                          FontFeature.enable('liga'),
                          FontFeature.enable('clig'),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Tafsir text
                  tafsir.when(
                    loading: () => const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: CircularProgressIndicator(
                            color: AppColors.primary, strokeWidth: 2),
                      ),
                    ),
                    error: (e, _) => _ErrorWidget(
                      message: e.toString().replaceFirst('Exception: ', ''),
                      onRetry: () => ref.invalidate(
                          tafsirProvider((surahNumber, ayahNumber))),
                    ),
                    data: (text) => text.isEmpty
                        ? const _ErrorWidget(message: 'التفسير غير متوفر لهذه الآية')
                        : Text(
                            text,
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.justify,
                            style: const TextStyle(
                              fontFamily: 'NotoNaskhArabic',
                              fontSize: 16,
                              height: 2.0,
                              color: Color(0xCCFFFFFF),
                            ),
                          ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  const _ErrorWidget({required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(Icons.cloud_off_outlined,
                size: 40, color: AppColors.textSecondary),
            const SizedBox(height: 12),
            Text(
              message,
              style: const TextStyle(
                  fontFamily: 'NotoNaskhArabic',
                  color: AppColors.textSecondary),
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 12),
              TextButton(
                onPressed: onRetry,
                child: const Text('إعادة المحاولة',
                    style: TextStyle(
                        fontFamily: 'NotoNaskhArabic',
                        color: AppColors.primary)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
