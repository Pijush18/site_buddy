import 'package:site_buddy/core/design_system/sb_radius.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/theme/app_colors.dart';
import 'package:site_buddy/core/theme/app_border.dart';


/// CLASS: ActionCard
/// PURPOSE: Standardized high-density quick action card. (SURFACE MODE RESTORED)
class ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const ActionCard({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: colorScheme.surface,
      borderRadius: SbRadius.borderMd,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: SbRadius.borderMd,
        child: Container(
          constraints: const BoxConstraints(
            minHeight: 100, // Fixed 100px height
            maxHeight: 100,
          ),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: SbRadius.borderMd,
            border: Border.all(
              color: context.colors.outline,
              width: AppBorder.width,
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withValues(
                  alpha: isDark ? 0.15 : 0.04,
                ), // Refined depth
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(SbSpacing.sm), 
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, 
            children: [
              Icon(
                icon,
                color: colorScheme.primary,
                size: 22,
              ),
              SizedBox(height: SbSpacing.sm), 
              Text(
                label,
                textAlign: TextAlign.center, 
                maxLines: 2, 
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium!,
              ),
            ],
          ),
        ),
      ),
    );
  }
}





