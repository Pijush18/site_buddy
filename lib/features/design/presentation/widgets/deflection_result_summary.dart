import 'package:site_buddy/core/design_system/sb_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/widgets/app_card.dart';
import 'package:site_buddy/features/design/application/services/calculation_service.dart';
import 'package:site_buddy/features/design/presentation/widgets/comparison_bar.dart';
import 'package:site_buddy/features/design/presentation/widgets/shared_safety_widgets.dart';

class DeflectionResultSummary extends StatelessWidget {
  final DeflectionResult result;

  const DeflectionResultSummary({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'DESIGN STATUS',
                style: SbTextStyles.caption(context).copyWith(
                  color: const Color(0xFF2563EB),

                  letterSpacing: 1.1,
                ),
              ),
              StatusBadge(isSafe: result.isSafe),
            ],
          ),
          AppLayout.vGap24,
          ComparisonBar(
            actual: result.actualRatio,
            allowable: result.allowableRatio,
            label: 'Span/Depth Ratio',
            unit: '',
          ),
          AppLayout.vGap16,
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
    );
  }
}
