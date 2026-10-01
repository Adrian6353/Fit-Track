import 'exercise.dart';

class Workout {
  final String id;
  final String name;
  final String description;
  final String difficulty;
  final int duration;
  final int calories;
  final String category;
  final List<Exercise> exercises;

  const Workout({
    required this.id,
    required this.name,
    required this.description,
    required this.difficulty,
    required this.duration,
    required this.calories,
    required this.category,
    required this.exercises,
  });

  int get totalExercises => exercises.length;

  int get totalSets {
    return exercises.fold<int>(0, (sum, exercise) => sum + exercise.sets);
  }

  double progressPercent(int completedExercises) {
    if (totalExercises == 0) return 0;
    return (completedExercises / totalExercises) * 100;
  }
}
