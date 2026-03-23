import 'package:site_buddy/core/theme/app_spacing.dart';

import 'package:flutter/material.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/features/structural/beam/domain/beam_design_state.dart';

/// WIDGET: SmartSuggestionsCard
/// PURPOSE: Displays engineering advice based on the current design state.
class SmartSuggestionsCard extends StatelessWidget {
  final List<DesignSuggestion> suggestions;
  final VoidCallback? onOptimize;

  const SmartSuggestionsCard({
    super.key,
    required this.suggestions,
    this.onOptimize,
  });

  @override
  Widget build(BuildContext context) {
    if (suggestions.isEmpty) return const SizedBox.shrink();
    final colorScheme = Theme.of(context).colorScheme;
    final warningColor = colorScheme.error;

    return SbCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.tips_and_updates, color: warningColor, size: 20),
              const SizedBox(width: AppSpacing.lg),
              Text(
                'Design Insights',
                style: Theme.of(context).textTheme.bodyLarge!,
              ),
              const Spacer(),
              if (onOptimize != null)
                GhostButton(
                  label: 'AUTO-FIX', 
                  onPressed: onOptimize,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          ...suggestions.map(
            (s) => Container(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg).copyWith(top: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.title,
                    style: Theme.of(context).textTheme.labelMedium!,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    s.description,
                    style: Theme.of(context).textTheme.bodyMedium!,
                  ),
                  if (s.action.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm).copyWith(bottom: 0),
                      child: Text(
                        '➔ ${s.action}',
                        style: Theme.of(context).textTheme.labelMedium!,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
