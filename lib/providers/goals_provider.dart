import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/local_fitness_storage.dart';
import '../models/fitness_goal.dart';

class GoalsNotifier extends StateNotifier<List<FitnessGoal>> {
  GoalsNotifier(this._storage) : super(const []) {
    _restore();
  }

  final LocalFitnessStorage _storage;
  bool _hasLocalChanges = false;
  Future<void> _pendingSave = Future.value();

  Future<void> _restore() async {
    try {
      final saved = await _storage.loadGoals();
      if (!_hasLocalChanges && saved != null) state = saved;
    } catch (_) {
      // Keep the in-memory defaults if local storage is unavailable or invalid.
    }
  }

  void _persist() {
    _hasLocalChanges = true;
    final snapshot = List<FitnessGoal>.of(state);
    _pendingSave = _pendingSave.then((_) async {
      try {
        await _storage.saveGoals(snapshot);
      } catch (_) {
        // A storage failure should not interrupt goal management.
      }
    });
  }

  void addGoal(FitnessGoal goal) {
    state = [...state, goal];
    _persist();
  }

  void removeGoal(String id) {
    state = state.where((goal) => goal.id != id).toList();
    _persist();
  }

  Future<void> clear() {
    state = const [];
    _hasLocalChanges = true;
    _pendingSave = _pendingSave.then((_) async {
      try {
        await _storage.clearGoals();
      } catch (_) {
        // A storage failure should not interrupt goal management.
      }
    });
    return _pendingSave;
  }

  void updateProgress(String id, double amount) {
    state = [
      for (final goal in state)
        if (goal.id == id)
          FitnessGoal(
            id: goal.id,
            title: goal.title,
            current: (goal.current + amount).clamp(0, goal.target).toDouble(),
            target: goal.target,
            unit: goal.unit,
            type: goal.type,
          )
        else
          goal,
    ];
    _persist();
  }
}

final goalsProvider = StateNotifierProvider<GoalsNotifier, List<FitnessGoal>>(
  (ref) => GoalsNotifier(ref.read(localFitnessStorageProvider)),
);
