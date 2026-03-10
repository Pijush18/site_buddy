import 'package:site_buddy/core/design_system/sb_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';

/// CLASS: ResultCard
/// PURPOSE: Presentation component designed to draw immediate visual attention to critical computed outputs.
/// REFINED: Fully theme-aware using ColorScheme for contrast and readability.
class ResultCard extends StatelessWidget {
  final double volume;
  final double dryVolume;
  final int cementBags;

  const ResultCard({
    super.key,
    required this.volume,
    required this.dryVolume,
    required this.cementBags,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration:
          BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: AppLayout.borderRadiusCard,
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.outline.withValues(alpha: 0.2),
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: Theme.of(context).brightness == Brightness.dark
                      ? 0.30
                      : 0.12,
                ),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ).copyWith(
            border: Border.all(
              color: colorScheme.primary.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
      padding: const EdgeInsets.all(AppLayout.pLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SbListItem(
            title: 'Volume',
            trailing: Text(
              '${volume.toStringAsFixed(2)} m³',
              style: SbTextStyles.body(context),
            ),
          ),
          SbListItem(
            title: 'Dry Volume',
            trailing: Text(
              '${dryVolume.toStringAsFixed(2)} m³',
              style: SbTextStyles.body(context),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(
              height: 1,
              color: colorScheme.outline.withValues(alpha: 0.1),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'REQUIREMENT',
                      style: SbTextStyles.caption(context).copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        color: colorScheme.primary,
                      ),
                    ),
                    Text(
                      'Cement Bags',
                      style: SbTextStyles.title(context).copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '$cementBags',
                style: SbTextStyles.headlineLarge(context).copyWith(
                  fontWeight: FontWeight.w900,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
