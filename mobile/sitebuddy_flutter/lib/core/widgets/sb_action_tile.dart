import 'package:flutter/material.dart';
import 'package:site_buddy/core/theme/app_text_styles.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/widgets/sb_card.dart';

/// WIDGET: SbActionTile
/// PURPOSE: Standardized interactive tile for tools and quick actions.
/// 
/// DESIGN OPTIMIZATION: Relies on SbCard for adaptive vertical padding protection.
class SbActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  
  /// Optional override for the tile background color.
  final Color? color;
  
  /// Whether to use the vibrant (filled) primary style.
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
        : null; // Null means SbCard uses default surface
        
    final contentColor = isVibrant 
        ? colorScheme.onPrimary 
        : (color ?? colorScheme.onSurface);

    return SbCard(
      onTap: onTap,
      color: backgroundColor,
      // Default padding is handled adaptively by SbCard
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: contentColor,
            size: 32, // LOCKED size
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            label,
            style: AppTextStyles.cardTitle(context).copyWith(
              color: contentColor,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
