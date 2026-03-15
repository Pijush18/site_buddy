import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/design_system/sb_text_styles.dart';

/// WIDGET: SbListItem
/// PURPOSE: Universal list row component with strict padding and icon sizing.
class SbListItem extends StatelessWidget {
  final Widget? leading;
  final Widget? trailing;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool isSelected;

  const SbListItem({
    super.key,
    required this.title,
    this.leading,
    this.trailing,
    this.subtitle,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: isSelected
          ? colorScheme.primaryContainer.withValues(alpha: 0.1)
          : Colors.transparent,
      borderRadius: AppLayout.borderRadiusCard,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppLayout.borderRadiusCard,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppLayout.pMedium,
            vertical: subtitle != null ? AppLayout.pMedium : AppLayout.pSmall,
          ),
          child: Row(
            children: [
              if (leading != null) ...[
                Container(
                  width: AppLayout.avatarSize,
                  height: AppLayout.avatarSize,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: IconTheme(
                      data: IconThemeData(
                        size: AppLayout.iconSize,
                        color: colorScheme.primary,
                      ),
                      child: leading!,
                    ),
                  ),
                ),
                const SizedBox(width: AppLayout.pMedium),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: SbTextStyles.title(context).copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: SbTextStyles.bodySecondary(context).copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: AppLayout.pMedium),
                trailing!,
              ] else if (onTap != null) ...[
                const SizedBox(width: AppLayout.pSmall),
                Icon(
                  SbIcons.chevronRight,
                  size: AppLayout.iconSize,
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
