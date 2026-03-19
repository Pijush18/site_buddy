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
              color: colorScheme.primary.withValues(alpha: 0.15),
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.08 : 0.05),
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          padding: const EdgeInsets.all(12.0), 
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, 
            children: [
              Icon(
                icon,
                color: colorScheme.primary,
                size: 22,
              ),
              const SizedBox(height: 6), 
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