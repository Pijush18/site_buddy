import 'package:site_buddy/core/theme/app_layout.dart';

import 'package:flutter/material.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';


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
          padding: const EdgeInsets.all(SbSpacing.lg),
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
                    const SizedBox(width: SbSpacing.lg),
                  ],
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.labelLarge!,
                    ),
                  ),
                ],
              ),
              if (trailing != null) ...[
                const SizedBox(height: SbSpacing.md),
                trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}










