import 'package:flutter/material.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/theme/app_font_sizes.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/models/design_advisor_result.dart';

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
        const Text(
          'ENGINEERING ADVISOR',
          style: TextStyle(
            fontSize: 12,
            letterSpacing: 1.2,
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SbSectionHeader(
          title: advisorResult.recommendedOption != null
              ? 'Recommendation'
              : 'Action Required',
        ),
        SbCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.md),

              // Explanation
              Text(advisorResult.explanation,
                  style: const TextStyle(fontSize: AppFontSizes.tab)),

              if (advisorResult.warnings.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.md),
                const _SectionHeader(
                  title: 'Engineering Warnings',
                  icon: Icons.warning_amber_rounded,
                  color: Colors.orange,
                ),
                const SizedBox(height: AppSpacing.sm),
                Column(
                  children: advisorResult.warnings
                      .map((w) => _AdvisoryItem(text: w, isWarning: true))
                      .toList(),
                ),
              ],

              if (advisorResult.suggestions.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.md),
                const _SectionHeader(
                  title: 'Improvement Suggestions',
                  icon: Icons.tips_and_updates_outlined,
                  color: Colors.green,
                ),
                const SizedBox(height: AppSpacing.sm),
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
        const SizedBox(width: AppSpacing.sm),
        Text(title,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.bold,
            )),
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
        vertical: AppSpacing.sm / 2,
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
              style: const TextStyle(
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
