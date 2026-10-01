import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/mock_data.dart';
import '../models/exercise.dart';
import '../models/workout.dart';

class ActiveWorkoutState {
  final Workout? workout;
  final int currentExerciseIndex;
  final int currentSet;
  final List<int> completedSetsByExercise;
  final bool isComplete;
  final String? sessionId;

  const ActiveWorkoutState({
    this.workout,
    this.currentExerciseIndex = 0,
    this.currentSet = 1,
    this.completedSetsByExercise = const [],
    this.isComplete = false,
    this.sessionId,
  });

  Exercise? get currentExercise =>
      workout == null ? null : workout!.exercises[currentExerciseIndex];

  int get totalExercises => workout?.exercises.length ?? 0;

  int get totalSets => workout?.totalSets ?? 0;

  double get progressPercent {
    if (workout == null || totalExercises == 0) return 0;
    if (isComplete) return 100;
    final completedSets = completedSetsByExercise.fold<int>(
      0,
      (sum, sets) => sum + sets,
    );
    return ((completedSets + currentSet - 1) / totalSets) * 100;
  }

  ActiveWorkoutState copyWith({
    Workout? workout,
    int? currentExerciseIndex,
    int? currentSet,
    List<int>? completedSetsByExercise,
    bool? isComplete,
    String? sessionId,
  }) {
    return ActiveWorkoutState(
      workout: workout ?? this.workout,
      currentExerciseIndex: currentExerciseIndex ?? this.currentExerciseIndex,
      currentSet: currentSet ?? this.currentSet,
      completedSetsByExercise:
          completedSetsByExercise ?? this.completedSetsByExercise,
      isComplete: isComplete ?? this.isComplete,
      sessionId: sessionId ?? this.sessionId,
    );
  }
}

class ActiveWorkoutNotifier extends StateNotifier<ActiveWorkoutState> {
  ActiveWorkoutNotifier() : super(const ActiveWorkoutState());

  void startWorkout(String workoutId) {
    final workout = workoutList.firstWhere(
      (item) => item.id == workoutId,
      orElse: () => workoutList.first,
    );

    state = ActiveWorkoutState(
      workout: workout,
      currentExerciseIndex: 0,
      currentSet: 1,
      completedSetsByExercise: List<int>.filled(workout.exercises.length, 0),
      isComplete: false,
      sessionId: DateTime.now().microsecondsSinceEpoch.toString(),
    );
  }

  void completeSet() {
    if (state.workout == null) return;

    final exercise = state.currentExercise!;
    final updated = [...state.completedSetsByExercise];
    updated[state.currentExerciseIndex] = state.currentSet;

    final nextSet = state.currentSet + 1;
    if (nextSet <= exercise.sets) {
      state = state.copyWith(
        currentSet: nextSet,
        completedSetsByExercise: updated,
      );
      return;
    }

    final nextIndex = state.currentExerciseIndex + 1;
    if (nextIndex < state.workout!.exercises.length) {
      state = state.copyWith(
        currentExerciseIndex: nextIndex,
        currentSet: 1,
        completedSetsByExercise: updated,
      );
      return;
    }

    state = state.copyWith(completedSetsByExercise: updated, isComplete: true);
  }

  void previousExercise() {
    if (state.workout == null) return;
    if (state.currentExerciseIndex > 0) {
      state = state.copyWith(
        currentExerciseIndex: state.currentExerciseIndex - 1,
        currentSet: 1,
      );
    }
  }

  void nextExercise() {
    if (state.workout == null) return;
    if (state.currentExerciseIndex < state.workout!.exercises.length - 1) {
      state = state.copyWith(
        currentExerciseIndex: state.currentExerciseIndex + 1,
        currentSet: 1,
      );
    }
  }

  void reset() {
    state = const ActiveWorkoutState();
  }
}

final activeWorkoutProvider =
    StateNotifierProvider<ActiveWorkoutNotifier, ActiveWorkoutState>(
      (ref) => ActiveWorkoutNotifier(),
    );
