import 'package:flutter/material.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/widgets/sb_list_item_tile.dart';

/// WidGET: SbSettingsTile
/// PURPOSE: Standardized settings row for professional production-grade interfaces.
class SbSettingsTile extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool isVertical;
  final bool isPrimary;

  const SbSettingsTile({
    super.key,
    this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.isVertical = false,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    if (isVertical) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(SbSpacing.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (icon != null) ...[
                      Icon(icon, color: isPrimary ? colorScheme.primary : colorScheme.onSurfaceVariant, size: 24),
                      const SizedBox(width: SbSpacing.sm),
                    ],
                    Expanded(
                      child: Text(
                        title,
                        style: textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: SbSpacing.xs),
                  Text(
                    subtitle!,
                    style: textTheme.bodyMedium,
                  ),
                ],
                if (trailing != null) ...[
                  const SizedBox(height: SbSpacing.sm),
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
      title: title,
      subtitle: subtitle,
      onTap: onTap ?? () {},
      isPrimary: isPrimary,
      trailing: trailing ?? (onTap != null ? Icon(SbIcons.chevronRight, size: 20, color: colorScheme.onSurfaceVariant) : null),
    );
  }
}
