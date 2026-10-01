import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/mock_data.dart';
import '../providers/navigation_provider.dart';
import '../screens/goals/goals_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/progress/progress_screen.dart';
import '../screens/workouts/active_workout_screen.dart';
import '../screens/workouts/workout_complete_screen.dart';
import '../screens/workouts/workout_detail_screen.dart';
import '../screens/workouts/workouts_screen.dart';
import '../theme/app_breakpoints.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

class FitTrackApp extends StatelessWidget {
  const FitTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'FitTrack',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const FitTrackRoot(),
      ),
    );
  }
}

class FitTrackRoot extends ConsumerWidget {
  const FitTrackRoot({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigation = ref.watch(navigationProvider);
    final width = MediaQuery.sizeOf(context).width;

    final content = _buildScreen(navigation);
    final isTabRoute = const {
      FitTrackRoute.home,
      FitTrackRoute.workouts,
      FitTrackRoute.progress,
      FitTrackRoute.goals,
      FitTrackRoute.profile,
    }.contains(navigation.route);
    final backTarget =
        navigation.route == FitTrackRoute.workoutComplete ||
            navigation.route == FitTrackRoute.activeWorkout ||
            navigation.route == FitTrackRoute.workoutDetail
        ? 1
        : navigation.selectedIndex;

    return PopScope<Object?>(
      canPop: isTabRoute,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          ref.read(navigationProvider.notifier).selectTab(backTarget);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Row(
                children: [
                  if (width >= AppBreakpoints.compact)
                    NavigationRail(
                      selectedIndex: navigation.selectedIndex,
                      onDestinationSelected: (index) =>
                          ref.read(navigationProvider.notifier).selectTab(index),
                      backgroundColor: AppColors.surface,
                      labelType: NavigationRailLabelType.selected,
                      destinations: const [
                        NavigationRailDestination(
                          icon: Icon(Icons.home_outlined),
                          selectedIcon: Icon(Icons.home),
                          label: Text('Home'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.fitness_center_outlined),
                          selectedIcon: Icon(Icons.fitness_center),
                          label: Text('Workouts'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.insights_outlined),
                          selectedIcon: Icon(Icons.insights),
                          label: Text('Progress'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.flag_outlined),
                          selectedIcon: Icon(Icons.flag),
                          label: Text('Goals'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.person_outline),
                          selectedIcon: Icon(Icons.person),
                          label: Text('Profile'),
                        ),
                      ],
                    )
                  else
                    const SizedBox.shrink(),
                  SizedBox(
                    width: width >= AppBreakpoints.compact ? 12 : 0,
                  ),
                  Expanded(child: content),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: width < AppBreakpoints.compact
            ? NavigationBar(
                backgroundColor: AppColors.surface,
                selectedIndex: navigation.selectedIndex,
                onDestinationSelected: (index) =>
                    ref.read(navigationProvider.notifier).selectTab(index),
                destinations: const [
                  NavigationDestination(
                    icon: Icon(Icons.home_outlined),
                    selectedIcon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.fitness_center_outlined),
                    selectedIcon: Icon(Icons.fitness_center),
                    label: 'Workouts',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.insights_outlined),
                    selectedIcon: Icon(Icons.insights),
                    label: 'Progress',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.flag_outlined),
                    selectedIcon: Icon(Icons.flag),
                    label: 'Goals',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.person_outline),
                    selectedIcon: Icon(Icons.person),
                    label: 'Profile',
                  ),
                ],
              )
            : null,
      ),
    );
  }

  Widget _buildScreen(NavigationState navigation) {
    switch (navigation.route) {
      case FitTrackRoute.home:
        return const HomeScreen();
      case FitTrackRoute.workouts:
        return const WorkoutsScreen();
      case FitTrackRoute.progress:
        return const ProgressScreen();
      case FitTrackRoute.goals:
        return const GoalsScreen();
      case FitTrackRoute.profile:
        return const ProfileScreen();
      case FitTrackRoute.workoutDetail:
        final workoutId = navigation.selectedWorkoutId ?? workoutList.first.id;
        return WorkoutDetailScreen(workoutId: workoutId);
      case FitTrackRoute.activeWorkout:
        final workoutId = navigation.selectedWorkoutId ?? workoutList.first.id;
        return ActiveWorkoutScreen(workoutId: workoutId);
      case FitTrackRoute.workoutComplete:
        return const WorkoutCompleteScreen();
    }
  }
}
