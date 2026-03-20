import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/theme/app_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/features/design/application/services/calculation_service.dart';

/// WIDGET: InsightCard
/// PURPOSE: Display engineering suggestions with professional styling.
class InsightCard extends StatelessWidget {
  final List<EngineeringInsight> insights;

  const InsightCard({super.key, required this.insights});

  @override
  Widget build(BuildContext context) {
//     final theme = Theme.of(context);
    if (insights.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'SMART INSIGHTS',
          style: AppTextStyles.sectionTitle(context).copyWith(
            color: Colors.blue,

            letterSpacing: 1.2,
          ),
        ),
        AppLayout.vGap8,
        ...insights.map(
          (insight) => Padding(
            padding: const EdgeInsets.only(bottom: AppLayout.sm),
            child: Container(
              padding: const EdgeInsets.all(AppLayout.sm),

              child: Row(
                children: [
                  Icon(
                    insight.isWarning
                        ? SbIcons.lightbulb
                        : SbIcons.info,
                    color: insight.isWarning ? Colors.orange : Colors.blue,
                    size: 20,
                  ),
                  const SizedBox(width: AppLayout.sm),
                  Expanded(
                    child: Text(
                      insight.message,
                      style: AppTextStyles.body(context, secondary: true).copyWith(
                        color: insight.isWarning ? Colors.orange : Colors.blue,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}