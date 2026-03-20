// lib/core/design_system/sb_typography.dart

import 'package:flutter/material.dart';

class SbTypography {
  SbTypography._();

  static TextTheme get textTheme => const TextTheme(
    // 🔹 Large headers
    displayLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      letterSpacing: -0.5,
    ),

    headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),

    // 🔹 Section titles
    titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),

    titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),

    // 🔹 Body text
    bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),

    bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),

    // 🔹 Small text / metadata
    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),

    labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
  );
}



