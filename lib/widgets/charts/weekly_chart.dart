import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

class WeeklyChart extends StatelessWidget {
  final List<int> values;

  const WeeklyChart({super.key, required this.values});

  @override
  Widget build(BuildContext context) {
    const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final week = List<double>.generate(
      7,
      (index) => index < values.length
          ? math.max(0, values[index]).toDouble()
          : 0,
    );
    final maxValue = week.reduce((a, b) => math.max(a, b).toDouble());

    // Reserve room for weekday labels, then let the bars share only the
    // remaining height. This keeps them inside the card on compact screens.
    return SizedBox(
      height: 154,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: List.generate(week.length, (index) {
          final fraction = maxValue > 0 ? week[index] / maxValue : 0.035;

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: FractionallySizedBox(
                        heightFactor: fraction.clamp(0.035, 1.0).toDouble(),
                        widthFactor: 1,
                        alignment: Alignment.bottomCenter,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                AppColors.primary,
                                AppColors.primary.withValues(alpha: 0.5),
                              ],
                            ),
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 16,
                    child: Center(
                      child: Text(
                        days[index],
                        style: AppTypography.caption.copyWith(
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
