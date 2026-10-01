import 'package:flutter_riverpod/flutter_riverpod.dart';

enum FitTrackRoute {
  home,
  workouts,
  progress,
  goals,
  profile,
  workoutDetail,
  activeWorkout,
  workoutComplete,
}

class NavigationState {
  final FitTrackRoute route;
  final int selectedIndex;
  final String? selectedWorkoutId;

  const NavigationState({
    this.route = FitTrackRoute.home,
    this.selectedIndex = 0,
    this.selectedWorkoutId,
  });

  NavigationState copyWith({
    FitTrackRoute? route,
    int? selectedIndex,
    String? selectedWorkoutId,
  }) {
    return NavigationState(
      route: route ?? this.route,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      selectedWorkoutId: selectedWorkoutId ?? this.selectedWorkoutId,
    );
  }
}

class NavigationNotifier extends StateNotifier<NavigationState> {
  NavigationNotifier() : super(const NavigationState());

  void selectTab(int index) {
    final routes = [
      FitTrackRoute.home,
      FitTrackRoute.workouts,
      FitTrackRoute.progress,
      FitTrackRoute.goals,
      FitTrackRoute.profile,
    ];

    state = state.copyWith(
      route: routes[index],
      selectedIndex: index,
      selectedWorkoutId: null,
    );
  }

  void openWorkoutDetail(String workoutId) {
    state = state.copyWith(
      route: FitTrackRoute.workoutDetail,
      selectedWorkoutId: workoutId,
    );
  }

  void openActiveWorkout(String workoutId) {
    state = state.copyWith(
      route: FitTrackRoute.activeWorkout,
      selectedWorkoutId: workoutId,
    );
  }

  void openWorkoutComplete() {
    state = state.copyWith(route: FitTrackRoute.workoutComplete);
  }

  void goHome() {
    state = const NavigationState(route: FitTrackRoute.home, selectedIndex: 0);
  }
}

final navigationProvider = StateNotifierProvider<NavigationNotifier, NavigationState>(
  (ref) => NavigationNotifier(),
);
