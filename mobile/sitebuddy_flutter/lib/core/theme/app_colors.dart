import 'package:flutter/material.dart';

/// CLASS: AppColors
/// PURPOSE: Centralized semantic color system for SiteBuddy.
/// UPDATED: Professional Color System roles (Surface/Background inversion).
class AppColors {
  AppColors._();

  static const Color skyBlue = Color(0xFF38BDF8);

  /// Returns the standard surface color from the automated ColorScheme.
  static Color surface(BuildContext context) => Theme.of(context).colorScheme.surface;

  /// Returns the standard background color from the automated ColorScheme.
  static Color background(BuildContext context) => Theme.of(context).colorScheme.surface;

  /// Returns the standard outline color from the automated ColorScheme.
  static Color outline(BuildContext context) => Theme.of(context).colorScheme.outline;

  /// Returns colors for situational feedback (Uses primary/error as defaults in automated system)
  static Color success(BuildContext context) => Theme.of(context).colorScheme.primary; 
  static Color warning(BuildContext context) => const Color(0xFFF59E0B); // Amber 500 (Semantic override)
  static Color premium(BuildContext context) => const Color(0xFFF59E0B); // Global Premium Amber
}



