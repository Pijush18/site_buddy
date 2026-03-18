import 'package:flutter/material.dart';
import 'package:site_buddy/core/theme/app_colors.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/theme/app_radius.dart';
import 'package:site_buddy/core/theme/app_border.dart';

/// WIDGET: SbCard
/// PURPOSE: Standardized flat card container with adaptive padding.
/// 
/// FEATURES:
/// - Dynamic padding that scales down if vertical space is limited.
/// - Uses standard SiteBuddy design tokens.
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
    final borderRadius = BorderRadius.circular(AppRadius.md);
    
    return Container(
      margin: margin ?? EdgeInsets.zero,
      decoration: BoxDecoration(
        color: color ?? AppColors.surface(context),
        borderRadius: borderRadius,
        border: Border.all(
          color: AppColors.outlineStrong(context),
          width: AppBorder.width,
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Adaptive Padding Logic
          final availableHeight = constraints.maxHeight;
          double dynamicPaddingValue;

          if (padding != null) {
            // Manual override takes precedence
            return _buildContent(padding!, borderRadius);
          }

          if (availableHeight < AppSpacing.lg) {
            dynamicPaddingValue = AppSpacing.xs; // 4px
          } else {
            dynamicPaddingValue = AppSpacing.sm; // 8px (Standard Core Density)
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
