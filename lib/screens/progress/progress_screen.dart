import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/mock_data.dart';
import '../../providers/profile_provider.dart';
import '../../providers/progress_provider.dart';
import '../../responsive/responsive.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../widgets/cards/stat_card.dart';
import '../../widgets/charts/weekly_chart.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(progressProvider);
    final profile = ref.watch(profileProvider);

    final stats = [
      StatCard(
        label: 'Calories Burned',
        value: '${progress.caloriesBurned} kcal',
        icon: Icons.local_fire_department,
        color: AppColors.orange,
      ),
      StatCard(
        label: 'Workouts',
        value: '${progress.workouts}',
        icon: Icons.fitness_center,
        color: AppColors.primary,
      ),
      StatCard(
        label: 'Active Minutes',
        value: '${progress.activeMinutes}',
        icon: Icons.timer,
        color: AppColors.blue,
      ),
      StatCard(
        label: 'Steps',
        value: '${progress.steps}',
        icon: Icons.directions_walk,
        color: AppColors.purple,
      ),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Progress',
            style: AppTypography.headline.copyWith(
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = getResponsiveColumns(constraints.maxWidth);
              final itemWidth =
                  (constraints.maxWidth - (columns - 1) * 12) / columns;
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: stats
                    .map((stat) => SizedBox(width: itemWidth, child: stat))
                    .toList(),
              );
            },
          ),
          const SizedBox(height: 22),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.highlight, width: 1),
          boxShadow: const [
            BoxShadow(color: AppColors.shadow, blurRadius: 10, offset: Offset(4, 5)),
            BoxShadow(color: AppColors.highlight, blurRadius: 8, offset: Offset(-3, -3)),
          ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recent workouts',
                  style: AppTypography.title.copyWith(
                    color: AppColors.primaryText,
                  ),
                ),
                const SizedBox(height: 8),
                if (progress.workoutHistory.isEmpty)
                  Text(
                    'Complete a session and it will appear here.',
                    style: AppTypography.body.copyWith(
                      color: AppColors.secondaryText,
                    ),
                  )
                else
                  ...progress.workoutHistory.take(5).map((entry) {
                    final workout = workoutList.firstWhere(
                      (item) => item.id == entry.workoutId,
                      orElse: () => workoutList.first,
                    );
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const CircleAvatar(
                        backgroundColor: AppColors.secondarySurface,
                        child: Icon(
                          Icons.fitness_center,
                          color: AppColors.primary,
                        ),
                      ),
                      title: Text(
                        workout.name,
                        style: AppTypography.subtitle.copyWith(
                          color: AppColors.primaryText,
                        ),
                      ),
                      subtitle: Text(
                        '${entry.completedAt.month}/${entry.completedAt.day} · ${entry.durationMinutes} min · ${entry.calories} kcal',
                      ),
                    );
                  }),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.highlight, width: 1),
          boxShadow: const [
            BoxShadow(color: AppColors.shadow, blurRadius: 10, offset: Offset(4, 5)),
            BoxShadow(color: AppColors.highlight, blurRadius: 8, offset: Offset(-3, -3)),
          ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Weekly activity',
                  style: AppTypography.title.copyWith(
                    color: AppColors.primaryText,
                  ),
                ),
                const SizedBox(height: 14),
                WeeklyChart(values: progress.weeklyActivity),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.highlight, width: 1),
          boxShadow: const [
            BoxShadow(color: AppColors.shadow, blurRadius: 10, offset: Offset(4, 5)),
            BoxShadow(color: AppColors.highlight, blurRadius: 8, offset: Offset(-3, -3)),
          ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Personal records',
                  style: AppTypography.title.copyWith(
                    color: AppColors.primaryText,
                  ),
                ),
                const SizedBox(height: 14),
                _recordRow('Sessions completed', '${progress.workouts}'),
                _recordRow(
                  'Calories burned',
                  '${progress.caloriesBurned} kcal',
                ),
                _recordRow('Active minutes', '${progress.activeMinutes} min'),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.highlight, width: 1),
          boxShadow: const [
            BoxShadow(color: AppColors.shadow, blurRadius: 10, offset: Offset(4, 5)),
            BoxShadow(color: AppColors.highlight, blurRadius: 8, offset: Offset(-3, -3)),
          ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Body statistics',
                  style: AppTypography.title.copyWith(
                    color: AppColors.primaryText,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Weight: ${profile.weightKg == 0
                      ? 'Not set'
                      : profile.units == 'metric'
                      ? '${profile.weightKg.toStringAsFixed(1)} kg'
                      : '${(profile.weightKg / 0.45359237).toStringAsFixed(1)} lb'}',
                  style: AppTypography.body.copyWith(
                    color: AppColors.secondaryText,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Height: ${profile.heightCm == 0
                      ? 'Not set'
                      : profile.units == 'metric'
                      ? '${profile.heightCm.toStringAsFixed(0)} cm'
                      : '${(profile.heightCm / 2.54).toStringAsFixed(1)} in'}',
                  style: AppTypography.body.copyWith(
                    color: AppColors.secondaryText,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'BMI: ${profile.bmi == 0 ? 'Not set' : profile.bmi.toStringAsFixed(1)}',
                  style: AppTypography.body.copyWith(
                    color: AppColors.secondaryText,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Activity is recorded on this device during completed workouts.',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.secondaryText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _recordRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: AppTypography.body.copyWith(
                color: AppColors.secondaryText,
              ),
            ),
          ),
          Text(
            value,
            style: AppTypography.subtitle.copyWith(
              color: AppColors.primaryText,
            ),
          ),
        ],
      ),
    );
  }
}
