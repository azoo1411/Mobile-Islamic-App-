import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/arabic_utils.dart';
import '../../../../database/app_database.dart';
import '../providers/audio_provider.dart';
import 'tafsir_sheet.dart';

class AyahCard extends ConsumerWidget {
  final Ayah ayah;
  final double fontSize;

  const AyahCard({super.key, required this.ayah, this.fontSize = 22});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playingAyah = ref.watch(currentlyPlayingAyahProvider);
    final isPlaying = playingAyah?.surah == ayah.surahNumber &&
        playingAyah?.ayah == ayah.ayahNumber;

    return GestureDetector(
      onLongPress: () => showTafsirSheet(
        context,
        surahNumber: ayah.surahNumber,
        ayahNumber: ayah.ayahNumber,
        ayahText: ayah.textUthmani,
      ),
      child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isPlaying
            ? AppColors.primary.withOpacity(0.06)
            : Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(12),
        border: isPlaying
            ? Border.all(color: AppColors.primary.withOpacity(0.3))
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildAyahNumberRow(context, ref, isPlaying),
            const SizedBox(height: 12),
            Text(
              ayah.textUthmani,
              style: AppTypography.quranAyah.copyWith(
                fontSize: fontSize,
                color: isPlaying ? AppColors.primary : AppColors.textQuran,
                fontFeatures: const [
                  FontFeature.enable('calt'),
                  FontFeature.enable('liga'),
                  FontFeature.enable('clig'),
                ],
              ),
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.justify,
              locale: const Locale('ar'),
            ),
          ],
        ),
      ),
      ), // GestureDetector
    );
  }

  Widget _buildAyahNumberRow(
      BuildContext context, WidgetRef ref, bool isPlaying) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(
              iconSize: 20,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(maxWidth: 32, maxHeight: 32),
              icon: Icon(
                isPlaying ? Icons.pause_circle : Icons.play_circle_outline,
                color: AppColors.primary,
              ),
              onPressed: () {
                if (isPlaying) {
                  ref.read(audioServiceProvider.notifier).pause();
                } else {
                  ref.read(audioServiceProvider.notifier).playAyah(
                        surahNumber: ayah.surahNumber,
                        ayahNumber: ayah.ayahNumber,
                      );
                }
              },
            ),
            const SizedBox(width: 4),
            IconButton(
              iconSize: 20,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(maxWidth: 32, maxHeight: 32),
              icon: const Icon(Icons.bookmark_border, color: AppColors.textSecondary),
              onPressed: () {},
            ),
          ],
        ),
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              ArabicUtils.toArabicNumerals(ayah.ayahNumber),
              style: const TextStyle(
                fontFamily: 'AmiriQuran',
                fontSize: 13,
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
