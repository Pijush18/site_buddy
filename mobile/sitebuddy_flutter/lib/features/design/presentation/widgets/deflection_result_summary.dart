import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/features/design/application/services/calculation_service.dart';
import 'package:site_buddy/features/design/presentation/widgets/comparison_bar.dart';
import 'package:site_buddy/features/design/presentation/widgets/shared_safety_widgets.dart';

class DeflectionResultSummary extends StatelessWidget {
  final DeflectionResult result;

  const DeflectionResultSummary({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return SbSection(
      title: 'Design Status',
      trailing: StatusBadge(isSafe: result.isSafe),
      child: SbCard(
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.lg),
            ComparisonBar(
              actual: result.actualRatio,
              allowable: result.allowableRatio,
              label: 'Span/Depth Ratio',
              unit: '',
            ),
            const SizedBox(height: AppSpacing.md),
          ResultDetailRow(
            label: 'Actual Ratio',
            value: result.actualRatio.toStringAsFixed(2),
          ),
          ResultDetailRow(
            label: 'Allowable Ratio',
            value: result.allowableRatio.toStringAsFixed(2),
          ),
          ],
        ),
      ),
    );
  }
}
