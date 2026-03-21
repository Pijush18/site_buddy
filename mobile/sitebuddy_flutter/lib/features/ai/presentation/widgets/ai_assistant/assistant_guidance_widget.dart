import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';

import 'package:flutter/material.dart';
import 'package:site_buddy/features/ai/domain/entities/assistant_response.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';

class AssistantGuidanceWidget extends StatelessWidget {
  final AssistantResponse response;
  const AssistantGuidanceWidget({super.key, required this.response});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      padding: SbSpacing.horizontalLG,
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
            const SizedBox(height: SbSpacing.lg),
            _GuidanceCard(
              title: 'Attention Required',
              message: 'Potential issues detected in calculations:',
              items: response.warnings,
              icon: SbIcons.warning,
              color: colorScheme.error,
            ),
          ],
          if (response.suggestions.isNotEmpty) ...[
            const SizedBox(height: SbSpacing.lg),
            _GuidanceCard(
              title: 'Optimization Suggestions',
              message: 'Recommendations for better design performance:',
              items: response.suggestions,
              icon: SbIcons.lightbulb,
              color: colorScheme.error, // Mapping to error or a standard warning color from theme
            ),
          ],
          const SizedBox(height: SbSpacing.xxl),
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
              const SizedBox(width: SbSpacing.xs),
              Text(
                title.toUpperCase(),
                style: Theme.of(context).textTheme.labelMedium!,
              ),
            ],
          ),
          const SizedBox(height: SbSpacing.lg),
          Text(message, style: Theme.of(context).textTheme.bodyLarge!),
          if (items != null && items!.isNotEmpty) ...[
            const SizedBox(height: SbSpacing.lg),
            ...items!.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: SbSpacing.sm),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: SbSpacing.sm + 2),
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: SbSpacing.md),
                    Expanded(
                      child: Text(
                        item,
                        style: Theme.of(context).textTheme.bodyMedium!,
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









