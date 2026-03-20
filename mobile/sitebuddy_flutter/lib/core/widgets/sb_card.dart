import 'package:flutter/material.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:site_buddy/core/theme/app_colors.dart';

/// WIDGET: SbCard
/// PURPOSE: Standardized surface-based card container.
/// FEATURES:
/// - Subtle elevation using shadow and 1px border.
/// - Adaptive padding logic.
/// - Surface color (WHITE) on Background color (TINTED).
class SbCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? color;
  final VoidCallback? onTap;

  const SbCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final borderRadius = BorderRadius.circular(AppLayout.cardRadius);
    
    return Container(
      margin: margin ?? EdgeInsets.zero,
      decoration: BoxDecoration(
        color: color ?? colorScheme.surfaceContainerLow,
        borderRadius: borderRadius,
        border: Border.all(
          color: AppColors.skyBlue.withValues(alpha: 0.7), 
          width: 1.0,
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Adaptive Padding Logic
          final availableHeight = constraints.maxHeight;
          double dynamicPaddingValue;

          if (padding != null) {
            return _buildContent(padding!, borderRadius);
          }

          // Optimized for dashboard density
          if (availableHeight < 60) {
            dynamicPaddingValue = AppSpacing.xs; // 4px
          } else {
            dynamicPaddingValue = 12.0; // Optimized mid-density
          }

          return _buildContent(
            EdgeInsets.all(dynamicPaddingValue), 
            borderRadius,
          );
        },
      ),
    );
  }

  Widget _buildContent(EdgeInsets padding, BorderRadius borderRadius) {
    return Material(
      color: Colors.transparent,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
