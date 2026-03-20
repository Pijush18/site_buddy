import 'package:site_buddy/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/models/design_advisor_result.dart';

class DesignAdvisorCard extends StatelessWidget {
  final DesignAdvisorResult advisorResult;

  const DesignAdvisorCard({
    super.key,
    required this.advisorResult,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SbCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                advisorResult.recommendedOption != null 
                  ? Icons.tips_and_updates_outlined 
                  : Icons.warning_amber_rounded,
                color: advisorResult.recommendedOption != null 
                  ? colorScheme.primary 
                  : colorScheme.error,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                advisorResult.recommendedOption != null 
                  ? 'ENGINEERING ADVISOR' 
                  : 'ACTION REQUIRED',
                style: AppTextStyles.sectionTitle(context).copyWith(
                  color: advisorResult.recommendedOption != null 
                    ? colorScheme.primary 
                    : colorScheme.error,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            advisorResult.explanation,
            style: AppTextStyles.body(context),
          ),
          if (advisorResult.warnings.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            ...advisorResult.warnings.map((warning) => _AdvisoryItem(
                  text: warning,
                  isWarning: true,
                )),
          ],
          if (advisorResult.suggestions.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            const Divider(),
            const SizedBox(height: AppSpacing.md),
            ...advisorResult.suggestions.map((suggestion) => _AdvisoryItem(
                  text: suggestion,
                  isWarning: false,
                )),
          ],
        ],
      ),
    );
  }
}

class _AdvisoryItem extends StatelessWidget {
  final String text;
  final bool isWarning;

  const _AdvisoryItem({
    required this.text,
    required this.isWarning,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                color: isWarning ? colorScheme.error : colorScheme.primary,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.caption(context).copyWith(
                color: isWarning ? colorScheme.error : colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
