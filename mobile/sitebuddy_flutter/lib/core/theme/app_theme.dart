import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:site_buddy/core/design_system/sb_typography.dart';

/// CLASS: AppTheme
/// PURPOSE: Centralized theme definitions for Site Buddy.
/// REFACTOR: Professional Color System (Surface/Background inversion).
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme => _createTheme(Brightness.light);
  static ThemeData get darkTheme => _createTheme(Brightness.dark);

  static ThemeData _createTheme(Brightness brightness) {
    // 🧱 Base Color Definition
    const primarySeed = Color(0xFF1E3A8A); // Slate 800-900 base

    final colorScheme = ColorScheme.fromSeed(
      seedColor: primarySeed,
      brightness: brightness,
      // 🎨 Hierarchy Overrides
      surface: brightness == Brightness.light ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A),
      surfaceContainer: brightness == Brightness.light ? const Color(0xFFFFFFFF) : const Color(0xFF1E293B),
      surfaceContainerHigh: brightness == Brightness.light ? const Color(0xFFF1F5F9) : const Color(0xFF334155),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      textTheme: GoogleFonts.interTextTheme(SbTypography.textTheme),

      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
      ),

      // 🔳 Global Card Architecture
      cardTheme: CardThemeData(
        color: colorScheme.surfaceContainerHigh,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // Standardized SbRadius.medium
          side: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.1),
            width: 1.0,
          ),
        ),
      ),

      // 🧭 Navigation Hierarchy
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHigh.withValues(alpha: 0.5),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}



