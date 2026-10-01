import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/mock_data.dart';
import '../data/local_fitness_storage.dart';
import '../models/user_profile.dart';

class ProfileNotifier extends StateNotifier<UserProfile> {
  ProfileNotifier(this._storage) : super(userProfile) {
    _restore();
  }

  final LocalFitnessStorage _storage;
  bool _hasLocalChanges = false;
  Future<void> _pendingSave = Future.value();

  Future<void> _restore() async {
    try {
      final saved = await _storage.loadProfile();
      if (!_hasLocalChanges && saved != null) state = saved;
    } catch (_) {
      // Keep the in-memory defaults if local storage is unavailable or invalid.
    }
  }

  void _persist() {
    _hasLocalChanges = true;
    final snapshot = state;
    _pendingSave = _pendingSave.then((_) async {
      try {
        await _storage.saveProfile(snapshot);
      } catch (_) {
        // A storage failure should not interrupt profile editing.
      }
    });
  }

  void updateProfile({
    String? name,
    String? level,
    double? weightKg,
    double? heightCm,
  }) {
    state = UserProfile(
      name: name ?? state.name,
      level: level ?? state.level,
      weightKg: weightKg ?? state.weightKg,
      heightCm: heightCm ?? state.heightCm,
      units: state.units,
    );
    _persist();
  }

  void toggleUnits() {
    state = UserProfile(
      name: state.name,
      level: state.level,
      weightKg: state.weightKg,
      heightCm: state.heightCm,
      units: state.units == 'metric' ? 'imperial' : 'metric',
    );
    _persist();
  }
}

final profileProvider = StateNotifierProvider<ProfileNotifier, UserProfile>(
  (ref) => ProfileNotifier(ref.read(localFitnessStorageProvider)),
);
