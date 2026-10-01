import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/local_fitness_storage.dart';
import '../data/mock_data.dart';
import '../models/workout_history_entry.dart';

class ProgressState {
  final int workouts;
  final int caloriesBurned;
  final int activeMinutes;
  final int steps;
  final List<int> weeklyActivity;
  final List<String> completedWorkoutIds;
  final List<WorkoutHistoryEntry> workoutHistory;

  const ProgressState({
    this.workouts = 0,
    this.caloriesBurned = 0,
    this.activeMinutes = 0,
    this.steps = 0,
    this.weeklyActivity = const [0, 0, 0, 0, 0, 0, 0],
    this.completedWorkoutIds = const [],
    this.workoutHistory = const [],
  });

  ProgressState copyWith({
    int? workouts,
    int? caloriesBurned,
    int? activeMinutes,
    int? steps,
    List<int>? weeklyActivity,
    List<String>? completedWorkoutIds,
    List<WorkoutHistoryEntry>? workoutHistory,
  }) {
    return ProgressState(
      workouts: workouts ?? this.workouts,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      activeMinutes: activeMinutes ?? this.activeMinutes,
      steps: steps ?? this.steps,
      weeklyActivity: weeklyActivity ?? this.weeklyActivity,
      completedWorkoutIds: completedWorkoutIds ?? this.completedWorkoutIds,
      workoutHistory: workoutHistory ?? this.workoutHistory,
    );
  }
}

class ProgressNotifier extends StateNotifier<ProgressState> {
  ProgressNotifier([LocalFitnessStorage? storage])
    : _storage = storage ?? LocalFitnessStorage(),
      super(const ProgressState()) {
    _restore();
  }

  final LocalFitnessStorage _storage;
  bool _hasLocalChanges = false;
  Future<void> _pendingSave = Future.value();

  Future<void> _restore() async {
    try {
      final saved = await _storage.loadProgress();
      if (!_hasLocalChanges && saved != null) state = saved;
    } catch (_) {
      // Keep the in-memory defaults if local storage is unavailable or invalid.
    }
  }

  void _persist() {
    _hasLocalChanges = true;
    final snapshot = state;
    _pendingSave = _pendingSave.then((_) async {
      try {
        await _storage.saveProgress(snapshot);
      } catch (_) {
        // A storage failure should not interrupt activity tracking.
      }
    });
  }

  Future<void> clear() {
    state = const ProgressState();
    _hasLocalChanges = true;
    _pendingSave = _pendingSave.then((_) async {
      try {
        await _storage.clearProgress();
      } catch (_) {
        // A storage failure should not interrupt activity tracking.
      }
    });
    return _pendingSave;
  }

  void recordSteps(int amount) {
    if (amount <= 0) return;
    state = state.copyWith(steps: state.steps + amount);
    _persist();
  }

  void recordWorkoutCompletion(String workoutId, {String? sessionId}) {
    final completionId = sessionId ?? workoutId;
    if (state.completedWorkoutIds.contains(completionId)) return;
    final workout = workoutList.firstWhere(
      (item) => item.id == workoutId,
      orElse: () => workoutList.first,
    );

    final updatedWorkouts = state.workouts + 1;
    final updatedCalories = state.caloriesBurned + workout.calories;
    final updatedMinutes = state.activeMinutes + workout.duration;
    final updatedWeekly = [...state.weeklyActivity];
    final weekdayIndex = DateTime.now().weekday - 1;
    updatedWeekly[weekdayIndex] += workout.calories;

    state = state.copyWith(
      workouts: updatedWorkouts,
      caloriesBurned: updatedCalories,
      activeMinutes: updatedMinutes,
      weeklyActivity: updatedWeekly,
      completedWorkoutIds: [...state.completedWorkoutIds, completionId],
      workoutHistory: [
        WorkoutHistoryEntry(
          workoutId: workout.id,
          completedAt: DateTime.now(),
          calories: workout.calories,
          durationMinutes: workout.duration,
        ),
        ...state.workoutHistory,
      ],
    );
    _persist();
  }
}

final progressProvider = StateNotifierProvider<ProgressNotifier, ProgressState>(
  (ref) => ProgressNotifier(ref.read(localFitnessStorageProvider)),
);

final progressStatsProvider = Provider<Map<String, String>>((ref) {
  final state = ref.watch(progressProvider);
  return {
    'calories': '${state.caloriesBurned} kcal',
    'workouts': '${state.workouts}',
    'activeMinutes': '${state.activeMinutes}',
    'steps': '${state.steps}',
  };
});
