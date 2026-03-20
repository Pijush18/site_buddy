import 'package:flutter/material.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/widgets/sb_card.dart';

/// WIDGET: SbListItemTile
/// PURPOSE: Standardized list item UI enforcing global typography and spacing.
class SbListItemTile extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String? subtitle;
  final dynamic trailing;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? color;

  const SbListItemTile({
    super.key,
    this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    required this.onTap,
    this.iconColor,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    Widget? trailingWidget;
    if (trailing is String) {
      trailingWidget = Text(
        trailing as String,
        style: textTheme.labelMedium,
      );
    } else if (trailing is Widget) {
      trailingWidget = trailing as Widget;
    }

    return SbCard(
      padding: EdgeInsets.zero,
      onTap: onTap,
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(SbSpacing.lg),
        child: Row(
          children: [
            if (icon != null) ...[
              SizedBox(
                width: 36,
                height: 36,
                child: Center(
                  child: Icon(
                    icon,
                    color: iconColor ?? colorScheme.primary.withValues(alpha: 0.8),
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: SbSpacing.md),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle != null && subtitle!.isNotEmpty) ...[
                    const SizedBox(height: SbSpacing.xxs),
                    Text(
                      subtitle!,
                      style: textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            if (trailingWidget != null) ...[
              const SizedBox(width: SbSpacing.md),
              trailingWidget,
            ],
          ],
        ),
      ),
    );
  }
}



