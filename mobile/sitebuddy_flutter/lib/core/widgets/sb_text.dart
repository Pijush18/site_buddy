import 'package:flutter/material.dart';
import 'package:site_buddy/core/design_system/sb_typography.dart';

/// WIDGET: SBText
/// PURPOSE: Single unified text component. Replaces ALL direct Text usage.
///
/// VARIANTS:
/// - headingLarge: Main screen titles
/// - headingMedium: Section headers
/// - title: Card titles
/// - body: Primary content
/// - bodySmall: Secondary content
/// - label: Captions/metadata
///
/// RULES:
/// - MUST use SbTypography only - NO inline TextStyle allowed
/// - Color is overridden from AppColors only via color parameter
/// - All text in app must use this component
enum SBTextVariant {
  headingLarge,
  headingMedium,
  title,
  body,
  bodySmall,
  label,
}

/// WIDGET: SBText
/// USAGE: Replace all Text widgets with this component
class SBText extends StatelessWidget {
  /// The text content
  final String data;

  /// Text variant (maps to SbTypography)
  final SBTextVariant variant;

  /// Override text color from AppColors (optional)
  /// If null, uses theme's default text color
  final Color? color;

  /// Text alignment
  final TextAlign? textAlign;

  /// Maximum number of lines
  final int? maxLines;

  /// Whether text is selectable
  final bool selectable;

  const SBText(
    this.data, {
    super.key,
    this.variant = SBTextVariant.body,
    this.color,
    this.textAlign,
    this.maxLines,
    this.selectable = false,
  });

  @override
  Widget build(BuildContext context) {
    // Get the style based on variant
    TextStyle style = _getStyle();

    // Apply color override if provided
    if (color != null) {
      style = style.copyWith(color: color);
    }

    // Wrap in SelectableText if needed
    if (selectable) {
      return SelectableText(
        data,
        style: style,
        textAlign: textAlign,
        maxLines: maxLines,
      );
    }

    return Text(
      data,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
    );
  }

  TextStyle _getStyle() {
    switch (variant) {
      case SBTextVariant.headingLarge:
        return SbTypography.headingLarge;
      case SBTextVariant.headingMedium:
        return SbTypography.headingMedium;
      case SBTextVariant.title:
        return SbTypography.title;
      case SBTextVariant.body:
        return SbTypography.body;
      case SBTextVariant.bodySmall:
        return SbTypography.bodySmall;
      case SBTextVariant.label:
        return SbTypography.label;
    }
  }

  // Convenience factory constructors for common variants

  /// Creates SBText with headingLarge variant
  factory SBText.heading(
    String data, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
  }) {
    return SBText(
      data,
      key: key,
      variant: SBTextVariant.headingLarge,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
    );
  }

  /// Creates SBText with title variant
  factory SBText.title(
    String data, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
  }) {
    return SBText(
      data,
      key: key,
      variant: SBTextVariant.title,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
    );
  }

  /// Creates SBText with body variant
  factory SBText.body(
    String data, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
  }) {
    return SBText(
      data,
      key: key,
      variant: SBTextVariant.body,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
    );
  }

  /// Creates SBText with label variant
  factory SBText.label(
    String data, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
  }) {
    return SBText(
      data,
      key: key,
      variant: SBTextVariant.label,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
    );
  }
}