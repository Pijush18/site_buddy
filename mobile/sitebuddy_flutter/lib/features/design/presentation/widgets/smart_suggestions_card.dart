import 'package:site_buddy/core/design_system/sb_spacing.dart';

import 'package:flutter/material.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/shared/domain/models/design/beam_design_state.dart';
import 'package:site_buddy/core/theme/app_colors.dart';

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
    final warningColor = AppColors.warning(context);

    return SbCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.tips_and_updates, color: warningColor, size: 20),
              const SizedBox(width: SbSpacing.lg),
              Text(
                'Design Insights',
                style: Theme.of(context).textTheme.bodyLarge!,
              ),
              const Spacer(),
              if (onOptimize != null)
                SbButton.ghost(
                  label: 'AUTO-FIX', 
                  onPressed: onOptimize,
                ),
            ],
          ),
          const SizedBox(height: SbSpacing.lg),
          ...suggestions.map(
            (s) => Padding(
              padding: const EdgeInsets.only(bottom: SbSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.title,
                    style: Theme.of(context).textTheme.labelMedium!,
                  ),
                  const SizedBox(height: SbSpacing.xs),
                  Text(
                    s.description,
                    style: Theme.of(context).textTheme.bodyMedium!,
                  ),
                  if (s.action.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: SbSpacing.sm),
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









