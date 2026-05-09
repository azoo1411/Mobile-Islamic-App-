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
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              // Progress ring
              _ProgressRing(state: audioState),
              const SizedBox(width: 10),

              // Info (surah · ayah + reciter tap-to-change)
              Expanded(
                child: GestureDetector(
                  onTap: () => _showReciterPicker(context, ref, audioState),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'سورة ${ArabicUtils.toArabicNumerals(audioState.surahNumber)}'
                        ' · آية ${ArabicUtils.toArabicNumerals(audioState.ayahNumber)}',
                        style: AppTypography.caption,
                        textDirection: TextDirection.rtl,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.swap_horiz,
                              size: 13, color: AppColors.textSecondary),
                          const SizedBox(width: 3),
                          Text(
                            _reciterName(audioState.reciterId),
                            style: AppTypography.bodySmall
                                .copyWith(fontWeight: FontWeight.w700),
                            textDirection: TextDirection.rtl,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 4),

              // Controls
              IconButton(
                icon: const Icon(Icons.skip_next, size: 22),
                color: AppColors.primary,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                onPressed: () => ref.read(audioServiceProvider.notifier).next(),
              ),
              IconButton(
                icon: Icon(
                  audioState.isPlaying ? Icons.pause_circle : Icons.play_circle,
                  size: 36,
                ),
                color: AppColors.primary,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                onPressed: () {
                  if (audioState.isPlaying) {
                    ref.read(audioServiceProvider.notifier).pause();
                  } else {
                    ref.read(audioServiceProvider.notifier).resume();
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.skip_previous, size: 22),
                color: AppColors.primary,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                onPressed: () =>
                    ref.read(audioServiceProvider.notifier).previous(),
              ),
              // Close
              IconButton(
                icon: const Icon(Icons.close, size: 18),
                color: AppColors.textSecondary,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                onPressed: () => ref.read(audioServiceProvider.notifier).hide(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showReciterPicker(
      BuildContext context, WidgetRef ref, AudioState state) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _ReciterSheet(currentId: state.reciterId, ref: ref),
    );
  }

  String _reciterName(String id) => AppConstants.reciters
      .firstWhere((r) => r['id'] == id,
          orElse: () => {'name': 'قارئ'})['name']!;
}

// ─── Progress ring ────────────────────────────────────────────────────────────

class _ProgressRing extends StatelessWidget {
  final AudioState state;
  const _ProgressRing({required this.state});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 38,
      height: 38,
      child: CircularProgressIndicator(
        value: state.isLoading ? null : state.progress,
        backgroundColor: AppColors.divider,
        color: AppColors.primary,
        strokeWidth: 3,
      ),
    );
  }
}

// ─── Reciter picker sheet ─────────────────────────────────────────────────────

class _ReciterSheet extends StatelessWidget {
  final String currentId;
  final WidgetRef ref;
  const _ReciterSheet({required this.currentId, required this.ref});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFBF9F5),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Text(
              'اختر القارئ',
              style: TextStyle(
                fontFamily: 'NotoNaskhArabic',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1B4D3E),
              ),
            ),
          ),
          const Divider(height: 1),
          ...AppConstants.reciters.map((r) {
            final isSelected = r['id'] == currentId;
            return ListTile(
              onTap: () {
                ref
                    .read(audioServiceProvider.notifier)
                    .changeReciter(r['id']!);
                Navigator.pop(context);
              },
              trailing: Text(
                r['name']!,
                style: TextStyle(
                  fontFamily: 'NotoNaskhArabic',
                  fontSize: 15,
                  fontWeight:
                      isSelected ? FontWeight.w700 : FontWeight.w400,
                  color: isSelected
                      ? const Color(0xFF1B4D3E)
                      : const Color(0xFF555555),
                ),
              ),
              leading: isSelected
                  ? const Icon(Icons.check_circle,
                      color: Color(0xFF1B4D3E), size: 20)
                  : const Icon(Icons.radio_button_unchecked,
                      color: Colors.grey, size: 20),
            );
          }),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
