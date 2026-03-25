import 'package:flutter/material.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/design_system/sb_radius.dart';
import 'package:site_buddy/core/widgets/sb_interactive_card.dart';


/// WIDGET: SbCard
/// PURPOSE: Standardized surface-based card container.
/// 
/// DESIGN RULES:
/// - Cards control INTERNAL padding only (SbSpacing.md by default)
/// - Cards do NOT control OUTER/MARGIN spacing (screens control this)
/// - Use [padding] parameter for internal content spacing
/// - Three-tier hierarchy: Elevated, Standard, Subtle
class SbCard extends StatelessWidget {
  final Widget child;
  
  /// Internal padding for card content (NOT outer spacing)
  final EdgeInsetsGeometry? padding;
  
  final Color? color;
  final VoidCallback? onTap;
  final bool isElevated;
  final bool isSubtle;

  const SbCard({
    super.key,
    required this.child,
    this.padding,
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
        // NO MARGIN - screens control outer spacing
        padding: padding ?? const EdgeInsets.all(SbSpacing.md),
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
