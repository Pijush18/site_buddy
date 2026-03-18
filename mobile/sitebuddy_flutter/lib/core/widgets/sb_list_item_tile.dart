import 'package:flutter/material.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/widgets/sb_card.dart';

/// WIDGET: SbListItemTile
/// PURPOSE: Standardized list item UI enforcing global typography and spacing.
/// 
/// DESIGN SPECS:
/// - Uses [SbCard] master surface.
/// - NO external margin (spacing managed by parent layout/section).
/// - Icon: 40px in 48x48 container.
/// - Gap (Icon <-> Text): AppSpacing.sm (8px).
/// - Title: 14px, w600.
/// - Subtitle: 12px.
/// - Title-Subtitle gap: 2px.
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
    final colorScheme = Theme.of(context).colorScheme;

    Widget? trailingWidget;
    if (trailing is String) {
      trailingWidget = Text(
        trailing as String,
        style: TextStyle(
          fontSize: 12,
          color: colorScheme.onSurfaceVariant,
        ),
      );
    } else if (trailing is Widget) {
      trailingWidget = trailing as Widget;
    }

    return SbCard(
      padding: EdgeInsets.zero,
      onTap: onTap,
      color: color,
      // SPACING OWNERSHIP: Removed bottom margin. 
      // Spacing between items is now controlled by the parent Column/Section.
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            if (icon != null) ...[
              SizedBox(
                width: 48,
                height: 48,
                child: Center(
                  child: Icon(
                    icon,
                    color: iconColor ?? colorScheme.primary,
                    size: 40, // LOCKED: 40px
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle != null && subtitle!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            if (trailingWidget != null) ...[
              const SizedBox(width: AppSpacing.sm),
              trailingWidget,
            ],
          ],
        ),
      ),
    );
  }
}
