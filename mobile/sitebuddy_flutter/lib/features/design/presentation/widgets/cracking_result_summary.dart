import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/features/design/application/services/calculation_service.dart';
import 'package:site_buddy/features/design/presentation/widgets/comparison_bar.dart';
import 'package:site_buddy/features/design/presentation/widgets/shared_safety_widgets.dart';

class CrackingResultSummary extends StatelessWidget {
  final CrackingResult result;

  const CrackingResultSummary({super.key, required this.result});

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
            actual: result.crackWidth,
            allowable: 0.3,
            label: 'Estimated Crack Width (w)',
            unit: 'mm',
          ),
          const SizedBox(height: AppSpacing.md),
          ResultDetailRow(
            label: 'Crack Width (w)',
            value: '${result.crackWidth.toStringAsFixed(3)} mm',
          ),
          const ResultDetailRow(label: 'Limit (IS 456)', value: '0.300 mm'),
          ],
        ),
      ),
    );
  }
}
