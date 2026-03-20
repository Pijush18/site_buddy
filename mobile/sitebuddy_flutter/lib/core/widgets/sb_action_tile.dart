import 'package:flutter/material.dart';
import 'package:site_buddy/core/design_system/sb_radius.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';


/// WIDGET: SbActionTile
/// PURPOSE: Standardized interactive tile for tools and quick actions.
/// REFINEMENT: Tight, overflow-proof premium layout.
class SbActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;
  final bool isProminent;

  const SbActionTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
    this.isProminent = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    // Premium Hierarchy: Prominent tiles use stronger primary theme
    final contentColor = color ?? (isProminent ? colorScheme.primary : colorScheme.onSurface);
    final iconOpacity = isProminent ? 0.16 : 0.12;
    
    // Tight layout: reduced padding for better fit in 2-column grid
    final padding = isProminent 
        ? const EdgeInsets.symmetric(horizontal: SbSpacing.sm, vertical: SbSpacing.md)
        : const EdgeInsets.symmetric(horizontal: SbSpacing.xs, vertical: SbSpacing.sm);

    return SizedBox(
      width: double.infinity,
      child: Material(
        color: Colors.transparent, // Always transparent, parent provides surface
        child: InkWell(
          onTap: onTap,
          borderRadius: SbRadius.borderMd,
          child: Padding(
            padding: padding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Visual Anchor: Premium Icon Container (tightened)
                Container(
                  padding: const EdgeInsets.all(SbSpacing.sm),
                  decoration: BoxDecoration(
                    color: contentColor.withValues(alpha: iconOpacity),
                    borderRadius: SbRadius.borderMedium,
                  ),
                  child: Icon(
                    icon,
                    color: contentColor.withValues(alpha: 0.95),
                    size: 24, // Balanced size to avoid overflow
                  ),
                ),
                const SizedBox(height: SbSpacing.sm),
                
                // Tightened text with overflow protection
                Flexible(
                  child: Text(
                    label,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: isProminent ? FontWeight.w700 : FontWeight.w600,
                      fontSize: 12, // Slightly smaller for better fit
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
