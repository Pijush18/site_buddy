import 'package:flutter/material.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/theme/app_radius.dart';
import 'package:site_buddy/core/theme/app_font_sizes.dart';

/// A reusable card container for the SiteBuddy application.
/// 
/// Provides consistent elevation, rounded corners using [AppRadius],
/// and internal padding using [AppSpacing]. Supports optional title and actions.
class SBCard extends StatelessWidget {
  /// The main content of the card.
  final Widget child;

  /// Optional title displayed at the top of the card.
  final String? title;

  /// Optional widgets displayed in the header next to the title.
  final List<Widget>? actions;

  /// Whether to show a divider between the header and the body.
  final bool showDivider;

  /// Optional padding for the card content. Defaults to [AppSpacing.md].
  final EdgeInsetsGeometry? padding;

  /// Optional callback when the card is tapped.
  final VoidCallback? onTap;

  /// Optional background color for the card. Defaults to [colorScheme.surface].
  final Color? backgroundColor;

  /// Optional style for the card title.
  final TextStyle? titleStyle;

  const SBCard({
    super.key,
    required this.child,
    this.title,
    this.actions,
    this.showDivider = true,
    this.padding,
    this.onTap,
    this.backgroundColor,
    this.titleStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: BorderSide(color: colorScheme.outlineVariant, width: 1),
      ),
      color: backgroundColor ?? colorScheme.surface,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null || (actions != null && actions!.isNotEmpty)) ...[
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                child: Row(
                  children: [
                    if (title != null)
                      Expanded(
                        child: Text(
                          title!,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontSize: AppFontSizes.subtitle,
                            fontWeight: FontWeight.bold,
                          ).merge(titleStyle),
                        ),
                      ),
                    ...?actions,
                  ],
                ),
              ),
              if (showDivider) Divider(height: 1, color: colorScheme.outlineVariant),
            ],
            Padding(
              padding: padding ?? const EdgeInsets.all(AppSpacing.md),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
