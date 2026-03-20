
import 'package:flutter/material.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:site_buddy/core/theme/app_text_styles.dart';

/// WidGET: SettingTile
/// PURPOSE: A reusable list item for settings screens with icon support and responsive layout.
class SettingTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget? trailing;
  final VoidCallback onTap;

  const SettingTile({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppLayout.borderRadiusCard,
        child: Padding(
          padding: AppLayout.paddingMedium,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      size: 20,
                      color: colorScheme.primary,
                    ),
                    AppLayout.hGap16,
                  ],
                  Expanded(
                    child: Text(
                      title,
                      style: AppTextStyles.cardTitle(context).copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
              if (trailing != null) ...[
                AppLayout.vGap12,
                trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
