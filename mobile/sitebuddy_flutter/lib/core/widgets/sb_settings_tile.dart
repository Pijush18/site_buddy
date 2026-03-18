import 'package:flutter/material.dart';
import 'package:site_buddy/core/widgets/sb_list_item_tile.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';

/// WidGET: SbSettingsTile
/// PURPOSE: Standardized settings row for professional production-grade interfaces.
class SbSettingsTile extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? iconColor;
  final bool isVertical;

  const SbSettingsTile({
    super.key,
    this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.iconColor,
    this.isVertical = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isVertical) {
      // Keep vertical layout as is or refactor if SbListItemTile can't handle it.
      // For settings, vertical usually means subtitle/trailing below.
      // Let's keep it consistent with the new design system where possible.
      final theme = Theme.of(context);
      final colorScheme = theme.colorScheme;
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (icon != null) ...[
                      Icon(icon, color: iconColor ?? colorScheme.primary, size: 24),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
                if (trailing != null) ...[
                  const SizedBox(height: 12),
                  trailing!,
                ],
              ],
            ),
          ),
        ),
      );
    }

    return SbListItemTile(
      icon: icon,
      iconColor: iconColor,
      title: title,
      subtitle: subtitle,
      onTap: onTap ?? () {},
      trailing: trailing ?? (onTap != null ? Icon(SbIcons.chevronRight, size: 20, color: Theme.of(context).colorScheme.onSurfaceVariant) : null),
    );
  }
}
