import 'package:site_buddy/core/design_system/sb_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/widgets/app_card.dart';
import 'package:site_buddy/features/design/application/services/calculation_service.dart';
import 'package:site_buddy/features/design/presentation/widgets/comparison_bar.dart';
import 'package:site_buddy/features/design/presentation/widgets/shared_safety_widgets.dart';

class ShearResultSummary extends StatelessWidget {
  final ShearResult result;

  const ShearResultSummary({super.key, required this.result});

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
                style: SbTextStyles.title(context).copyWith(
                  color: const Color(0xFF2563EB),

                  letterSpacing: 1.1,
                ),
              ),
              StatusBadge(isSafe: result.isSafe),
            ],
          ),
          AppLayout.vGap24,
          ComparisonBar(
            actual: result.tv,
            allowable: result.tc,
            label: 'Shear Stress (τv vs τc)',
            unit: 'N/mm²',
          ),
          AppLayout.vGap16,
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
