import 'package:flutter/material.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/widgets/sb_interactive_card.dart';
import 'package:site_buddy/core/design_system/sb_radius.dart';


/// WIDGET: SbListItemTile
/// PURPOSE: Standardized list item UI enforcing global typography and spacing.
class SbListItemTile extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String? subtitle;
  final dynamic trailing;
  final VoidCallback onTap;
  final Color? color;
  final bool isSubtle;
  final bool isPrimary;

  const SbListItemTile({
    super.key,
    this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    required this.onTap,
    this.color,
    this.isSubtle = false,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

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

    return SbInteractiveCard(
      onTap: onTap,
      borderRadius: BorderRadius.circular(isSubtle ? 0 : SbRadius.standard),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: SbSpacing.md,
          vertical: isSubtle ? SbSpacing.sm : SbSpacing.md,
        ),
        decoration: isSubtle
            ? null
            : BoxDecoration(
                color: color ?? colorScheme.surface,
                borderRadius: BorderRadius.circular(SbRadius.standard),
                border: Border.all(
                  color: colorScheme.outlineVariant,
                  width: 1.0,
                ),
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
                    color: isPrimary ? colorScheme.primary : colorScheme.onSurfaceVariant,
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
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
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
    );
  }
}
