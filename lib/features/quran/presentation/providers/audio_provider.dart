import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../services/audio_service.dart';

// ─── State ────────────────────────────────────────────────────────────────────

class AudioState {
  final bool isVisible;
  final bool isPlaying;
  final bool isLoading;
  final int surahNumber;
  final int ayahNumber;
  final int totalAyahs;
  final String reciterId;
  final double progress;
  final Duration position;
  final Duration duration;

  const AudioState({
    this.isVisible = false,
    this.isPlaying = false,
    this.isLoading = false,
    this.surahNumber = 1,
    this.ayahNumber = 1,
    this.totalAyahs = 0,
    this.reciterId = 'Alafasy_128kbps',
    this.progress = 0.0,
    this.position = Duration.zero,
    this.duration = Duration.zero,
  });

  AudioState copyWith({
    bool? isVisible,
    bool? isPlaying,
    bool? isLoading,
    int? surahNumber,
    int? ayahNumber,
    int? totalAyahs,
    String? reciterId,
    double? progress,
    Duration? position,
    Duration? duration,
  }) =>
      AudioState(
        isVisible: isVisible ?? this.isVisible,
        isPlaying: isPlaying ?? this.isPlaying,
        isLoading: isLoading ?? this.isLoading,
        surahNumber: surahNumber ?? this.surahNumber,
        ayahNumber: ayahNumber ?? this.ayahNumber,
        totalAyahs: totalAyahs ?? this.totalAyahs,
        reciterId: reciterId ?? this.reciterId,
        progress: progress ?? this.progress,
        position: position ?? this.position,
        duration: duration ?? this.duration,
      );
}

// ─── Notifier ─────────────────────────────────────────────────────────────────

class AudioServiceNotifier extends StateNotifier<AudioState> {
  final QuranAudioService _service;
  StreamSubscription<PlayerState>? _playerStateSub;
  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<Duration?>? _durationSub;

  AudioServiceNotifier(this._service) : super(const AudioState()) {
    _initStreams();
  }

  void _initStreams() {
    _playerStateSub = _service.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        _handleCompletion();
      } else {
        state = state.copyWith(isPlaying: playerState.playing);
      }
    });

    _positionSub = _service.positionStream.listen((position) {
      final durationMs = state.duration.inMilliseconds;
      final progress =
          durationMs > 0 ? position.inMilliseconds / durationMs : 0.0;
      state = state.copyWith(
        position: position,
        progress: progress.clamp(0.0, 1.0),
      );
    });

    _durationSub = _service.durationStream.listen((duration) {
      if (duration != null) {
        state = state.copyWith(duration: duration);
      }
    });
  }

  void _handleCompletion() {
    if (state.totalAyahs > 0 && state.ayahNumber < state.totalAyahs) {
      playAyah(
        surahNumber: state.surahNumber,
        ayahNumber: state.ayahNumber + 1,
        totalAyahs: state.totalAyahs,
      );
    } else {
      state = state.copyWith(isPlaying: false, progress: 1.0);
    }
  }

  Future<void> playAyah({
    required int surahNumber,
    required int ayahNumber,
    String? reciterId,
    int? totalAyahs,
  }) async {
    state = state.copyWith(
      isVisible: true,
      isPlaying: false,
      isLoading: true,
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      reciterId: reciterId ?? state.reciterId,
      totalAyahs: totalAyahs ?? state.totalAyahs,
      progress: 0.0,
      position: Duration.zero,
      duration: Duration.zero,
    );
    try {
      await _service.playAyah(
        surahNumber: surahNumber,
        ayahNumber: ayahNumber,
        reciterId: reciterId ?? state.reciterId,
      );
      state = state.copyWith(isLoading: false, isPlaying: true);
    } catch (_) {
      state = state.copyWith(isLoading: false, isPlaying: false);
    }
  }

  void pause() {
    _service.pause();
    state = state.copyWith(isPlaying: false);
  }

  void resume() {
    _service.resume();
    state = state.copyWith(isPlaying: true);
  }

  Future<void> stop() async {
    await _service.stop();
    state = state.copyWith(
      isPlaying: false,
      isVisible: false,
      progress: 0.0,
      position: Duration.zero,
    );
  }

  void selectReciter(String reciterId) {
    if (reciterId == state.reciterId) return;
    if (state.isVisible) {
      playAyah(
        surahNumber: state.surahNumber,
        ayahNumber: state.ayahNumber,
        reciterId: reciterId,
        totalAyahs: state.totalAyahs,
      );
    } else {
      state = state.copyWith(reciterId: reciterId);
    }
  }

  Future<void> seek(double progress) async {
    final targetMs = (state.duration.inMilliseconds * progress).round();
    final target = Duration(milliseconds: targetMs);
    await _service.seek(target);
    state = state.copyWith(progress: progress, position: target);
  }

  void next() {
    if (state.totalAyahs == 0 || state.ayahNumber < state.totalAyahs) {
      playAyah(
        surahNumber: state.surahNumber,
        ayahNumber: state.ayahNumber + 1,
        totalAyahs: state.totalAyahs,
      );
    }
  }

  void previous() {
    final prevAyah = (state.ayahNumber - 1).clamp(1, 999);
    playAyah(
      surahNumber: state.surahNumber,
      ayahNumber: prevAyah,
      totalAyahs: state.totalAyahs,
    );
  }

  @override
  void dispose() {
    _playerStateSub?.cancel();
    _positionSub?.cancel();
    _durationSub?.cancel();
    _service.dispose();
    super.dispose();
  }
}

// ─── Providers ────────────────────────────────────────────────────────────────

final audioServiceProvider =
    StateNotifierProvider<AudioServiceNotifier, AudioState>((ref) {
  return AudioServiceNotifier(QuranAudioService());
});

// Returns the surah+ayah currently loaded in the player (playing or paused).
// Used by AyahCard to highlight the active ayah.
final currentlyPlayingProvider = Provider<({int surah, int ayah})?>(
  (ref) {
    final s = ref.watch(audioServiceProvider);
    if (!s.isVisible) return null;
    return (surah: s.surahNumber, ayah: s.ayahNumber);
  },
);
