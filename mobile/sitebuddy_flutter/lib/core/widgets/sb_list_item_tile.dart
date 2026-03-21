import 'package:flutter/material.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';


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
  final bool isSubtle;

  const SbListItemTile({
    super.key,
    this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    required this.onTap,
    this.iconColor,
    this.color,
    this.isSubtle = false,
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
        style: textTheme.labelMedium?.copyWith(
          color: isSubtle ? colorScheme.onSurfaceVariant.withValues(alpha: 0.7) : null,
        ),
      );
    } else if (trailing is Widget) {
      trailingWidget = trailing as Widget;
    }

    return SizedBox(
      width: double.infinity,
      child: Material(
        color: color ?? Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SbSpacing.md,
              vertical: isSubtle ? SbSpacing.sm : SbSpacing.md,
            ),
            child: Row(
              children: [
                if (icon != null) ...[
                  SizedBox(
                    width: 36,
                    height: 36,
                    child: Center(
                      child: Icon(
                        icon,
                        color: iconColor ?? colorScheme.primary.withValues(alpha: isSubtle ? 0.5 : 0.8),
                        size: isSubtle ? 18 : 20,
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
                        style: isSubtle ? textTheme.bodyLarge : textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (subtitle != null && subtitle!.isNotEmpty) ...[
                        const SizedBox(height: SbSpacing.xs),
                        Text(
                          subtitle!,
                          style: textTheme.bodyMedium?.copyWith(
                            color: isSubtle ? colorScheme.onSurfaceVariant.withValues(alpha: 0.7) : null,
                          ),
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
        ),
      ),
    );
  }
}
