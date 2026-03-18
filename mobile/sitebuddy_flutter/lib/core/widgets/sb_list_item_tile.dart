import 'package:flutter/material.dart';
import 'package:site_buddy/core/widgets/sb_card.dart';

/// WIDGET: SbListItemTile
/// PURPOSE: Standardized list item UI enforcing global icon, typography, and spacing rules.
/// 
/// DESIGN SPECS:
/// - Icon: 40px in 48x48 container
/// - Gap (Icon <-> Text): 8px (AppSpacing.sm)
/// - Title: 14px, w600 (AppFontSizes.tab)
/// - Subtitle: 12px
/// - Vertical Gap (Title <-> Subtitle): 2px
/// - Trailing: 12px (if String)
class SbListItemTile extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String? subtitle;
  final dynamic trailing; // Widget or String
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
    final colorScheme = theme.colorScheme;

    Widget? trailingWidget;
    if (trailing is String) {
      trailingWidget = Text(
        trailing as String,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
        ),
      );
    } else if (trailing is Widget) {
      trailingWidget = trailing as Widget;
    }

    return SbCard(
      padding: EdgeInsets.zero,
      onTap: onTap,
      color: color,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12.0, // Standardized padding
          vertical: 12.0,
        ),
        child: Row(
          children: [
            // Icon Container: LOCKED 48x48 if icon exists
            if (icon != null) ...[
              SizedBox(
                width: 48,
                height: 48,
                child: Center(
                  child: Icon(
                    icon,
                    color: iconColor ?? colorScheme.primary,
                    size: 32, // Adjusted for premium look
                  ),
                ),
              ),
              const SizedBox(width: 12), // Standardized gap
            ],

            // Text Block
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14, // LOCKED 14px
                      fontWeight: FontWeight.w600, // LOCKED w600
                      color: colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle != null && subtitle!.isNotEmpty) ...[
                    const SizedBox(height: 2), // LOCKED 2px vertical gap
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 12, // LOCKED 12px
                        fontWeight: FontWeight.normal, // LOCKED normal
                        height: 1.1,
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
              const SizedBox(width: 8),
              trailingWidget,
            ],
          ],
        ),
      ),
    );
  }
}
