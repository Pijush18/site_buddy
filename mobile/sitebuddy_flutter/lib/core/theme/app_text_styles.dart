import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// CLASS: AppTextStyles
/// PURPOSE: Centralized strict typography system for App.
/// DESIGN: Uses Google Fonts (Inter) with controlled weights (w400/w600) and line heights for a compact UI.
class AppTextStyles {
  // 1. Screen Title → strongest
  static final TextStyle screenTitle = GoogleFonts.inter(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  // 2. Section Title → secondary
  static final TextStyle sectionTitle = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  // 3. Card Title → medium emphasis
  static final TextStyle cardTitle = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  // 4. Body → low emphasis
  static final TextStyle body = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  // 5. Caption → lowest emphasis
  static final TextStyle caption = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );
}
