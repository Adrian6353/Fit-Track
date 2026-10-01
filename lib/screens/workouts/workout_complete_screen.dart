import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/active_workout_provider.dart';
import '../../providers/goals_provider.dart';
import '../../providers/navigation_provider.dart';
import '../../providers/progress_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../widgets/common/primary_button.dart';

class WorkoutCompleteScreen extends ConsumerWidget {
  const WorkoutCompleteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final active = ref.watch(activeWorkoutProvider);
    final workout = active.workout;

    if (workout != null &&
        active.sessionId != null &&
        !ref
            .read(progressProvider)
            .completedWorkoutIds
            .contains(active.sessionId)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        ref
            .read(progressProvider.notifier)
            .recordWorkoutCompletion(workout.id, sessionId: active.sessionId);
        final goals = ref.read(goalsProvider);
        for (final goal in goals) {
          final amount = switch (goal.type) {
            'Workout Frequency' => 1.0,
            'Calories' => workout.calories.toDouble(),
            'Active Minutes' => workout.duration.toDouble(),
            _ => 0.0,
          };
          if (amount > 0) {
            ref.read(goalsProvider.notifier).updateProgress(goal.id, amount);
          }
        }
      });
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 28),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: AppColors.highlight, width: 1),
          boxShadow: const [
            BoxShadow(color: AppColors.shadow, blurRadius: 10, offset: Offset(4, 5)),
            BoxShadow(color: AppColors.highlight, blurRadius: 8, offset: Offset(-3, -3)),
          ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🎉', style: TextStyle(fontSize: 52)),
              const SizedBox(height: 12),
              Text(
                'Workout Complete!',
                style: AppTypography.headline.copyWith(
                  color: AppColors.primaryText,
                ),
              ),
              const SizedBox(height: 18),
              if (workout != null) ...[
                _StatRow(label: 'Duration', value: '${workout.duration} min'),
                _StatRow(label: 'Calories', value: '${workout.calories} kcal'),
                _StatRow(
                  label: 'Exercises',
                  value: '${workout.totalExercises}',
                ),
                _StatRow(label: 'Sets', value: '${workout.totalSets}'),
              ],
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: PrimaryButton(
                      label: 'Back to Home',
                      onPressed: () {
                        ref.read(activeWorkoutProvider.notifier).reset();
                        ref.read(navigationProvider.notifier).goHome();
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () =>
                    ref.read(navigationProvider.notifier).selectTab(2),
                child: const Text('View Progress'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;

  const _StatRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTypography.body.copyWith(color: AppColors.secondaryText),
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
