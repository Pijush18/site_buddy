import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/models/design_advisor_result.dart';
import 'package:site_buddy/core/theme/app_text_styles.dart';
import 'package:site_buddy/core/widgets/app_card.dart';
import 'package:site_buddy/core/constants/app_sizes.dart';

/// WIDGET: DesignAdvisorCard
/// PURPOSE: Displays engineering advice, warnings, and suggestions for a selected design option.
class DesignAdvisorCard extends StatelessWidget {
  final DesignAdvisorResult advisorResult;

  const DesignAdvisorCard({super.key, required this.advisorResult});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ENGINEERING ADVISOR',
          style: AppTextStyles.bodySmall.copyWith(
            letterSpacing: 1.2,
            color: Colors.grey,
          ),
        ),
        AppSizes.gap8,
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Recommendation Header
              Row(
                children: [
                  const Icon(SbIcons.brain, color: Colors.blue),
                  AppLayout.hGap8,
                  Text(
                    'Recommendation',
                    style: AppTextStyles.titleMedium.copyWith(
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              AppSizes.gap12,

              // Explanation
              Text(advisorResult.explanation, style: AppTextStyles.bodyMedium),

              if (advisorResult.warnings.isNotEmpty) ...[
                AppSizes.gap16,
                const _SectionHeader(
                  title: 'Engineering Warnings',
                  icon: SbIcons.warning,
                  color: Colors.orange,
                ),
                AppSizes.gap8,
                Column(
                  children: advisorResult.warnings
                      .map((w) => _AdvisoryItem(text: w, isWarning: true))
                      .toList(),
                ),
              ],

              if (advisorResult.suggestions.isNotEmpty) ...[
                AppSizes.gap16,
                const _SectionHeader(
                  title: 'Improvement Suggestions',
                  icon: Icons.tips_and_updates_outlined,
                  color: Colors.green,
                ),
                AppSizes.gap8,
                Column(
                  children: advisorResult.suggestions
                      .map((s) => _AdvisoryItem(text: s, isWarning: false))
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const _SectionHeader({
    required this.title,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        AppLayout.hGap8,
        Text(title, style: AppTextStyles.bodySmall.copyWith(color: color)),
      ],
    );
  }
}

class _AdvisoryItem extends StatelessWidget {
  final String text;
  final bool isWarning;

  const _AdvisoryItem({required this.text, required this.isWarning});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppLayout.spaceXS,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyle(color: isWarning ? Colors.orange : Colors.green),
          ),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodySmall.copyWith(height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
