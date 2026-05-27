import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../database/app_database.dart';
import '../../../../services/audio_service.dart';

class AudioState {
  final bool isVisible;
  final bool isPlaying;
  final int surahNumber;
  final int ayahNumber;
  final String reciterId;
  final double progress;

  const AudioState({
    this.isVisible   = false,
    this.isPlaying   = false,
    this.surahNumber = 1,
    this.ayahNumber  = 1,
    this.reciterId   = AppConstants.defaultReciter,
    this.progress    = 0.0,
  });

  AudioState copyWith({bool? isVisible, bool? isPlaying, int? surahNumber, int? ayahNumber, String? reciterId, double? progress}) =>
      AudioState(
        isVisible:   isVisible   ?? this.isVisible,
        isPlaying:   isPlaying   ?? this.isPlaying,
        surahNumber: surahNumber ?? this.surahNumber,
        ayahNumber:  ayahNumber  ?? this.ayahNumber,
        reciterId:   reciterId   ?? this.reciterId,
        progress:    progress    ?? this.progress,
      );
}

class AudioServiceNotifier extends StateNotifier<AudioState> {
  final QuranAudioService _service;
  SharedPreferences? _prefs;

  AudioServiceNotifier(this._service) : super(const AudioState()) {
    _loadSavedReciter();
  }

  Future<void> _loadSavedReciter() async {
    _prefs = await SharedPreferences.getInstance();
    final saved = _prefs!.getString(AppConstants.prefReciter) ?? AppConstants.defaultReciter;
    state = state.copyWith(reciterId: saved);
  }

  Future<void> setReciter(String reciterId) async {
    state = state.copyWith(reciterId: reciterId);
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.setString(AppConstants.prefReciter, reciterId);
  }

  Future<void> playAyah({required int surahNumber, required int ayahNumber, String? reciterId}) async {
    final rid = reciterId ?? state.reciterId;
    state = state.copyWith(isVisible: true, isPlaying: true, surahNumber: surahNumber, ayahNumber: ayahNumber, reciterId: rid, progress: 0.0);
    await _service.playAyah(surahNumber: surahNumber, ayahNumber: ayahNumber, reciterId: rid);
  }

  void pause()   { _service.pause();  state = state.copyWith(isPlaying: false); }
  void resume()  { _service.resume(); state = state.copyWith(isPlaying: true);  }
  void next()     => playAyah(surahNumber: state.surahNumber, ayahNumber: state.ayahNumber + 1);
  void previous() => playAyah(surahNumber: state.surahNumber, ayahNumber: (state.ayahNumber - 1).clamp(1, 999));
  void updateProgress(double p) => state = state.copyWith(progress: p);
}

final audioServiceProvider = StateNotifierProvider<AudioServiceNotifier, AudioState>((ref) {
  return AudioServiceNotifier(QuranAudioService());
});

final currentlyPlayingAyahProvider = Provider<Ayah?>((ref) {
  final s = ref.watch(audioServiceProvider);
  if (!s.isPlaying) return null;
  return null;
});
