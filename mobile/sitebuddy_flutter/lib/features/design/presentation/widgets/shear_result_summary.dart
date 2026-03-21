import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/features/design/application/services/calculation_service.dart';
import 'package:site_buddy/features/design/presentation/widgets/comparison_bar.dart';
import 'package:site_buddy/features/design/presentation/widgets/shared_safety_widgets.dart';

class ShearResultSummary extends StatelessWidget {
  final ShearResult result;

  const ShearResultSummary({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return SbCard(
      child: Column(
        children: [
          SizedBox(height: SbSpacing.lg),
          ComparisonBar(
            actual: result.tv,
            allowable: result.tc,
            label: 'Shear Stress (τv vs τc)',
            unit: 'N/mm²',
          ),
          SizedBox(height: SbSpacing.lg),
          ResultDetailRow(
            label: 'Nominal Stress (τv)',
            value: '${result.tv.toStringAsFixed(3)} N/mm²',
          ),
          ResultDetailRow(
            label: 'Design Strength (τc)',
            value: '${result.tc.toStringAsFixed(3)} N/mm²',
          ),
        ],
      ),
    );
  }
}




