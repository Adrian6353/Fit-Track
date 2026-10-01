import 'package:flutter_test/flutter_test.dart';
import 'package:fittrack/providers/progress_provider.dart';

void main() {
  test('Progress provider records each workout only once', () {
    final notifier = ProgressNotifier();

    notifier.recordWorkoutCompletion('full-body-strength');
    notifier.recordWorkoutCompletion('full-body-strength');

    expect(notifier.state.workouts, 19);
    expect(notifier.state.completedWorkoutIds, contains('full-body-strength'));
    expect(notifier.state.completedWorkoutIds.length, 1);
  });
}
