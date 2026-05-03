import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AdhanVoice {
  madani('madani', 'الأذان المدني', 'عبدالرحمن خاشقجي'),
  makki('makki', 'الأذان المكي', 'هاشم السقاف');

  final String key;
  final String label;
  final String muezzin;
  const AdhanVoice(this.key, this.label, this.muezzin);
}

class AdhanSettings {
  final AdhanVoice voice;
  final Map<String, bool> enabledPrayers;

  const AdhanSettings({
    required this.voice,
    required this.enabledPrayers,
  });

  static const _defaultEnabled = {
    'fajr': true,
    'dhuhr': true,
    'asr': true,
    'maghrib': true,
    'isha': true,
  };

  static const AdhanSettings defaults = AdhanSettings(
    voice: AdhanVoice.madani,
    enabledPrayers: _defaultEnabled,
  );

  AdhanSettings copyWith({
    AdhanVoice? voice,
    Map<String, bool>? enabledPrayers,
  }) {
    return AdhanSettings(
      voice: voice ?? this.voice,
      enabledPrayers: enabledPrayers ?? this.enabledPrayers,
    );
  }

  bool isPrayerEnabled(String prayerKey) =>
      enabledPrayers[prayerKey] ?? true;

  int get enabledCount =>
      enabledPrayers.values.where((v) => v).length;
}

class AdhanSettingsNotifier extends AsyncNotifier<AdhanSettings> {
  static const _keyVoice = 'adhan_voice';
  static const _prayers = ['fajr', 'dhuhr', 'asr', 'maghrib', 'isha'];

  @override
  Future<AdhanSettings> build() async {
    final prefs = await SharedPreferences.getInstance();
    final voiceKey = prefs.getString(_keyVoice) ?? AdhanVoice.madani.key;
    final voice = AdhanVoice.values.firstWhere(
      (v) => v.key == voiceKey,
      orElse: () => AdhanVoice.madani,
    );
    final enabled = {
      for (final p in _prayers)
        p: prefs.getBool('adhan_$p') ?? true,
    };
    return AdhanSettings(voice: voice, enabledPrayers: enabled);
  }

  Future<void> setVoice(AdhanVoice voice) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyVoice, voice.key);
    final current = state.valueOrNull ?? AdhanSettings.defaults;
    state = AsyncData(current.copyWith(voice: voice));
  }

  Future<void> togglePrayer(String prayerKey) async {
    final prefs = await SharedPreferences.getInstance();
    final current = state.valueOrNull ?? AdhanSettings.defaults;
    final newEnabled = Map<String, bool>.from(current.enabledPrayers);
    newEnabled[prayerKey] = !(newEnabled[prayerKey] ?? true);
    await prefs.setBool('adhan_$prayerKey', newEnabled[prayerKey]!);
    state = AsyncData(current.copyWith(enabledPrayers: newEnabled));
  }

  Future<void> setPrayer(String prayerKey, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    final current = state.valueOrNull ?? AdhanSettings.defaults;
    final newEnabled = Map<String, bool>.from(current.enabledPrayers);
    newEnabled[prayerKey] = value;
    await prefs.setBool('adhan_$prayerKey', value);
    state = AsyncData(current.copyWith(enabledPrayers: newEnabled));
  }
}

final adhanSettingsProvider =
    AsyncNotifierProvider<AdhanSettingsNotifier, AdhanSettings>(
  AdhanSettingsNotifier.new,
);
