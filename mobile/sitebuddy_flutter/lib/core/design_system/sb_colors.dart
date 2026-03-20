import 'package:flutter/material.dart';

/// CLASS: SbColors
/// PURPOSE: Standardized color policy for SiteBuddy UI system.
class SbColors {
  SbColors._();

  // 🧱 Base Palette
  static const Color primarySeed = Color(0xFF1E3A8A);
  
  // ☀️ Light Mode
  static const Color lightSurface = Color(0xFFF8FAFC);
  static const Color lightContainer = Color(0xFFFFFFFF);
  static const Color lightContainerHigh = Color(0xFFF1F5F9);

  // 🌙 Dark Mode
  static const Color darkSurface = Color(0xFF0F172A);
  static const Color darkContainer = Color(0xFF1E293B);
  static const Color darkContainerHigh = Color(0xFF334155);

  static Color background(BuildContext context) => Theme.of(context).colorScheme.surface;
  static Color surface(BuildContext context) => Theme.of(context).colorScheme.surface;
}



