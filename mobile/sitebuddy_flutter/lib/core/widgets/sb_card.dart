import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';

/// WIDGET: SbCard
/// PURPOSE: Standardized card container for SiteBuddy.
/// Uses sbCommonDecoration — same border + deep shadow as the global design system.
/// Supports optional onTap with a ripple via InkWell + Material.
class SbCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final Color? color;
  final VoidCallback? onTap;
  final double?
  elevation; // kept for API compat; ignored in favour of boxShadow
  final ShapeBorder? shape; // kept for API compat; ignored when null

  const SbCard({
    super.key,
    required this.child,
    this.padding,
    this.color,
    this.onTap,
    this.elevation,
    this.shape,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // If caller supplies a custom shape, fall back to Card to honour it.
    if (shape != null) {
      return Card(
        color: color ?? colorScheme.surface,
        elevation: elevation ?? 0,
        shape: shape,
        child: InkWell(
          onTap: onTap,
          borderRadius: (shape is RoundedRectangleBorder)
              ? (shape as RoundedRectangleBorder).borderRadius as BorderRadius
              : AppLayout.borderRadiusCard,
          child: Padding(
            padding: padding ?? const EdgeInsets.all(AppLayout.md),
            child: child,
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: color ?? colorScheme.surface,
        borderRadius: AppLayout.borderRadiusCard,
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.10)
              : Colors.grey.withValues(alpha: 0.20),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.30 : 0.12),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: AppLayout.borderRadiusCard,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppLayout.borderRadiusCard,
          child: Padding(
            padding: padding ?? AppLayout.paddingMedium,
            child: child,
          ),
        ),
      ),
    );
  }
}
