class Exercise {
  final String id;
  final String name;
  final int sets;
  final int reps;
  final int restSeconds;

  const Exercise({
    required this.id,
    required this.name,
    required this.sets,
    required this.reps,
    required this.restSeconds,
  });

  int get totalReps => sets * reps;
}
