import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/mock_data.dart';
import '../../providers/active_workout_provider.dart';
import '../../providers/navigation_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../widgets/common/primary_button.dart';

class WorkoutDetailScreen extends ConsumerWidget {
  final String workoutId;

  const WorkoutDetailScreen({super.key, required this.workoutId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workout = workoutList.firstWhere(
      (item) => item.id == workoutId,
      orElse: () => workoutList.first,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            workout.name,
            style: AppTypography.headline.copyWith(
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _Chip(text: workout.difficulty),
              _Chip(text: '${workout.duration} min'),
              _Chip(text: '${workout.calories} kcal'),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            workout.description,
            style: AppTypography.body.copyWith(color: AppColors.secondaryText),
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            label: 'Start Workout',
            icon: Icons.play_arrow_rounded,
            onPressed: () {
              ref.read(activeWorkoutProvider.notifier).startWorkout(workout.id);
              ref
                  .read(navigationProvider.notifier)
                  .openActiveWorkout(workout.id);
            },
          ),
          const SizedBox(height: 24),
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
                  'Exercises',
                  style: AppTypography.title.copyWith(
                    color: AppColors.primaryText,
                  ),
                ),
                const SizedBox(height: 18),
                ...workout.exercises.asMap().entries.map((entry) {
                  final index = entry.key;
                  final exercise = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 28,
                          child: Text(
                            '${index + 1}.',
                            style: AppTypography.body.copyWith(
                              color: AppColors.secondaryText,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                exercise.name,
                                style: AppTypography.subtitle.copyWith(
                                  color: AppColors.primaryText,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${exercise.sets} sets × ${exercise.reps} · ${exercise.restSeconds}s rest',
                                style: AppTypography.body.copyWith(
                                  color: AppColors.secondaryText,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.fitness_center,
                          color: AppColors.primary,
                          size: 18,
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String text;

  const _Chip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.secondarySurface,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: AppTypography.label.copyWith(color: AppColors.primaryText),
      ),
    );
  }
}
