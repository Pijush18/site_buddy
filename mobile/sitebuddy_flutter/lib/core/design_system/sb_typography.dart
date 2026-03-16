import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// CLASS: SbTypography
/// PURPOSE: Standardized typography styles for SiteBuddy.
class SbTypography {
  SbTypography._();

  /// Title style for headers and primary labels.
  static TextStyle title(BuildContext context) => GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurface,
      );

  /// Subtitle style for secondary information.
  static TextStyle subtitle(BuildContext context) => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      );

  /// Tab text style for navigation elements.
  static TextStyle tabText(BuildContext context) => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Theme.of(context).colorScheme.onSurface,
      );
}
