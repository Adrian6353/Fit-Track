import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/fitness_goal.dart';
import '../../providers/goals_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../widgets/cards/goal_card.dart';

class GoalsScreen extends ConsumerWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goals = ref.watch(goalsProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Goals',
                style: AppTypography.headline.copyWith(
                  color: AppColors.primaryText,
                ),
              ),
              TextButton.icon(
                onPressed: () => _showAddGoalSheet(context, ref),
                icon: const Icon(Icons.add),
                label: const Text('Add Goal'),
              ),
            ],
          ),
          const SizedBox(height: 18),
          if (goals.isEmpty)
            Expanded(
              child: Center(
                child: Text(
                  'No goals yet. Create your first fitness goal.',
                  style: AppTypography.body.copyWith(
                    color: AppColors.secondaryText,
                  ),
                ),
              ),
            )
          else
            Expanded(
              child: ListView.separated(
                itemCount: goals.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) => Dismissible(
                  key: ValueKey(goals[index].id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 24),
                    decoration: BoxDecoration(
                      color: AppColors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.delete_outline,
                      color: Colors.white,
                    ),
                  ),
                  onDismissed: (_) => ref
                      .read(goalsProvider.notifier)
                      .removeGoal(goals[index].id),
                  child: GoalCard(goal: goals[index]),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showAddGoalSheet(BuildContext context, WidgetRef ref) {
    final types = [
      'Steps',
      'Calories',
      'Workout Frequency',
      'Active Minutes',
      'Distance',
    ];
    String selectedType = types.first;
    final targetController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                18,
                18,
                18,
                MediaQuery.of(sheetContext).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add Goal',
                    style: AppTypography.title.copyWith(
                      color: AppColors.primaryText,
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: selectedType,
                    dropdownColor: AppColors.secondarySurface,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    items: types
                        .map(
                          (type) =>
                              DropdownMenuItem(value: type, child: Text(type)),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => selectedType = value);
                      }
                    },
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: targetController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Target value',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 18),
                  FilledButton(
                    onPressed: () {
                      final value = double.tryParse(targetController.text) ?? 0;
                      if (value <= 0) return;

                      final goal = FitnessGoal(
                        id: 'goal-${DateTime.now().millisecondsSinceEpoch}',
                        title: selectedType == 'Workout Frequency'
                            ? 'Workout ${value.toInt()} times this week'
                            : 'Reach ${value.toInt()} ${selectedType.toLowerCase()}',
                        current: 0,
                        target: value,
                        unit: selectedType == 'Workout Frequency'
                            ? 'sessions'
                            : selectedType == 'Calories'
                            ? 'kcal'
                            : selectedType == 'Steps'
                            ? 'steps'
                            : 'units',
                        type: selectedType,
                      );
                      ref.read(goalsProvider.notifier).addGoal(goal);
                      Navigator.of(sheetContext).pop();
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(48),
                    ),
                    child: const Text('Create Goal'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
