import 'package:site_buddy/core/design_system/sb_icons.dart';

import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/features/design/application/services/calculation_service.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';

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
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),

        ),
        const SizedBox(height: SbSpacing.sm),
        ...insights.map(
          (insight) => Padding(
            padding: const EdgeInsets.only(bottom: SbSpacing.sm),
            child: SbCard(
              padding: const EdgeInsets.all(SbSpacing.sm),

              child: Row(
                children: [
                  Icon(
                    insight.isWarning
                        ? SbIcons.lightbulb
                        : SbIcons.info,
                    color: insight.isWarning ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: SbSpacing.sm),
                  Expanded(
                    child: Text(
                      insight.message,
                      style: Theme.of(context).textTheme.bodyMedium!,
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







