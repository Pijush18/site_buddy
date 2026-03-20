import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/theme/app_text_styles.dart';
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
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (icon != null) ...[
                      Icon(icon, color: iconColor ?? colorScheme.primary, size: 24),
                      const SizedBox(width: AppSpacing.sm),
                    ],
                    Expanded(
                      child: Text(
                        title,
                        style: AppTextStyles.sectionTitle(context).copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    subtitle!,
                    style: AppTextStyles.caption(context).copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
                if (trailing != null) ...[
                  const SizedBox(height: AppSpacing.sm),
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
