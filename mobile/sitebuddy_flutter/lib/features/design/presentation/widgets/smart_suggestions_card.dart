import 'package:site_buddy/core/design_system/sb_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
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
    final colorScheme = Theme.of(context).colorScheme;
    final warningColor = AppColors.warning(context);

    return SbCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.tips_and_updates, color: warningColor, size: 20),
              const SizedBox(width: AppLayout.md),
              Text(
                'Design Insights',
                style: SbTextStyles.body(context).copyWith(
                  color: warningColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              if (onOptimize != null)
                SbButton.ghost(
                  label: 'AUTO-FIX', 
                  onPressed: onOptimize,
                ),
            ],
          ),
          const SizedBox(height: AppLayout.md),
          ...suggestions.map(
            (s) => Padding(
              padding: const EdgeInsets.only(bottom: AppLayout.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.title,
                    style: SbTextStyles.caption(context).copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    s.description,
                    style: SbTextStyles.bodySecondary(context).copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (s.action.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: AppLayout.sm),
                      child: Text(
                        '➔ ${s.action}',
                        style: SbTextStyles.caption(context).copyWith(
                          color: warningColor,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w600,
                        ),
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
