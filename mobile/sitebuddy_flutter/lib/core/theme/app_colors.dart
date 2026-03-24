import 'package:flutter/material.dart';

/// CLASS: AppColors
/// PURPOSE: SINGLE SOURCE OF TRUTH for all color tokens in SiteBuddy.
///
/// STRUCTURE:
/// - Brand colors (fixed seed values)
/// - Surface colors (light/dark mode variants)
/// - Semantic colors (success, warning, error, info)
///
/// USAGE RULES:
/// - UI LAYER: Use Theme.of(context).colorScheme.* for all theme-aware colors
/// - SEMANTIC: Use AppColors.success / AppColors.warning / AppColors.error / AppColors.info
/// - FORBIDDEN: Colors.*, Color(0x...) in UI code (use Theme or AppColors instead)
///
/// MIGRATION:
/// - AppColors.success(context) → AppColors.success
/// - AppColors.warning(context) → AppColors.warning
/// - AppColors.error(context) → Theme.of(context).colorScheme.error
/// - AppColors.info(context) → AppColors.info
/// - AppColors.primary(context) → Theme.of(context).colorScheme.primary
/// - etc.
class AppColors {
  AppColors._();

  // ═══════════════════════════════════════════════════════════════════════
  // BRAND COLORS (Fixed seed values for ColorScheme generation)
  // ═══════════════════════════════════════════════════════════════════════

  /// Primary seed color for generating Material ColorScheme
  static const Color primarySeed = Color(0xFF1E3A8A);

  /// Sky blue accent color (brand specific)
  static const Color skyBlue = Color(0xFF38BDF8);

  // ═══════════════════════════════════════════════════════════════════════
  // SURFACE COLORS (Light Mode)
  // ═══════════════════════════════════════════════════════════════════════

  /// Light mode surface color
  static const Color lightSurface = Color(0xFFF8FAFC);

  /// Light mode container color
  static const Color lightContainer = Color(0xFFFFFFFF);

  /// Light mode elevated container color
  static const Color lightContainerHigh = Color(0xFFF1F5F9);

  // ═══════════════════════════════════════════════════════════════════════
  // SURFACE COLORS (Dark Mode)
  // ═══════════════════════════════════════════════════════════════════════

  /// Dark mode surface color
  static const Color darkSurface = Color(0xFF0F172A);

  /// Dark mode container color
  static const Color darkContainer = Color(0xFF1E293B);

  /// Dark mode elevated container color
  static const Color darkContainerHigh = Color(0xFF334155);

  // ═══════════════════════════════════════════════════════════════════════
  // SEMANTIC COLORS (Fixed values for consistent status indicators)
  // These return fixed colors regardless of theme for consistent status indication
  // ═══════════════════════════════════════════════════════════════════════

  /// Success/Safe color (green) - Use for positive/safe status
  static const Color success = Color(0xFF10B981);

  /// Warning color (amber) - Use for caution/warning status
  static const Color warning = Color(0xFFF59E0B);

  /// Error/Failure color (red) - Use for error/failure status
  static const Color error = Color(0xFFEF4444);

  /// Info color (blue) - Use for informational status
  static const Color info = Color(0xFF3B82F6);

  /// Premium/Gold color - Brand specific
  static const Color premium = Color(0xFFF59E0B);

  // ═══════════════════════════════════════════════════════════════════════
  // LEGACY ALIASES (For backward compatibility during migration)
  // Prefer the short names above (success, warning, error, info, premium)
  // ═══════════════════════════════════════════════════════════════════════

  /// @deprecated Use success instead
  static const Color successColor = success;

  /// @deprecated Use warning instead
  static const Color warningColor = warning;

  /// @deprecated Use error instead
  static const Color errorColor = error;

  /// @deprecated Use info instead
  static const Color infoColor = info;

  /// @deprecated Use premium instead
  static const Color premiumColor = premium;

  /// @deprecated Use success instead
  static const Color successGreen = success;

  /// @deprecated Use warning instead
  static const Color warningAmber = warning;

  /// @deprecated Use premium instead
  static const Color premiumGold = premium;

  /// @deprecated Use error instead
  static const Color semanticError = error;
}
