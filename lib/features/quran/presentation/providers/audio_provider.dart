import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../database/app_database.dart';
import '../../../../services/audio_service.dart';

// ─── State ───────────────────────────────────────────────────────────────────

class AudioState {
  final bool isVisible;
  final bool isPlaying;
  final bool isLoading;
  final int surahNumber;
  final int ayahNumber;
  final int totalAyahs;
  final String reciterId;
  final double progress;

  const AudioState({
    this.isVisible = false,
    this.isPlaying = false,
    this.isLoading = false,
    this.surahNumber = 1,
    this.ayahNumber = 1,
    this.totalAyahs = 7,
    this.reciterId = AppConstants.defaultReciter,
    this.progress = 0.0,
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
      );
}

// ─── Notifier ────────────────────────────────────────────────────────────────

class AudioServiceNotifier extends StateNotifier<AudioState> {
  final QuranAudioService _service;
  StreamSubscription<Duration?>? _posSub;
  StreamSubscription<Duration?>? _durSub;
  Duration _duration = Duration.zero;

  AudioServiceNotifier(this._service) : super(const AudioState()) {
    _durSub = _service.durationStream.listen((d) {
      if (d != null) _duration = d;
    });
    _posSub = _service.positionStream.listen((pos) {
      if (pos != null && _duration.inMilliseconds > 0) {
        state = state.copyWith(
          progress: pos.inMilliseconds / _duration.inMilliseconds,
        );
      }
    });
  }

  Future<void> playAyah({
    required int surahNumber,
    required int ayahNumber,
    int? totalAyahs,
    String? reciterId,
  }) async {
    state = state.copyWith(
      isVisible: true,
      isPlaying: false,
      isLoading: true,
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      totalAyahs: totalAyahs ?? state.totalAyahs,
      reciterId: reciterId ?? state.reciterId,
      progress: 0.0,
    );

    await _service.playAyah(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      reciterId: reciterId ?? state.reciterId,
      onComplete: _onAyahComplete,
    );

    state = state.copyWith(isPlaying: true, isLoading: false);
  }

  void _onAyahComplete() {
    if (!mounted) return;
    final next = state.ayahNumber + 1;
    if (next <= state.totalAyahs) {
      playAyah(surahNumber: state.surahNumber, ayahNumber: next);
    } else {
      state = state.copyWith(isPlaying: false, progress: 1.0);
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

  void next() {
    final next = state.ayahNumber + 1;
    if (next <= state.totalAyahs) {
      playAyah(surahNumber: state.surahNumber, ayahNumber: next);
    }
  }

  void previous() {
    final prev = (state.ayahNumber - 1).clamp(1, 999);
    playAyah(surahNumber: state.surahNumber, ayahNumber: prev);
  }

  void changeReciter(String reciterId) {
    state = state.copyWith(reciterId: reciterId, isPlaying: false);
    _service.stop();
  }

  void hide() {
    _service.stop();
    state = const AudioState();
  }

  @override
  void dispose() {
    _posSub?.cancel();
    _durSub?.cancel();
    _service.dispose();
    super.dispose();
  }
}

// ─── Providers ───────────────────────────────────────────────────────────────

final audioServiceProvider =
    StateNotifierProvider<AudioServiceNotifier, AudioState>((ref) {
  return AudioServiceNotifier(QuranAudioService());
});

final currentlyPlayingAyahProvider = Provider<({int surah, int ayah})?>(
  (ref) {
    final s = ref.watch(audioServiceProvider);
    if (!s.isVisible) return null;
    return (surah: s.surahNumber, ayah: s.ayahNumber);
  },
);
