
import 'package:site_buddy/core/theme/app_layout.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:site_buddy/core/theme/app_text_styles.dart';

/// CLASS: AppTheme
/// PURPOSE: Centralized theme definitions for Site Buddy.
/// DESIGN PRINCIPLES:
/// - Use ColorScheme for all semantic coloring.
/// - Ensure accessibility (AA contrast) in both themes.
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return _createTheme(Brightness.light);
  }

  static ThemeData get darkTheme {
    return _createTheme(Brightness.dark);
  }

  static ThemeData _createTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    // Define ColorScheme explicitly to ensure contrast
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF2563EB),
      brightness: brightness,
      primary: const Color(0xFF2563EB),
      onPrimary: Colors.white,
      secondary: const Color(0xFFF97316),
      onSecondary: Colors.white,
      surface: isDark ? const Color(0xFF0F172A) : Colors.white,
      onSurface: isDark ? const Color(0xFFFFFFFF) : const Color(0xFF0F172A),
      surfaceContainerHighest: isDark
          ? const Color(0xFF1E293B)
          : const Color(0xFFF8FAFC),
      onSurfaceVariant: isDark
          ? const Color(0xFF94A3B8)
          : const Color(0xFF64748B),
      outline: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
      error: const Color(0xFFEF4444),
    );

    final baseTheme = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: isDark
          ? const Color(0xFF0F172A)
          : const Color(0xFFF8F9FA), // Off-white for card shadow contrast
      canvasColor: isDark ? const Color(0xFF0F172A) : Colors.white,
      cardColor: isDark ? const Color(0xFF1E293B) : Colors.white,
      dividerColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFCBD5E1),
    );

    return baseTheme.copyWith(
      textTheme: GoogleFonts.interTextTheme(baseTheme.textTheme).copyWith(
        displayLarge: GoogleFonts.inter(
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurface,
        ),
        displayMedium: GoogleFonts.inter(
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurface,
        ),
        displaySmall: GoogleFonts.inter(
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurface,
        ),
        headlineLarge: GoogleFonts.inter(
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurface,
        ),
        headlineMedium: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
        headlineSmall: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
        titleLarge: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
        titleMedium: GoogleFonts.inter(
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurface,
        ),
        titleSmall: GoogleFonts.inter(
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurface,
        ),
        bodyLarge: GoogleFonts.inter(
          fontWeight: FontWeight.normal,
          color: colorScheme.onSurface,
        ),
        bodyMedium: GoogleFonts.inter(
          fontWeight: FontWeight.normal,
          color: colorScheme.onSurface,
        ),
        bodySmall: GoogleFonts.inter(
          fontWeight: FontWeight.normal,
          color: colorScheme.onSurfaceVariant,
        ),
        labelLarge: GoogleFonts.inter(
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurface,
        ),
        labelMedium: GoogleFonts.inter(
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurfaceVariant,
        ),
        labelSmall: GoogleFonts.robotoMono(
          fontWeight: FontWeight.w400,
          color: colorScheme.onSurfaceVariant,
        ), // Monospace for numbers
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTextStyles.headlineLarge.copyWith(
          fontSize: 20,
          color: colorScheme.onSurface,
        ),
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black.withValues(alpha: 0.12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppLayout.cardRadius), // 16.0
          side: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.grey.withValues(alpha: 0.2),
            width: 1.2,
          ),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
        selectedItemColor: const Color(0xFF2563EB),
        unselectedItemColor: isDark
            ? const Color(0xFF94A3B8)
            : const Color(0xFF64748B),
        elevation: 8,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppLayout.pMedium,
          vertical: AppLayout.pSmall,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppLayout.inputRadius),
          borderSide: BorderSide(
            color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppLayout.inputRadius),
          borderSide: BorderSide(
            color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppLayout.inputRadius),
          borderSide: BorderSide(color: colorScheme.primary, width: 2.0),
        ),
        labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
        hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: AppLayout.pMedium),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppLayout.buttonRadius),
          ),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          padding: const EdgeInsets.symmetric(horizontal: AppLayout.pMedium),
          side: BorderSide(color: colorScheme.outline),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppLayout.buttonRadius),
          ),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
