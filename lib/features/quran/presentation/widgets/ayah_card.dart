import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/arabic_utils.dart';
import '../../../../database/app_database.dart';
import '../providers/audio_provider.dart';

class AyahCard extends ConsumerWidget {
  final Ayah ayah;
  final double fontSize;
  final int totalAyahsInSurah;

  const AyahCard({
    super.key,
    required this.ayah,
    required this.totalAyahsInSurah,
    this.fontSize = 22,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playing = ref.watch(currentlyPlayingProvider);
    final isActive = playing != null &&
        playing.surah == ayah.surahNumber &&
        playing.ayah == ayah.ayahNumber;
    final audioState = ref.watch(audioServiceProvider);
    final isPlaying = isActive && audioState.isPlaying;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.primary.withOpacity(0.06)
            : Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(12),
        border: isActive
            ? Border.all(color: AppColors.primary.withOpacity(0.3))
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(context, ref, isActive, isPlaying, audioState.isLoading),
            const SizedBox(height: 12),
            Text(
              ayah.textUthmani,
              style: AppTypography.quranAyah.copyWith(
                fontSize: fontSize,
                color: isActive ? AppColors.primary : AppColors.textQuran,
              ),
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref, bool isActive,
      bool isPlaying, bool isLoading) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            // Play / pause / loading button
            SizedBox(
              width: 32,
              height: 32,
              child: isActive && isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(4),
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: AppColors.primary),
                    )
                  : IconButton(
                      iconSize: 20,
                      padding: EdgeInsets.zero,
                      constraints:
                          const BoxConstraints(maxWidth: 32, maxHeight: 32),
                      icon: Icon(
                        isPlaying
                            ? Icons.pause_circle
                            : Icons.play_circle_outline,
                        color: AppColors.primary,
                      ),
                      onPressed: () => _handleTap(ref, isPlaying),
                    ),
            ),
            const SizedBox(width: 4),
            IconButton(
              iconSize: 20,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(maxWidth: 32, maxHeight: 32),
              icon: const Icon(Icons.bookmark_border,
                  color: AppColors.textSecondary),
              onPressed: () {},
            ),
          ],
        ),
        // Ayah number badge
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

  void _handleTap(WidgetRef ref, bool isPlaying) {
    final notifier = ref.read(audioServiceProvider.notifier);
    if (isPlaying) {
      notifier.pause();
    } else {
      final playing = ref.read(currentlyPlayingProvider);
      final isActive = playing != null &&
          playing.surah == ayah.surahNumber &&
          playing.ayah == ayah.ayahNumber;
      if (isActive) {
        notifier.resume();
      } else {
        notifier.playAyah(
          surahNumber: ayah.surahNumber,
          ayahNumber: ayah.ayahNumber,
          totalAyahs: totalAyahsInSurah,
        );
      }
    }
  }
}
