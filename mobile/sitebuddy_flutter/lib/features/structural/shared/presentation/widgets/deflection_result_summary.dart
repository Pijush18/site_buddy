import 'package:flutter/material.dart';
import 'package:site_buddy/core/widgets/sb_result_card.dart';
import 'package:site_buddy/features/structural/shared/domain/models/safety_check_models.dart';

class DeflectionResultSummary extends StatelessWidget {
  final DeflectionResult result;

  const DeflectionResultSummary({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return SbResultCard(
      actual: result.actualRatio,
      allowable: result.allowableRatio,
      label: 'Span/Depth Ratio',
      unit: '',
      details: [
        ResultDetailItem(
          label: 'Actual Ratio',
          value: result.actualRatio.toStringAsFixed(2),
        ),
        ResultDetailItem(
          label: 'Allowable Ratio',
          value: result.allowableRatio.toStringAsFixed(2),
        ),
      ],
    );
  }
}






