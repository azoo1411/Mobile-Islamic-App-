import 'package:just_audio/just_audio.dart';

import '../core/constants/app_constants.dart';

class QuranAudioService {
  final AudioPlayer _player = AudioPlayer();

  String _buildUrl(int surah, int ayah, String reciterId) {
    final path = AppConstants.reciters
        .firstWhere(
          (r) => r['id'] == reciterId,
          orElse: () => AppConstants.reciters.first,
        )['path']!;
    final file =
        '${surah.toString().padLeft(3, '0')}${ayah.toString().padLeft(3, '0')}.mp3';
    return '${AppConstants.audioBaseUrl}/$path/$file';
  }

  Future<void> playAyah({
    required int surahNumber,
    required int ayahNumber,
    String reciterId = AppConstants.defaultReciter,
    void Function()? onComplete,
  }) async {
    final url = _buildUrl(surahNumber, ayahNumber, reciterId);
    try {
      await _player.stop();
      await _player.setUrl(url);
      _player.playerStateStream
          .where((s) => s.processingState == ProcessingState.completed)
          .take(1)
          .listen((_) => onComplete?.call());
      await _player.play();
    } catch (_) {}
  }

  Future<void> pause() => _player.pause();
  Future<void> resume() => _player.play();
  Future<void> stop() => _player.stop();

  Stream<Duration?> get positionStream => _player.positionStream;
  Stream<Duration?> get durationStream => _player.durationStream;
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  bool get isPlaying => _player.playing;

  void dispose() => _player.dispose();
}
