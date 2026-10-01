class WorkoutHistoryEntry {
  const WorkoutHistoryEntry({
    required this.workoutId,
    required this.completedAt,
    required this.calories,
    required this.durationMinutes,
  });

  final String workoutId;
  final DateTime completedAt;
  final int calories;
  final int durationMinutes;
}
