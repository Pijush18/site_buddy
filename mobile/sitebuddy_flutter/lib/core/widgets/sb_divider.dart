import 'package:flutter/material.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';

/// WIDGET: SBDivider
/// PURPOSE: Standardized divider to replace all Divider usage.
///
/// VARIANTS:
/// - default: Full-width divider with theme color
/// - compact: Divider with horizontal padding (indented appearance)
/// - vertical: Vertical divider for row layouts
///
/// RULES:
/// - Uses AppSpacing for spacing values
/// - Uses theme colors (no hardcoded colors)
/// - Controlled thickness via variant
enum SBDividerVariant {
  defaultVariant,
  compact,
  vertical,
}

/// WIDGET: SBDivider
class SBDivider extends StatelessWidget {
  /// Divider variant
  final SBDividerVariant variant;

  /// Optional spacing above/below divider (for default/compact)
  final double? spacing;

  /// Whether to show a label in the middle (optional)
  final String? label;

  const SBDivider({
    super.key,
    this.variant = SBDividerVariant.defaultVariant,
    this.spacing,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    switch (variant) {
      case SBDividerVariant.defaultVariant:
        return Padding(
          padding: EdgeInsets.symmetric(
            vertical: spacing ?? AppSpacing.md,
          ),
          child: Divider(
            height: 1,
            color: colorScheme.outlineVariant,
            thickness: 1,
          ),
        );

      case SBDividerVariant.compact:
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: spacing ?? AppSpacing.md,
          ),
          child: Divider(
            height: 1,
            color: colorScheme.outlineVariant,
            thickness: 1,
          ),
        );

      case SBDividerVariant.vertical:
        return SizedBox(
          height: double.infinity,
          width: 1,
          child: VerticalDivider(
            width: 1,
            color: colorScheme.outlineVariant,
            thickness: 1,
          ),
        );
    }
  }

  // Convenience constructors

  /// Creates a default (full-width) divider
  factory SBDivider.standard({
    double? spacing,
  }) {
    return SBDivider(
      variant: SBDividerVariant.defaultVariant,
      spacing: spacing,
    );
  }

  /// Creates a compact (indented) divider
  factory SBDivider.compact({
    double? spacing,
  }) {
    return SBDivider(
      variant: SBDividerVariant.compact,
      spacing: spacing,
    );
  }
}