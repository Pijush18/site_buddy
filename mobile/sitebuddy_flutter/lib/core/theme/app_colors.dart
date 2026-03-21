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

extension AppContext on BuildContext {
  AppColorsData get colors => AppColorsData(this);
}

class AppColorsData {
  final BuildContext _context;
  AppColorsData(this._context);


  Color get outline => AppColors.outline(_context);
  Color get surface => AppColors.surface(_context);
  Color get background => AppColors.background(_context);
  Color get success => AppColors.success(_context);
  Color get warning => AppColors.warning(_context);
  Color get premium => AppColors.premium(_context);
  
  // Theme Overrides
  Color get primary => Theme.of(_context).colorScheme.primary;
  Color get onPrimary => Theme.of(_context).colorScheme.onPrimary;
  Color get onSurface => Theme.of(_context).colorScheme.onSurface;
  Color get onSurfaceVariant => Theme.of(_context).colorScheme.onSurfaceVariant;
  Color get error => Theme.of(_context).colorScheme.error;
}






