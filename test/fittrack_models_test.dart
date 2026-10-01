import 'package:flutter_test/flutter_test.dart';
import 'package:fittrack/models/workout.dart';
import 'package:fittrack/models/exercise.dart';
import 'package:fittrack/models/fitness_goal.dart';

void main() {
  group('FitTrack models', () {
    test('Workout total sets and completed progress are calculated correctly', () {
      final workout = Workout(
        id: 'w1',
        name: 'Full Body Strength',
        description: 'Power training session',
        difficulty: 'Intermediate',
        duration: 35,
        calories: 320,
        category: 'Strength',
        exercises: [
          const Exercise(id: 'e1', name: 'Squats', sets: 3, reps: 12, restSeconds: 45),
          const Exercise(id: 'e2', name: 'Push Ups', sets: 3, reps: 10, restSeconds: 30),
        ],
      );

      expect(workout.totalSets, 6);
      expect(workout.totalExercises, 2);
      expect(workout.progressPercent(1), closeTo(50, 0.1));
    });

    test('Goal completion percentage is computed using current and target values', () {
      const goal = FitnessGoal(
        id: 'g1',
        title: 'Walk 10,000 steps',
        current: 8426,
        target: 10000,
        unit: 'steps',
      );

      expect(goal.percentComplete, closeTo(84.26, 0.01));
      expect(goal.isComplete, isFalse);
    });
  });
}
