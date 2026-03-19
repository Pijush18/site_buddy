import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

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
      borderRadius: BorderRadius.circular(10.0),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          constraints: const BoxConstraints(
            minHeight: 100, // Fixed 100px height
            maxHeight: 100,
          ),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              color: colorScheme.outline, // 👈 Standard theme outline
              width: 1.0,
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
          padding: const EdgeInsets.all(AppSpacing.sm), 
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, 
            children: [
              Icon(
                icon,
                color: colorScheme.primary,
                size: 22,
              ),
              const SizedBox(height: AppSpacing.sm), 
              Text(
                label,
                textAlign: TextAlign.center, 
                maxLines: 2, 
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600, 
                  color: colorScheme.onSurface,
                  fontSize: 14, 
                  height: 1.0, 
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}