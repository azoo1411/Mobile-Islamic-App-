import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../database/app_database.dart';
import '../../../../services/audio_service.dart';

// ─── State ───────────────────────────────────────────────────────────────────

class AudioState {
  final bool isVisible;
  final bool isPlaying;
  final int surahNumber;
  final int ayahNumber;
  final String reciterId;
  final double progress; // 0.0 – 1.0

  const AudioState({
    this.isVisible = false,
    this.isPlaying = false,
    this.surahNumber = 1,
    this.ayahNumber = 1,
    this.reciterId = 'Alafasy_128kbps',
    this.progress = 0.0,
  });

  AudioState copyWith({
    bool? isVisible,
    bool? isPlaying,
    int? surahNumber,
    int? ayahNumber,
    String? reciterId,
    double? progress,
  }) =>
      AudioState(
        isVisible: isVisible ?? this.isVisible,
        isPlaying: isPlaying ?? this.isPlaying,
        surahNumber: surahNumber ?? this.surahNumber,
        ayahNumber: ayahNumber ?? this.ayahNumber,
        reciterId: reciterId ?? this.reciterId,
        progress: progress ?? this.progress,
      );
}

// ─── Notifier ────────────────────────────────────────────────────────────────

class AudioServiceNotifier extends StateNotifier<AudioState> {
  final QuranAudioService _service;

  AudioServiceNotifier(this._service) : super(const AudioState());

  Future<void> playAyah({
    required int surahNumber,
    required int ayahNumber,
    String? reciterId,
  }) async {
    state = state.copyWith(
      isVisible: true,
      isPlaying: true,
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      reciterId: reciterId ?? state.reciterId,
      progress: 0.0,
    );
    await _service.playAyah(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      reciterId: reciterId ?? state.reciterId,
    );
  }

  void pause() {
    _service.pause();
    state = state.copyWith(isPlaying: false);
  }

  void resume() {
    _service.resume();
    state = state.copyWith(isPlaying: true);
  }

  void next() {
    final nextAyah = state.ayahNumber + 1;
    playAyah(surahNumber: state.surahNumber, ayahNumber: nextAyah);
  }

  void previous() {
    final prevAyah = (state.ayahNumber - 1).clamp(1, 999);
    playAyah(surahNumber: state.surahNumber, ayahNumber: prevAyah);
  }

  void updateProgress(double progress) {
    state = state.copyWith(progress: progress);
  }
}

final audioServiceProvider =
    StateNotifierProvider<AudioServiceNotifier, AudioState>((ref) {
  return AudioServiceNotifier(QuranAudioService());
});

// Which ayah is currently highlighted
final currentlyPlayingAyahProvider = Provider<Ayah?>((ref) {
  final audioState = ref.watch(audioServiceProvider);
  if (!audioState.isPlaying) return null;
  // Returns a lightweight reference only — actual Ayah loaded via surahDetailsProvider
  return null;
});
