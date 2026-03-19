

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// CLASS: AppTextStyles
/// PURPOSE: Static accessor for the global typography system.
/// DESIGN: Uses Google Fonts (Inter) with specific weights and sizes.
///         COLOR properties are OMITTED to allow the theme to control text colors
///         dynamically based on light/dark mode.
class AppTextStyles {
  // Title Styles
  static final TextStyle titleLarge = GoogleFonts.inter(
    fontSize: 22,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle titleMedium = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle titleSmall = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  // Body Styles
  static final TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );

  static final TextStyle bodyMedium = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );

  static final TextStyle bodySmall = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.normal,
  );

  // Label Styles
  static final TextStyle labelMedium = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle labelSmall = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  // Headline Styles (e.g. for calculators/prominent values)
  static final TextStyle headlineLarge = GoogleFonts.inter(
    fontSize: 32,
    fontWeight: FontWeight.bold,
  );
}
