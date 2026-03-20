import 'package:flutter/material.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/design_system/sb_radius.dart';

/// WIDGET: SbCard
/// PURPOSE: Standardized surface-based card container.
/// FEATURES:
/// - Three-tier hierarchy (Elevated, Standard, Subtle).
/// - Adaptive padding logic.
class SbCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
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
    final br = BorderRadius.circular(SbRadius.medium);

    // Tonal Hierarchy based on prominence
    final surfaceColor = color ?? 
        (isElevated 
            ? colorScheme.surfaceContainerHigh 
            : (isSubtle ? colorScheme.surface : colorScheme.surfaceContainer));

    return Container(
      margin: margin ?? EdgeInsets.zero,
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: br,
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: isSubtle ? 0.05 : 0.1),
          width: 0.8,
        ),
        boxShadow: isSubtle ? null : [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
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
