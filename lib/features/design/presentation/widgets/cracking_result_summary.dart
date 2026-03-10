import 'package:site_buddy/core/design_system/sb_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/widgets/app_card.dart';
import 'package:site_buddy/features/design/application/services/calculation_service.dart';
import 'package:site_buddy/features/design/presentation/widgets/comparison_bar.dart';
import 'package:site_buddy/features/design/presentation/widgets/shared_safety_widgets.dart';

class CrackingResultSummary extends StatelessWidget {
  final CrackingResult result;

  const CrackingResultSummary({super.key, required this.result});

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
          const SizedBox(height: AppLayout.sectionGap),
          ComparisonBar(
            actual: result.crackWidth,
            allowable: 0.3,
            label: 'Estimated Crack Width (w)',
            unit: 'mm',
          ),
          const SizedBox(height: AppLayout.md),
          ResultDetailRow(
            label: 'Crack Width (w)',
            value: '${result.crackWidth.toStringAsFixed(3)} mm',
          ),
          const ResultDetailRow(label: 'Limit (IS 456)', value: '0.300 mm'),
        ],
      ),
    );
  }
}
