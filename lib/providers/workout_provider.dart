import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/mock_data.dart';
import '../models/workout.dart';

class WorkoutState {
  final String selectedCategory;
  final String searchQuery;

  const WorkoutState({this.selectedCategory = 'All', this.searchQuery = ''});

  WorkoutState copyWith({String? selectedCategory, String? searchQuery}) {
    return WorkoutState(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class WorkoutNotifier extends StateNotifier<WorkoutState> {
  WorkoutNotifier() : super(const WorkoutState());

  void selectCategory(String? category) {
    state = state.copyWith(selectedCategory: category ?? 'All');
  }

  void setSearchQuery(String? query) {
    state = state.copyWith(searchQuery: query ?? '');
  }

  List<Workout> filteredWorkouts() {
    final query = state.searchQuery.trim().toLowerCase();
    return workoutList
        .where(
          (workout) =>
              state.selectedCategory == 'All' ||
              workout.category == state.selectedCategory,
        )
        .where(
          (workout) =>
              query.isEmpty ||
              workout.name.toLowerCase().contains(query) ||
              workout.description.toLowerCase().contains(query) ||
              workout.exercises.any(
                (exercise) => exercise.name.toLowerCase().contains(query),
              ),
        )
        .toList();
  }
}

final workoutProvider = StateNotifierProvider<WorkoutNotifier, WorkoutState>(
  (ref) => WorkoutNotifier(),
);

final workoutCategoriesProvider = Provider<List<String>>(
  (ref) => ['All', 'Strength', 'Cardio', 'HIIT', 'Yoga', 'Mobility'],
);
