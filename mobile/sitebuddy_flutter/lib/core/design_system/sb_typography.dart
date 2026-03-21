// lib/core/design_system/sb_typography.dart

import 'package:flutter/material.dart';

class SbTypography {
  SbTypography._();

  static TextTheme get textTheme => const TextTheme(
    // 🔹 Screen titles (Max 18)
    displayLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: -0.5, height: 1.2),
    headlineMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: -0.3, height: 1.2),

    // 🔹 Screen titles
    titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: -0.3, height: 1.2),

    // 🔹 Section headers
    titleMedium: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: -0.2, height: 1.2),

    // 🔹 Body text
    bodyLarge: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, height: 1.3),
    bodyMedium: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, height: 1.3),

    // 🔹 Buttons
    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, height: 1.2),

    // 🔹 Caption / Small text
    labelMedium: TextStyle(fontSize: 11, fontWeight: FontWeight.w400, height: 1.2),
    labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w400, height: 1.2),
  );
}



