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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _SeekBar(audioState: audioState),
            _Controls(audioState: audioState),
          ],
        ),
      ),
    );
  }
}

// ─── Seek bar ─────────────────────────────────────────────────────────────────

class _SeekBar extends ConsumerWidget {
  final AudioState audioState;
  const _SeekBar({required this.audioState});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 0),
      child: Row(
        children: [
          Text(
            _fmt(audioState.position),
            style: AppTypography.caption.copyWith(fontSize: 11),
          ),
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                thumbShape:
                    const RoundSliderThumbShape(enabledThumbRadius: 6),
                overlayShape:
                    const RoundSliderOverlayShape(overlayRadius: 12),
                trackHeight: 3,
              ),
              child: Slider(
                value: audioState.progress.clamp(0.0, 1.0),
                activeColor: AppColors.primary,
                inactiveColor: AppColors.divider,
                onChanged: audioState.duration.inMilliseconds > 0
                    ? (v) => ref.read(audioServiceProvider.notifier).seek(v)
                    : null,
              ),
            ),
          ),
          Text(
            _fmt(audioState.duration),
            style: AppTypography.caption.copyWith(fontSize: 11),
          ),
        ],
      ),
    );
  }

  String _fmt(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}

// ─── Controls row ─────────────────────────────────────────────────────────────

class _Controls extends ConsumerWidget {
  final AudioState audioState;
  const _Controls({required this.audioState});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(audioServiceProvider.notifier);

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: Row(
        children: [
          // Reciter picker
          InkWell(
            onTap: () => _showReciterPicker(context, ref),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.mic_none,
                      size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    _shortName(audioState.reciterId),
                    style: AppTypography.caption,
                  ),
                  const Icon(Icons.keyboard_arrow_down,
                      size: 16, color: AppColors.textSecondary),
                ],
              ),
            ),
          ),
          const Spacer(),
          // Ayah label
          Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              'س ${ArabicUtils.toArabicNumerals(audioState.surahNumber)} · آ ${ArabicUtils.toArabicNumerals(audioState.ayahNumber)}',
              style: AppTypography.caption,
            ),
          ),
          const Spacer(),
          // Skip previous
          IconButton(
            iconSize: 22,
            icon: const Icon(Icons.skip_previous),
            color: AppColors.primary,
            onPressed: notifier.previous,
          ),
          // Play / Pause / Loading
          if (audioState.isLoading)
            const SizedBox(
              width: 40,
              height: 40,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primary,
                ),
              ),
            )
          else
            IconButton(
              iconSize: 38,
              icon: Icon(
                audioState.isPlaying ? Icons.pause_circle : Icons.play_circle,
              ),
              color: AppColors.primary,
              onPressed: audioState.isPlaying ? notifier.pause : notifier.resume,
            ),
          // Skip next
          IconButton(
            iconSize: 22,
            icon: const Icon(Icons.skip_next),
            color: AppColors.primary,
            onPressed: notifier.next,
          ),
          // Stop
          IconButton(
            iconSize: 22,
            icon: const Icon(Icons.stop_circle_outlined),
            color: AppColors.textSecondary,
            onPressed: notifier.stop,
          ),
        ],
      ),
    );
  }

  String _shortName(String id) {
    final name = AppConstants.reciters
        .firstWhere((r) => r['id'] == id,
            orElse: () => {'name': 'قارئ'})['name']!;
    final words = name.split(' ');
    return words.take(2).join(' ');
  }

  void _showReciterPicker(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text('اختر القارئ', style: AppTypography.heading3),
            ),
            const Divider(height: 1),
            ...AppConstants.reciters.map(
              (reciter) => ListTile(
                title: Text(reciter['name']!, style: AppTypography.body),
                trailing: audioState.reciterId == reciter['id']
                    ? const Icon(Icons.check, color: AppColors.primary)
                    : null,
                onTap: () {
                  ref
                      .read(audioServiceProvider.notifier)
                      .selectReciter(reciter['id']!);
                  Navigator.pop(context);
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
