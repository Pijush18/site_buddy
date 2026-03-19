import 'package:flutter/material.dart';
import 'package:site_buddy/core/theme/app_colors.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';

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
    final isDark = theme.brightness == Brightness.dark;
    final borderRadius = BorderRadius.circular(12); // Unified radius
    
    return Container(
      margin: margin ?? EdgeInsets.zero,
      decoration: BoxDecoration(
        color: color ?? AppColors.surface(context),
        borderRadius: borderRadius,
        // 🔬 Elevation Strategy: Low-opacity border + subtle shadow
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.1), 
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.08 : 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
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
