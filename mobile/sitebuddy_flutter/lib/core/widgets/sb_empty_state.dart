import 'package:flutter/material.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';


/// WIDGET: SbEmptyState
/// PURPOSE: Standardized empty-state display for list screens.
class SbEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  const SbEmptyState({
    super.key,
    this.icon = SbIcons.inbox,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Center(
      child: SbCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 28, color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: SbSpacing.lg),

            // Title
            Text(
              title,
              style: textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),

            // Subtitle
            if (subtitle != null) ...[
              const SizedBox(height: SbSpacing.xs),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: SbSpacing.lg),
                child: Text(
                  subtitle!,
                  style: textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
            ],

            // Action
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: SbSpacing.lg),
              PrimaryCTA(
                label: actionLabel!,
                onPressed: onAction,
                width: double.infinity,
              ),
            ],
          ],
        ),
      ),
    );
  }
}


