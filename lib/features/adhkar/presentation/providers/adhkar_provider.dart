import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdhkarState {
  final Map<String, int> counts;
  const AdhkarState(this.counts);
  int get(String key) => counts[key] ?? 0;
  bool done(String key, int required) => (counts[key] ?? 0) >= required;
}

class AdhkarNotifier extends StateNotifier<AdhkarState> {
  AdhkarNotifier() : super(const AdhkarState({})) {
    _load();
  }

  static const _prefKey = 'adhkar_counts_v1';

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_prefKey);
    if (json == null) return;
    final raw = jsonDecode(json) as Map<String, dynamic>;
    state = AdhkarState(raw.map((k, v) => MapEntry(k, v as int)));
  }

  Future<void> increment(String key, int maxCount) async {
    final current = state.counts[key] ?? 0;
    if (current >= maxCount) return;
    final next = Map<String, int>.from(state.counts)..[key] = current + 1;
    state = AdhkarState(next);
    await _save();
  }

  Future<void> resetCategory(String categoryId) async {
    final next = Map<String, int>.from(state.counts)
      ..removeWhere((k, _) => k.startsWith('${categoryId}_'));
    state = AdhkarState(next);
    await _save();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, jsonEncode(state.counts));
  }
}

final adhkarProvider =
    StateNotifierProvider<AdhkarNotifier, AdhkarState>((_) => AdhkarNotifier());
