import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// lib/core/theme/app_typography.dart
///
/// PURPOSE:
/// Compact typography system for SiteBuddy. Enforces reduced font sizes
/// for a compact UI.
///
/// VARIANTS:
/// - headingLarge: Main screen titles (20px)
/// - headingMedium: Section headers (16px)
/// - title: Card titles, list items (14px)
/// - body: Primary content (13px)
/// - bodySmall: Secondary content (12px)
/// - label: Captions, metadata (11px)
///
/// REQUIREMENTS:
/// - No inline TextStyle allowed
/// - All text must use these variants
/// - Production ready
class AppTypography {
  AppTypography._();

  // ═══════════════════════════════════════════════════════════════════════
  // COMPACT TYPOGRAPHY SCALE
  // All sizes reduced for compact UI
  // ═══════════════════════════════════════════════════════════════════════

  /// Heading Large - Main screen titles (20px, SemiBold)
  static TextStyle get headingLarge => GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.4,
        height: 1.2,
      );

  /// Heading Medium - Section headers (16px, SemiBold)
  static TextStyle get headingMedium => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        height: 1.2,
      );

  /// Title - Card titles, list item titles (14px, SemiBold)
  static TextStyle get title => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.1,
        height: 1.2,
      );

  /// Body - Primary content (13px, Regular)
  static TextStyle get body => GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 1.3,
      );

  /// Body Small - Secondary content (12px, Regular)
  static TextStyle get bodySmall => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.3,
      );

  /// Label - Captions, metadata, button text (11px, Medium)
  static TextStyle get label => GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        height: 1.2,
      );

  // ═══════════════════════════════════════════════════════════════════════
  // TEXT THEME FOR THEMEDATA
  // ═══════════════════════════════════════════════════════════════════════

  /// Creates a TextTheme from the typography scale for use in ThemeData
  static TextTheme get textTheme => TextTheme(
        displayLarge: headingLarge,
        displayMedium: headingLarge,
        displaySmall: headingMedium,
        headlineLarge: headingLarge,
        headlineMedium: headingMedium,
        headlineSmall: headingMedium,
        titleLarge: headingMedium,
        titleMedium: title,
        titleSmall: title,
        bodyLarge: body,
        bodyMedium: bodySmall,
        bodySmall: label,
        labelLarge: label,
        labelMedium: label,
        labelSmall: label,
      );
}