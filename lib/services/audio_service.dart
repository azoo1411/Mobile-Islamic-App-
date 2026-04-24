import 'package:just_audio/just_audio.dart';

import '../core/constants/app_constants.dart';

class QuranAudioService {
  final AudioPlayer _player = AudioPlayer();

  String _buildAudioUrl(int surah, int ayah, String reciterId) {
    final surahStr = surah.toString().padLeft(3, '0');
    final ayahStr = ayah.toString().padLeft(3, '0');
    return '${AppConstants.audioBaseUrl}/$reciterId/$surahStr$ayahStr.mp3';
  }

  Future<void> playAyah({
    required int surahNumber,
    required int ayahNumber,
    String reciterId = AppConstants.defaultReciter,
  }) async {
    final url = _buildAudioUrl(surahNumber, ayahNumber, reciterId);
    await _player.setUrl(url);
    await _player.play();
  }

  Future<void> pause() => _player.pause();
  Future<void> resume() => _player.play();
  Future<void> stop() => _player.stop();
  Future<void> seek(Duration position) => _player.seek(position);

  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration?> get durationStream => _player.durationStream;
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  Duration? get currentDuration => _player.duration;
  bool get isPlaying => _player.playing;

  void dispose() => _player.dispose();
}
