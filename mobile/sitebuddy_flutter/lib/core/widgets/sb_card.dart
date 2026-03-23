import 'package:flutter/material.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/design_system/sb_radius.dart';
import 'package:site_buddy/core/widgets/sb_interactive_card.dart';


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
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final surfaceColor = color ??
        (isElevated
            ? colorScheme.surfaceContainerHigh
            : colorScheme.surfaceContainer);

    return SbInteractiveCard(
      onTap: onTap,
      borderRadius: BorderRadius.circular(SbRadius.standard),
      child: Container(
        margin: margin ?? EdgeInsets.zero,
        padding: padding ?? const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(SbRadius.standard),
          border: Border.all(
            color: colorScheme.outlineVariant,
            width: 1.0,
          ),
          boxShadow: (isElevated && !isDark)
              ? [
                  BoxShadow(
                    color: colorScheme.shadow.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: child,
      ),
    );
  }
}
