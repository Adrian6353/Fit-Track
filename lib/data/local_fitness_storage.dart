import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/fitness_goal.dart';
import '../models/user_profile.dart';
import '../models/workout_history_entry.dart';
import '../providers/progress_provider.dart';

final localFitnessStorageProvider = Provider<LocalFitnessStorage>(
  (ref) => LocalFitnessStorage(),
);

/// Persists the small, user-owned data set used by FitTrack on this device.
class LocalFitnessStorage {
  LocalFitnessStorage() : _preferences = SharedPreferencesAsync();

  final SharedPreferencesAsync _preferences;

  static const _profileKey = 'fittrack.profile.v1';
  static const _goalsKey = 'fittrack.goals.v1';
  static const _progressKey = 'fittrack.progress.v1';

  Future<UserProfile?> loadProfile() async {
    final json = await _readObject(_profileKey);
    if (json == null) return null;
    return UserProfile(
      name: json['name'] as String? ?? 'Athlete',
      level: json['level'] as String? ?? 'Beginner',
      weightKg: (json['weightKg'] as num?)?.toDouble() ?? 0,
      heightCm: (json['heightCm'] as num?)?.toDouble() ?? 0,
      units: json['units'] as String? ?? 'metric',
    );
  }

  Future<void> saveProfile(UserProfile profile) => _writeObject(_profileKey, {
    'name': profile.name,
    'level': profile.level,
    'weightKg': profile.weightKg,
    'heightCm': profile.heightCm,
    'units': profile.units,
  });

  Future<List<FitnessGoal>?> loadGoals() async {
    final encoded = await _preferences.getString(_goalsKey);
    if (encoded == null) return null;
    final decoded = jsonDecode(encoded) as List<dynamic>;
    return decoded.map((item) {
      final goal = item as Map<String, dynamic>;
      return FitnessGoal(
        id: goal['id'] as String,
        title: goal['title'] as String,
        current: (goal['current'] as num).toDouble(),
        target: (goal['target'] as num).toDouble(),
        unit: goal['unit'] as String,
        type: goal['type'] as String? ?? 'general',
      );
    }).toList();
  }

  Future<void> saveGoals(List<FitnessGoal> goals) => _writeObject(
    _goalsKey,
    goals
        .map(
          (goal) => {
            'id': goal.id,
            'title': goal.title,
            'current': goal.current,
            'target': goal.target,
            'unit': goal.unit,
            'type': goal.type,
          },
        )
        .toList(),
  );

  Future<ProgressState?> loadProgress() async {
    final json = await _readObject(_progressKey);
    if (json == null) return null;
    final rawWeekly = json['weeklyActivity'];
    final weekly = List<int>.generate(
      7,
      (index) =>
          rawWeekly is List &&
              index < rawWeekly.length &&
              rawWeekly[index] is num
          ? (rawWeekly[index] as num).toInt()
          : 0,
    );
    final workoutHistory = <WorkoutHistoryEntry>[];
    final rawHistory = json['workoutHistory'];
    if (rawHistory is List) {
      for (final rawEntry in rawHistory) {
        if (rawEntry is! Map) continue;
        final workoutId = rawEntry['workoutId'];
        final completedAtValue = rawEntry['completedAt'];
        final calories = rawEntry['calories'];
        final durationMinutes = rawEntry['durationMinutes'];
        if (workoutId is! String ||
            completedAtValue is! String ||
            calories is! num ||
            durationMinutes is! num) {
          continue;
        }
        final completedAt = DateTime.tryParse(completedAtValue);
        if (completedAt == null) continue;
        workoutHistory.add(
          WorkoutHistoryEntry(
            workoutId: workoutId,
            completedAt: completedAt,
            calories: calories.toInt(),
            durationMinutes: durationMinutes.toInt(),
          ),
        );
      }
    }
    return ProgressState(
      workouts: (json['workouts'] as num?)?.toInt() ?? 0,
      caloriesBurned: (json['caloriesBurned'] as num?)?.toInt() ?? 0,
      activeMinutes: (json['activeMinutes'] as num?)?.toInt() ?? 0,
      steps: (json['steps'] as num?)?.toInt() ?? 0,
      weeklyActivity: weekly,
      completedWorkoutIds:
          (json['completedWorkoutIds'] as List<dynamic>? ?? const [])
              .whereType<String>()
              .toList(),
      workoutHistory: workoutHistory,
    );
  }

  Future<void> saveProgress(ProgressState progress) =>
      _writeObject(_progressKey, {
        'workouts': progress.workouts,
        'caloriesBurned': progress.caloriesBurned,
        'activeMinutes': progress.activeMinutes,
        'steps': progress.steps,
        'weeklyActivity': progress.weeklyActivity,
        'completedWorkoutIds': progress.completedWorkoutIds,
        'workoutHistory': progress.workoutHistory
            .map(
              (entry) => {
                'workoutId': entry.workoutId,
                'completedAt': entry.completedAt.toIso8601String(),
                'calories': entry.calories,
                'durationMinutes': entry.durationMinutes,
              },
            )
            .toList(),
      });

  Future<void> clearGoals() => _preferences.remove(_goalsKey);

  Future<void> clearProgress() => _preferences.remove(_progressKey);

  Future<void> clearActivity() async {
    await _preferences.remove(_goalsKey);
    await _preferences.remove(_progressKey);
  }

  Future<Map<String, dynamic>?> _readObject(String key) async {
    final encoded = await _preferences.getString(key);
    if (encoded == null) return null;
    final decoded = jsonDecode(encoded);
    return decoded as Map<String, dynamic>;
  }

  Future<void> _writeObject(String key, Object value) =>
      _preferences.setString(key, jsonEncode(value));
}
