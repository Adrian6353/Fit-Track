import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/navigation_provider.dart';

class AppRouter {
  const AppRouter();

  static void pushToWorkout(BuildContext context, String workoutId) {
    ProviderScope.containerOf(
      context,
      listen: false,
    ).read(navigationProvider.notifier).openWorkoutDetail(workoutId);
  }
}
