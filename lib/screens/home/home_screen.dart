import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/active_workout_provider.dart';
import '../../providers/goals_provider.dart';
import '../../providers/navigation_provider.dart';
import '../../providers/profile_provider.dart';
import '../../providers/progress_provider.dart';
import '../../responsive/responsive.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../widgets/cards/stat_card.dart';
import '../../widgets/charts/weekly_chart.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    final progress = ref.watch(progressProvider);
    final workoutGoalProgress = (progress.workouts / 4).clamp(0.0, 1.0);
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good morning'
        : hour < 17
        ? 'Good afternoon'
        : 'Good evening';

    final stats = [
      StatCard(
        label: 'Calories',
        value: '${progress.caloriesBurned} kcal',
        icon: Icons.local_fire_department,
        color: AppColors.orange,
      ),
      StatCard(
        label: 'Steps',
        value: progress.steps.toString(),
        icon: Icons.directions_walk,
        color: AppColors.blue,
      ),
      StatCard(
        label: 'Active',
        value: '${progress.activeMinutes} min',
        icon: Icons.timer,
        color: AppColors.primary,
      ),
      StatCard(
        label: 'Workouts',
        value: progress.workouts.toString(),
        icon: Icons.fitness_center,
        color: AppColors.purple,
      ),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$greeting, ${profile.name.split(' ').first}',
                      style: AppTypography.headline,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Ready to move?',
                      style: AppTypography.body.copyWith(
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () => ref.read(navigationProvider.notifier).selectTab(4),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGlow,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.person_outline_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.secondarySurface, AppColors.surface],
              ),
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: AppColors.highlight, width: 1),
          boxShadow: const [
            BoxShadow(color: AppColors.shadow, blurRadius: 10, offset: Offset(4, 5)),
            BoxShadow(color: AppColors.highlight, blurRadius: 8, offset: Offset(-3, -3)),
          ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_rounded,
                      color: AppColors.primary,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'TODAY\'S PLAN',
                      style: AppTypography.label.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.home_outlined,
                      color: AppColors.secondaryText,
                      size: 18,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'At home',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Full Body Strength',
                            style: AppTypography.headline.copyWith(
                              color: AppColors.primaryText,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'A guided full-body strength session you can do at home.',
                            style: AppTypography.body.copyWith(
                              color: AppColors.secondaryText,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Wrap(
                            spacing: 8,
                            children: [
                              _PlanTag(
                                icon: Icons.schedule_rounded,
                                label: '35 min',
                              ),
                              _PlanTag(
                                icon: Icons.local_fire_department_outlined,
                                label: '320 kcal',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGlow,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Icon(
                        Icons.fitness_center_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      ref
                          .read(activeWorkoutProvider.notifier)
                          .startWorkout('full-body-strength');
                      ref
                          .read(navigationProvider.notifier)
                          .openActiveWorkout('full-body-strength');
                    },
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: const Text('Start today\'s workout'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = getResponsiveColumns(constraints.maxWidth);
              final itemWidth =
                  (constraints.maxWidth - (columns - 1) * 12) / columns;
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: stats.map((card) {
                  return SizedBox(width: itemWidth, child: card);
                }).toList(),
              );
            },
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () => _showStepsDialog(context, ref),
              icon: const Icon(Icons.add),
              label: const Text('Log steps'),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Workout goal',
                      style: AppTypography.title.copyWith(
                        color: AppColors.primaryText,
                      ),
                    ),
                    Text(
                      '${(workoutGoalProgress * 100).round()}%',
                      style: AppTypography.subtitle.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: workoutGoalProgress,
                    minHeight: 10,
                    backgroundColor: AppColors.secondarySurface,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '${progress.workouts} of 4 completed workouts',
                  style: AppTypography.body.copyWith(
                    color: AppColors.secondaryText,
                  ),
                ),
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
                  'Weekly Activity',
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
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () =>
                      ref.read(navigationProvider.notifier).selectTab(1),
                  icon: const Icon(Icons.explore_outlined),
                  label: const Text('Explore workouts'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    foregroundColor: AppColors.primaryText,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: () =>
                      ref.read(navigationProvider.notifier).selectTab(3),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.secondarySurface,
                    foregroundColor: AppColors.primaryText,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text('Add Goal'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _showStepsDialog(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController();
    final value = await showDialog<int>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Log steps'),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Steps to add'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.pop(dialogContext, int.tryParse(controller.text)),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (value == null || value <= 0) return;
    ref.read(progressProvider.notifier).recordSteps(value);
    for (final goal
        in ref.read(goalsProvider).where((goal) => goal.type == 'Steps')) {
      ref
          .read(goalsProvider.notifier)
          .updateProgress(goal.id, value.toDouble());
    }
  }
}

class _PlanTag extends StatelessWidget {
  const _PlanTag({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
    decoration: BoxDecoration(
      color: AppColors.background,
      borderRadius: BorderRadius.circular(99),
      border: Border.all(color: AppColors.highlight, width: 1),
          boxShadow: const [
            BoxShadow(color: AppColors.shadow, blurRadius: 10, offset: Offset(4, 5)),
            BoxShadow(color: AppColors.highlight, blurRadius: 8, offset: Offset(-3, -3)),
          ],
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.primary),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppTypography.caption.copyWith(color: AppColors.primaryText),
        ),
      ],
    ),
  );
}
