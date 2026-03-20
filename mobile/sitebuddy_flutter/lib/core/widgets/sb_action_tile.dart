import 'package:flutter/material.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/widgets/sb_card.dart';

/// WIDGET: SbActionTile
/// PURPOSE: Standardized interactive tile for tools and quick actions.
class SbActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;
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
    
    final backgroundColor = isVibrant 
        ? (color ?? colorScheme.primary) 
        : null;
        
    final contentColor = isVibrant 
        ? colorScheme.onPrimary 
        : (color ?? colorScheme.onSurface);

    return SbCard(
      onTap: onTap,
      color: backgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: contentColor,
            size: 32,
          ),
          const SizedBox(height: SbSpacing.sm),
          Text(
            label,
            style: theme.textTheme.labelLarge!,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}




