import 'package:site_buddy/core/design_system/sb_text_styles.dart';

import 'package:site_buddy/core/theme/app_layout.dart';

import 'package:flutter/material.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';

/// WIDGET: DesignCategoryCard
/// PURPOSE: Standardized grid item for the Design module with premium aesthetics.
/// DESIGN: Theme-aware background, circular icon container, Primary Blue icon.
class DesignCategoryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const DesignCategoryCard({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
//     final isDark = theme.brightness == Brightness.dark;

    return SbCard(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Circular Icon Container
          Container(
            padding: const EdgeInsets.all(AppLayout.pMedium),
            
            child: Icon(
              icon,
              size: 24,
              color: colorScheme.primary,
            ),
          ),
          AppLayout.vGap8,
          // Label
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppLayout.pSmall),
            child: Text(
              label,
              style: SbTextStyles.body(context).copyWith(
                color: colorScheme.onSurface,
                
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}