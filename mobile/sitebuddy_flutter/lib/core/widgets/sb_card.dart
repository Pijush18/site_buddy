import 'package:flutter/material.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/design_system/sb_radius.dart';
import 'package:site_buddy/core/theme/app_colors.dart';
import 'package:site_buddy/core/theme/app_border.dart';


/// WIDGET: SbCard
/// PURPOSE: Standardized surface-based card container.
/// FEATURES:
/// - Three-tier hierarchy (Elevated, Standard, Subtle).
/// - Adaptive padding logic.
class SbCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final VoidCallback? onTap;
  final bool isElevated;
  final bool isSubtle;

  const SbCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.onTap,
    this.isElevated = false,
    this.isSubtle = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final br = SbRadius.borderMedium;

    // Tonal Hierarchy based on prominence
    final surfaceColor = color ?? 
        (isElevated 
            ? colorScheme.surfaceContainerHigh 
            : colorScheme.surfaceContainer); // Optimized for contrast as per Task 4

    return Container(
      margin: margin ?? EdgeInsets.zero,
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: br,
        border: Border.all(
          color: context.colors.outline,
          width: AppBorder.width,
        ),
        boxShadow: isElevated ? [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ] : [],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: br,
        child: InkWell(
          onTap: onTap,
          borderRadius: br,
          child: Padding(
            padding: padding ?? const EdgeInsets.all(SbSpacing.md),
            child: child,
          ),
        ),
      ),
    );
  }
}
