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
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, -4))],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              SizedBox(
                width: 36, height: 36,
                child: CircularProgressIndicator(
                  value: audioState.progress,
                  backgroundColor: AppColors.divider,
                  color: AppColors.primary,
                  strokeWidth: 3,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('سورة ${ArabicUtils.toArabicNumerals(audioState.surahNumber)} · آية ${ArabicUtils.toArabicNumerals(audioState.ayahNumber)}',
                        style: AppTypography.caption, textDirection: TextDirection.rtl),
                    GestureDetector(
                      onTap: () => _showReciterSheet(context, ref, audioState),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.keyboard_arrow_down, size: 16, color: AppColors.primary),
                          const SizedBox(width: 2),
                          Text(_reciterName(audioState.reciterId),
                              style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w700, color: AppColors.primary),
                              textDirection: TextDirection.rtl),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(icon: const Icon(Icons.skip_next), color: AppColors.primary,
                  onPressed: () => ref.read(audioServiceProvider.notifier).next()),
              IconButton(
                icon: Icon(audioState.isPlaying ? Icons.pause : Icons.play_arrow, size: 32),
                color: AppColors.primary,
                onPressed: () {
                  if (audioState.isPlaying) { ref.read(audioServiceProvider.notifier).pause(); }
                  else { ref.read(audioServiceProvider.notifier).resume(); }
                },
              ),
              IconButton(icon: const Icon(Icons.skip_previous), color: AppColors.primary,
                  onPressed: () => ref.read(audioServiceProvider.notifier).previous()),
            ],
          ),
        ),
      ),
    );
  }

  void _showReciterSheet(BuildContext context, WidgetRef ref, AudioState state) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  children: [
                    const Icon(Icons.mic, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text('اختر القارئ', style: AppTypography.heading3),
                  ],
                ),
              ),
              const Divider(height: 1),
              ...AppConstants.reciters.map((r) {
                final isSelected = r['id'] == state.reciterId;
                return ListTile(
                  onTap: () { ref.read(audioServiceProvider.notifier).setReciter(r['id']!); Navigator.pop(context); },
                  trailing: isSelected
                      ? const Icon(Icons.check_circle, color: AppColors.primary)
                      : const Icon(Icons.radio_button_unchecked, color: AppColors.textSecondary),
                  title: Text(r['name']!,
                      style: AppTypography.body.copyWith(
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
                          color: isSelected ? AppColors.primary : AppColors.textPrimary),
                      textDirection: TextDirection.rtl),
                );
              }),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  String _reciterName(String id) =>
      AppConstants.reciters.firstWhere((r) => r['id'] == id, orElse: () => {'name': 'قارئ مجهول'})['name']!;
}
