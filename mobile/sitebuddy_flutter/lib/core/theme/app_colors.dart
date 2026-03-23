import 'package:flutter/material.dart';

/// CLASS: AppColors
/// PURPOSE: Centralized semantic color system for SiteBuddy.
///
/// STRUCTURE:
/// - Material colors (from ColorScheme)
/// - Semantic colors (success, warning, error)
/// - Surface colors (background, surface, container)
///
/// RULES:
/// - No widget should define its own color
/// - All colors must use theme's color scheme when possible
/// - Hardcoded colors only allowed for brand-specific values
class AppColors {
  AppColors._();

  // ═══════════════════════════════════════════════════════════════════════
  // PRIMARY COLORS
  // Brand-specific primary seed color
  // ═══════════════════════════════════════════════════════════════════════

  /// Primary seed color for generating Material color scheme
  static const Color primarySeed = Color(0xFF1E3A8A);

  /// Sky blue accent color
  static const Color skyBlue = Color(0xFF38BDF8);

  // ═══════════════════════════════════════════════════════════════════════
  // SURFACE COLORS (LIGHT MODE)
  // ═══════════════════════════════════════════════════════════════════════

  /// Light mode surface color
  static const Color lightSurface = Color(0xFFF8FAFC);

  /// Light mode container color
  static const Color lightContainer = Color(0xFFFFFFFF);

  /// Light mode elevated container color
  static const Color lightContainerHigh = Color(0xFFF1F5F9);

  // ═══════════════════════════════════════════════════════════════════════
  // SURFACE COLORS (DARK MODE)
  // ═══════════════════════════════════════════════════════════════════════

  /// Dark mode surface color
  static const Color darkSurface = Color(0xFF0F172A);

  /// Dark mode container color
  static const Color darkContainer = Color(0xFF1E293B);

  /// Dark mode elevated container color
  static const Color darkContainerHigh = Color(0xFF334155);

  // ═══════════════════════════════════════════════════════════════════════
  // SEMANTIC COLORS
  // ═══════════════════════════════════════════════════════════════════════

  /// Success color (green) - mapped to theme primary by default
  static const Color successGreen = Color(0xFF10B981);

  /// Warning color (amber)
  static const Color warningAmber = Color(0xFFF59E0B);

  /// Premium/gold color
  static const Color premiumGold = Color(0xFFF59E0B);

  /// Error color - will use theme's error color
  static Color error(BuildContext context) => Theme.of(context).colorScheme.error;

  /// Primary color - will use theme's primary color
  static Color primary(BuildContext context) => Theme.of(context).colorScheme.primary;

  /// On primary color - will use theme's onPrimary color
  static Color onPrimary(BuildContext context) => Theme.of(context).colorScheme.onPrimary;

  // ═══════════════════════════════════════════════════════════════════════
  // CONTEXT-AWARE COLORS
  // These methods automatically adapt to light/dark mode
  // ═══════════════════════════════════════════════════════════════════════

  /// Returns the surface color from the automated ColorScheme
  static Color surface(BuildContext context) => Theme.of(context).colorScheme.surface;

  /// Returns the background color from the automated ColorScheme
  static Color background(BuildContext context) => Theme.of(context).colorScheme.surface;

  /// Returns the outline color from the automated ColorScheme
  static Color outline(BuildContext context) => Theme.of(context).colorScheme.outline;

  /// Returns the on-surface color from the automated ColorScheme
  static Color onSurface(BuildContext context) => Theme.of(context).colorScheme.onSurface;

  /// Returns the on-surface-variant color from the automated ColorScheme
  static Color onSurfaceVariant(BuildContext context) =>
      Theme.of(context).colorScheme.onSurfaceVariant;

  /// Returns success color (context-aware)
  static Color successColor(BuildContext context) => Theme.of(context).colorScheme.primary;

  /// Returns warning color (fixed amber for semantic clarity)
  static Color warningColor(BuildContext context) => warningAmber;

  /// Returns premium color (fixed amber for brand consistency)
  static Color premiumColor(BuildContext context) => premiumGold;

  // ═══════════════════════════════════════════════════════════════════════
  // BACKWARD COMPATIBILITY METHODS (for existing code)
  // These match the old API: AppColors.success(context), AppColors.warning(context)
  // ═══════════════════════════════════════════════════════════════════════

  /// Backward compatible: Returns success color based on context
  static Color success(BuildContext context) => successColor(context);

  /// Backward compatible: Returns warning color based on context
  static Color warning(BuildContext context) => warningColor(context);

  /// Backward compatible: Returns premium color based on context
  static Color premium(BuildContext context) => premiumColor(context);
}

/// Extension to provide easy access to colors from BuildContext
extension AppContextColors on BuildContext {
  /// Access AppColors data through context
  AppColorsData get colors => AppColorsData(this);
}

/// Data class for context-based color access
class AppColorsData {
  final BuildContext _context;
  AppColorsData(this._context);

  // Theme colors
  Color get primary => AppColors.primary(_context);
  Color get onPrimary => AppColors.onPrimary(_context);
  Color get surface => AppColors.surface(_context);
  Color get background => AppColors.background(_context);
  Color get outline => AppColors.outline(_context);
  Color get onSurface => AppColors.onSurface(_context);
  Color get onSurfaceVariant => AppColors.onSurfaceVariant(_context);
  Color get error => AppColors.error(_context);
  Color get success => AppColors.successColor(_context);
  Color get warning => AppColors.warningColor(_context);
  Color get premium => AppColors.premiumColor(_context);
}
