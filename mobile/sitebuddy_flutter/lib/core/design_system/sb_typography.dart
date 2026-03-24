// lib/core/design_system/sb_typography.dart

import 'package:flutter/material.dart';

class SbTypography {
  SbTypography._();

  static TextTheme get textTheme => const TextTheme(
    // 🔹 Headlines
    displayLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: -0.4, height: 1.2),
    displayMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: -0.3, height: 1.2),
    displaySmall: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: -0.2, height: 1.2),
    headlineLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: -0.3, height: 1.2),
    headlineMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: -0.2, height: 1.2),
    headlineSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: -0.2, height: 1.2),

    // 🔹 Titles
    titleLarge: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: -0.2, height: 1.2),
    titleMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: -0.1, height: 1.2),
    titleSmall: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, letterSpacing: 0, height: 1.2),

    // 🔹 Body text
    bodyLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, height: 1.3),
    bodyMedium: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, height: 1.3),
    bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, height: 1.3),

    // 🔹 Labels
    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.1, height: 1.2),
    labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 0.1, height: 1.2),
    labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 0.1, height: 1.2),
  );

  // 🔹 Static getters for direct access (using theme text styles)
  static TextStyle get headline => textTheme.headlineSmall!;
  static TextStyle get title => textTheme.titleMedium!;
  static TextStyle get body => textTheme.bodyMedium!;
  static TextStyle get bodySmall => textTheme.bodySmall!;
  static TextStyle get label => textTheme.labelLarge!;
  static TextStyle get caption => textTheme.labelSmall!;
}



