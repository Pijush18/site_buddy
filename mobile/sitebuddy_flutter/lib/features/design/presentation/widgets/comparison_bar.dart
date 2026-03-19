import 'package:flutter/material.dart';
import 'package:site_buddy/core/theme/app_colors.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:site_buddy/core/design_system/sb_text_styles.dart';

/// WIDGET: ComparisonBar
/// PURPOSE: Visual comparison between Actual and Allowable values.
class ComparisonBar extends StatelessWidget {
  final double actual;
  final double allowable;
  final String label;
  final String unit;

  const ComparisonBar({
    super.key,
    required this.actual,
    required this.allowable,
    required this.label,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
//     final theme = Theme.of(context);
    final bool isSafe = actual <= allowable;
    final double ratio = (allowable > 0)
        ? (actual / allowable).clamp(0.0, 1.2)
        : 0.0;
//     final Color barColor = isSafe ? Colors.green : Colors.red;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: SbTextStyles.title(context)),
            Text(
              '${actual.toStringAsFixed(2)} / ${allowable.toStringAsFixed(2)} $unit',
              style: SbTextStyles.bodySecondary(context).copyWith(
                color: isSafe ? AppColors.success(context) : Theme.of(context).colorScheme.error,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppLayout.pSmall),
        Stack(
          children: [
            Container(height: 8),
            FractionallySizedBox(
              widthFactor: (ratio / 1.2).clamp(0.0, 1.0),
              child: Container(height: 8),
            ),
            // Marker for 100% (Allowable)
            Positioned(
              left:
                  (1.0 / 1.2) *
                  MediaQuery.of(context).size.width *
                  0.7, // Rough approximation
              child: Container(
                width: 2,
                height: 8,
                color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ],
    );
  }
}