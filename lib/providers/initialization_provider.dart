import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import '../services/database_seeder.dart';

enum InitPhase { idle, seedingSurahs, downloadingQuran, done, error }

class InitState {
  final InitPhase phase;
  final int current;
  final int total;
  final String? errorMessage;

  const InitState({
    this.phase = InitPhase.idle,
    this.current = 0,
    this.total = 6236,
    this.errorMessage,
  });

  double get progress => total > 0 ? current / total : 0.0;

  InitState copyWith({
    InitPhase? phase,
    int? current,
    int? total,
    String? errorMessage,
  }) =>
      InitState(
        phase: phase ?? this.phase,
        current: current ?? this.current,
        total: total ?? this.total,
        errorMessage: errorMessage ?? this.errorMessage,
      );
}

class InitializationNotifier extends StateNotifier<InitState> {
  final AppDatabase _db;

  InitializationNotifier(this._db) : super(const InitState());

  Future<void> initialize() async {
    if (state.phase == InitPhase.done) return;

    try {
      final seeder = DatabaseSeeder(_db);

      await seeder.seedIfNeeded(
        onProgress: (phase, current, total) {
          if (phase == 'surahs') {
            state = state.copyWith(phase: InitPhase.seedingSurahs, current: current, total: 1);
          } else if (phase == 'ayahs') {
            state = state.copyWith(phase: InitPhase.downloadingQuran, current: current, total: total);
          }
        },
      );

      state = state.copyWith(phase: InitPhase.done, current: state.total);
    } catch (e) {
      state = state.copyWith(
        phase: InitPhase.error,
        errorMessage: e.toString(),
      );
      rethrow;
    }
  }

  Future<void> retry() async {
    state = const InitState();
    await initialize();
  }
}

final initializationProvider =
    StateNotifierProvider<InitializationNotifier, InitState>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return InitializationNotifier(db);
});
