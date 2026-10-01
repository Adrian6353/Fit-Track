class FitnessGoal {
  final String id;
  final String title;
  final double current;
  final double target;
  final String unit;
  final String type;

  const FitnessGoal({
    required this.id,
    required this.title,
    required this.current,
    required this.target,
    required this.unit,
    this.type = 'general',
  });

  double get percentComplete {
    if (target <= 0) return 0;
    return (current / target) * 100;
  }

  bool get isComplete => current >= target;

  double get remaining => (target - current).clamp(0, double.infinity);
}
