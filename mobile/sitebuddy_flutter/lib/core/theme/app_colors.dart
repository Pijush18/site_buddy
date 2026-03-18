import 'package:flutter/material.dart';

/// CLASS: AppColors
/// PURPOSE: Centralized semantic color system for SiteBuddy.
/// Ensuring background != surface for clean flat looks.
class AppColors {
  AppColors._();

  /// Returns the standard surface color for the current theme.
  /// Purpose: Used for cards, tiles, and interactive surfaces.
  static Color surface(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark 
        ? const Color(0xFF1E293B) 
        : const Color(0xFFF8FAFC);
  }

  /// Returns the standard background color for the current theme.
  /// Purpose: Used for the main scaffold background.
  static Color background(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark 
        ? const Color(0xFF0F172A) 
        : const Color(0xFFFFFFFF);
  }

  /// Returns the standard outline color for borders.
  static Color outline(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark 
        ? const Color(0xFF334155) 
        : const Color(0xFFE2E8F0);
  }

  /// Returns a stronger outline color for high-visibility borders.
  static Color outlineStrong(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark 
        ? const Color(0xFF475569) // Slate 600
        : const Color(0xFFCBD5E1); // Slate 300
  }
}
