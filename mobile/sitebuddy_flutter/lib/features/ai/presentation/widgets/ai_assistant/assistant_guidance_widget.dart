import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/theme/app_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/features/ai/domain/entities/assistant_response.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/theme/app_colors.dart';

class AssistantGuidanceWidget extends StatelessWidget {
  final AssistantResponse response;
  const AssistantGuidanceWidget({super.key, required this.response});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppLayout.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _GuidanceCard(
            title: response.title,
            message: response.message,
            icon: SbIcons.info,
            color: colorScheme.primary,
          ),
          if (response.warnings.isNotEmpty) ...[
            const SizedBox(height: AppLayout.md),
            _GuidanceCard(
              title: 'Attention Required',
              message: 'Potential issues detected in calculations:',
              items: response.warnings,
              icon: SbIcons.warning,
              color: colorScheme.error,
            ),
          ],
          if (response.suggestions.isNotEmpty) ...[
            const SizedBox(height: AppLayout.md),
            _GuidanceCard(
              title: 'Optimization Suggestions',
              message: 'Recommendations for better design performance:',
              items: response.suggestions,
              icon: SbIcons.lightbulb,
              color: AppColors.warning(context), // 👈 Standardized semantic warning
            ),
          ],
          const SizedBox(height: AppLayout.lg),
        ],
      ),
    );
  }
}

class _GuidanceCard extends StatelessWidget {
  final String title;
  final String message;
  final List<String>? items;
  final IconData icon;
  final Color color;

  const _GuidanceCard({
    required this.title,
    required this.message,
    this.items,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return SbCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: AppLayout.xs),
              Text(
                title.toUpperCase(),
                style: AppTextStyles.caption(context).copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppLayout.md),
          Text(message, style: AppTextStyles.body(context)),
          if (items != null && items!.isNotEmpty) ...[
            const SizedBox(height: AppLayout.md),
            ...items!.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: AppSpacing.sm),
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                    ),
                    AppLayout.hGap12,
                    Expanded(
                      child: Text(
                        item,
                        style: AppTextStyles.body(context, secondary: true).copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
