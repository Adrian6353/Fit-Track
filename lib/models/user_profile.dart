class UserProfile {
  final String name;
  final String level;
  final double weightKg;
  final double heightCm;
  final String units;

  const UserProfile({
    required this.name,
    required this.level,
    required this.weightKg,
    required this.heightCm,
    this.units = 'metric',
  });

  double get bmi =>
      heightCm <= 0 ? 0 : weightKg / ((heightCm / 100) * (heightCm / 100));
}
