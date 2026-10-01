import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/profile_provider.dart';
import '../../providers/goals_provider.dart';
import '../../providers/progress_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGlow,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.name,
                        style: AppTypography.title.copyWith(
                          color: AppColors.primaryText,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        profile.level,
                        style: AppTypography.body.copyWith(
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
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
                  'Body stats',
                  style: AppTypography.title.copyWith(
                    color: AppColors.primaryText,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Weight: ${profile.weightKg == 0
                      ? 'Not set'
                      : profile.units == 'metric'
                      ? '${profile.weightKg.toStringAsFixed(1)} kg'
                      : '${(profile.weightKg / 0.45359237).toStringAsFixed(1)} lb'}',
                  style: AppTypography.body.copyWith(
                    color: AppColors.secondaryText,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Height: ${profile.heightCm == 0
                      ? 'Not set'
                      : profile.units == 'metric'
                      ? '${profile.heightCm.toStringAsFixed(0)} cm'
                      : '${(profile.heightCm / 2.54).toStringAsFixed(1)} in'}',
                  style: AppTypography.body.copyWith(
                    color: AppColors.secondaryText,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'BMI: ${profile.bmi == 0 ? 'Not set' : profile.bmi.toStringAsFixed(1)}',
                  style: AppTypography.body.copyWith(
                    color: AppColors.secondaryText,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Material(
            color: AppColors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: BorderSide(color: AppColors.border),
            ),
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Units'),
                    trailing: Text(
                      profile.units == 'metric' ? 'Metric' : 'Imperial',
                    ),
                    onTap: () =>
                        ref.read(profileProvider.notifier).toggleUnits(),
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.delete_sweep_outlined,
                      color: AppColors.red,
                    ),
                    title: const Text(
                      'Clear activity data',
                      style: TextStyle(color: AppColors.red),
                    ),
                    subtitle: const Text('Remove workout totals and all goals'),
                    onTap: () => _confirmClearData(context, ref),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 22),
          Material(
            color: AppColors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: BorderSide(color: AppColors.border),
            ),
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.edit),
                    title: const Text('Edit Profile'),
                    onTap: () => _editProfile(context, ref),
                  ),
                  ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: const Text('About'),
                    onTap: () => showAboutDialog(
                      context: context,
                      applicationName: 'FitTrack',
                      applicationVersion: '1.0.0',
                      applicationLegalese:
                          'Track your workouts and personal progress on this device.',
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.help_outline),
                    title: const Text('Help'),
                    onTap: () => showDialog<void>(
                      context: context,
                      builder: (dialogContext) => AlertDialog(
                        title: const Text('FitTrack help'),
                        content: const Text(
                          'Choose Workouts to start a session. Completed workouts appear in Progress. Create and remove goals from the Goals tab.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(dialogContext),
                            child: const Text('Got it'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _editProfile(BuildContext context, WidgetRef ref) async {
    final profile = ref.read(profileProvider);
    final name = TextEditingController(
      text: profile.name == 'Athlete' ? '' : profile.name,
    );
    final weightValue = profile.units == 'metric'
        ? profile.weightKg
        : profile.weightKg / 0.45359237;
    final heightValue = profile.units == 'metric'
        ? profile.heightCm
        : profile.heightCm / 2.54;
    final weight = TextEditingController(
      text: weightValue == 0 ? '' : weightValue.toStringAsFixed(1),
    );
    final height = TextEditingController(
      text: heightValue == 0 ? '' : heightValue.toStringAsFixed(0),
    );
    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit profile'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: name,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: weight,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText:
                      'Weight (${profile.units == 'metric' ? 'kg' : 'lb'})',
                ),
              ),
              TextField(
                controller: height,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText:
                      'Height (${profile.units == 'metric' ? 'cm' : 'in'})',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (saved == true) {
      final valueWeight = double.tryParse(weight.text);
      final valueHeight = double.tryParse(height.text);
      ref
          .read(profileProvider.notifier)
          .updateProfile(
            name: name.text.trim().isEmpty ? 'Athlete' : name.text.trim(),
            weightKg: valueWeight == null
                ? profile.weightKg
                : profile.units == 'metric'
                ? valueWeight
                : valueWeight * 0.45359237,
            heightCm: valueHeight == null
                ? profile.heightCm
                : profile.units == 'metric'
                ? valueHeight
                : valueHeight * 2.54,
          );
    }
    name.dispose();
    weight.dispose();
    height.dispose();
  }

  Future<void> _confirmClearData(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Clear activity data?'),
        content: const Text(
          'This removes all recorded workout totals and goals.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Clear data'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await Future.wait([
        ref.read(progressProvider.notifier).clear(),
        ref.read(goalsProvider.notifier).clear(),
      ]);
    }
  }
}
