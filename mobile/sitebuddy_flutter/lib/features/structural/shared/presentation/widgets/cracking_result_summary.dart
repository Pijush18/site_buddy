import 'package:flutter/material.dart';
import 'package:site_buddy/core/widgets/sb_result_card.dart';
import 'package:site_buddy/features/structural/shared/domain/models/safety_check_models.dart';

class CrackingResultSummary extends StatelessWidget {
  final CrackingResult result;

  const CrackingResultSummary({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return SbResultCard(
      actual: result.crackWidth,
      allowable: 0.3,
      label: 'Estimated Crack Width (w)',
      unit: 'mm',
      details: [
        ResultDetailItem(
          label: 'Crack Width (w)',
          value: '${result.crackWidth.toStringAsFixed(3)} mm',
        ),
        const ResultDetailItem(
          label: 'Limit (IS 456)',
          value: '0.300 mm',
        ),
      ],
    );
  }
}






