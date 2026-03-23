import 'package:flutter/material.dart';
import 'package:site_buddy/core/widgets/sb_result_card.dart';
import 'package:site_buddy/features/structural/shared/domain/models/safety_check_models.dart';

class ShearResultSummary extends StatelessWidget {
  final ShearResult result;

  const ShearResultSummary({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return SbResultCard(
      actual: result.tv,
      allowable: result.tc,
      label: 'Shear Stress (τv vs τc)',
      unit: 'N/mm²',
      details: [
        ResultDetailItem(
          label: 'Nominal Stress (τv)',
          value: '${result.tv.toStringAsFixed(3)} N/mm²',
        ),
        ResultDetailItem(
          label: 'Design Strength (τc)',
          value: '${result.tc.toStringAsFixed(3)} N/mm²',
        ),
      ],
    );
  }
}






