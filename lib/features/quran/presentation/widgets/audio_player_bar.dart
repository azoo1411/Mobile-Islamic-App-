import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/arabic_utils.dart';
import '../providers/audio_provider.dart';

class AudioPlayerBar extends ConsumerWidget {
  const AudioPlayerBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioState = ref.watch(audioServiceProvider);
    if (!audioState.isVisible) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  _buildProgressIndicator(audioState),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'سورة ${ArabicUtils.toArabicNumerals(audioState.surahNumber)} · آية ${ArabicUtils.toArabicNumerals(audioState.ayahNumber)}',
                          style: AppTypography.caption,
                          textDirection: TextDirection.rtl,
                        ),
                        Text(
                          _reciterName(audioState.reciterId),
                          style: AppTypography.bodySmall.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.skip_next),
                        color: AppColors.primary,
                        onPressed: () =>
                            ref.read(audioServiceProvider.notifier).next(),
                      ),
                      IconButton(
                        icon: Icon(
                          audioState.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                          size: 32,
                        ),
                        color: AppColors.primary,
                        onPressed: () {
                          if (audioState.isPlaying) {
                            ref.read(audioServiceProvider.notifier).pause();
                          } else {
                            ref.read(audioServiceProvider.notifier).resume();
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.skip_previous),
                        color: AppColors.primary,
                        onPressed: () =>
                            ref.read(audioServiceProvider.notifier).previous(),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(AudioState state) {
    return SizedBox(
      width: 40,
      height: 40,
      child: CircularProgressIndicator(
        value: state.isLoading ? null : state.progress,
        backgroundColor: AppColors.divider,
        color: AppColors.primary,
        strokeWidth: 3,
      ),
    );
  }

  String _reciterName(String id) {
    return AppConstants.reciters
        .firstWhere((r) => r['id'] == id,
            orElse: () => {'name': 'قارئ مجهول'})['name']!;
  }
}
