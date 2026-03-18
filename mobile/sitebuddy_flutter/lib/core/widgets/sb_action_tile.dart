import 'package:flutter/material.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:site_buddy/core/widgets/sb_card.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';

/// WIDGET: SbActionTile
/// PURPOSE: Standardized interactive tile for tools, quick actions, and grid items.
/// 
/// DESIGN SPECS:
/// - Follows [AppCard] shadow and radius rules.
/// - Supports vibrant (gradient/filled) and standard states.
/// - Centered icon and label layout.
class SbActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  
  /// Optional override for the tile color. 
  /// In vibrant mode, this is the background color.
  /// In standard mode, this is the icon color.
  final Color? color;
  
  /// Whether to use the vibrant (filled) background style.
  final bool isVibrant;

  const SbActionTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
    this.isVibrant = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    // Color Logic
    final backgroundColor = isVibrant 
        ? (color ?? colorScheme.primary) 
        : colorScheme.surface;
        
    final contentColor = isVibrant 
        ? colorScheme.onPrimary 
        : (color ?? colorScheme.onSurface);


    return SbCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      color: backgroundColor,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: isVibrant
            ? BoxDecoration(
                borderRadius: AppLayout.borderRadiusCard,
                gradient: LinearGradient(
                  colors: [
                    backgroundColor,
                    backgroundColor.withValues(alpha: 0.9),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              )
            : null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: contentColor,
              size: 24,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: contentColor,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
