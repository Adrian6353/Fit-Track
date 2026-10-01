import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/active_workout_provider.dart';
import '../../providers/navigation_provider.dart';
import '../../providers/workout_provider.dart';
import '../../responsive/responsive.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../widgets/cards/workout_card.dart';
import '../../widgets/common/primary_button.dart';

class WorkoutsScreen extends ConsumerWidget {
  const WorkoutsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(workoutCategoriesProvider);
    final selectedCategory = ref.watch(
      workoutProvider.select((state) => state.selectedCategory),
    );
    final searchQuery = ref.watch(
      workoutProvider.select((state) => state.searchQuery),
    );
    final workouts = ref.watch(workoutProvider.notifier).filteredWorkouts();
    final featuredWorkout = workouts.isEmpty ? null : workouts.first;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Workouts',
            style: AppTypography.headline.copyWith(
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Pick a plan that fits your day.',
            style: AppTypography.body.copyWith(color: AppColors.secondaryText),
          ),
          const SizedBox(height: 18),
          TextFormField(
            key: const ValueKey('workout-search'),
            initialValue: searchQuery,
            onChanged: ref.read(workoutProvider.notifier).setSearchQuery,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: 'Search workouts or exercises',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.border),
              ),
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 42,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = category == selectedCategory;
                return ChoiceChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (_) => ref
                      .read(workoutProvider.notifier)
                      .selectCategory(category),
                );
              },
            ),
          ),
          const SizedBox(height: 22),
          if (featuredWorkout != null)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.highlight, width: 1),
          boxShadow: const [
            BoxShadow(color: AppColors.shadow, blurRadius: 10, offset: Offset(4, 5)),
            BoxShadow(color: AppColors.highlight, blurRadius: 8, offset: Offset(-3, -3)),
          ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selectedCategory == 'All'
                              ? 'Featured workout'
                              : selectedCategory,
                          style: AppTypography.caption.copyWith(
                            color: AppColors.secondaryText,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          featuredWorkout.name,
                          style: AppTypography.headline,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${featuredWorkout.duration} min • ${featuredWorkout.difficulty} • ${featuredWorkout.calories} kcal',
                          style: AppTypography.body.copyWith(
                            color: AppColors.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  PrimaryButton(
                    label: 'Start',
                    onPressed: () {
                      ref
                          .read(activeWorkoutProvider.notifier)
                          .startWorkout(featuredWorkout.id);
                      ref
                          .read(navigationProvider.notifier)
                          .openActiveWorkout(featuredWorkout.id);
                    },
                  ),
                ],
              ),
            ),
          const SizedBox(height: 22),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = getResponsiveColumns(constraints.maxWidth);
              final aspectRatio = constraints.maxWidth < 600 ? 0.78 : 1.0;
              if (workouts.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 36),
                  child: Center(
                    child: Text(
                      'No workouts found. Try another search or category.',
                      textAlign: TextAlign.center,
                      style: AppTypography.body.copyWith(
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ),
                );
              }
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: aspectRatio,
                ),
                itemCount: workouts.length,
                itemBuilder: (context, index) {
                  final workout = workouts[index];
                  return WorkoutCard(
                    workout: workout,
                    onTap: () => ref
                        .read(navigationProvider.notifier)
                        .openWorkoutDetail(workout.id),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
