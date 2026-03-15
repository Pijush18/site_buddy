import 'package:flutter/material.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:site_buddy/core/design_system/sb_text_styles.dart';
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: AppLayout.paddingMedium,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: isVertical ? CrossAxisAlignment.center : CrossAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: (iconColor ?? colorScheme.primary).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppLayout.smallRadius),
                      ),
                      child: Icon(
                        icon,
                        size: 22,
                        color: iconColor ?? colorScheme.primary,
                      ),
                    ),
                    AppLayout.hGap16,
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: SbTextStyles.body(context).copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        if (subtitle != null && !isVertical) ...[
                          const SizedBox(height: 2),
                          Text(
                            subtitle!,
                            style: SbTextStyles.caption(context).copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (!isVertical && trailing != null) ...[
                    AppLayout.hGap16,
                    trailing!,
                  ] else if (!isVertical && onTap != null) ...[
                    AppLayout.hGap16,
                    Icon(
                      SbIcons.chevronRight,
                      size: 20,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ],
                ],
              ),
              if (isVertical) ...[
                if (subtitle != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    subtitle!,
                    style: SbTextStyles.caption(context).copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
                if (trailing != null) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: trailing!,
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}
