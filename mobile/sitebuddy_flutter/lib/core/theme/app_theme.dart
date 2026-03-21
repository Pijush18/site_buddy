import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:site_buddy/core/design_system/sb_typography.dart';
import 'package:site_buddy/core/design_system/sb_colors.dart';

/// CLASS: AppTheme
/// PURPOSE: Centralized theme definitions for Site Buddy.
/// REFACTOR: Professional Color System (Surface/Background inversion).
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme => _createTheme(Brightness.light);
  static ThemeData get darkTheme => _createTheme(Brightness.dark);

  static ThemeData _createTheme(Brightness brightness) {
    final bool isLight = brightness == Brightness.light;

    final colorScheme = ColorScheme.fromSeed(
      seedColor: SbColors.primarySeed,
      brightness: brightness,
      // 🎨 Hierarchy Overrides
      surface: isLight ? SbColors.lightSurface : SbColors.darkSurface,
      surfaceContainer: isLight ? SbColors.lightContainer : SbColors.darkContainer,
      surfaceContainerHigh: isLight ? SbColors.lightContainerHigh : SbColors.darkContainerHigh,
      outline: isLight ? const Color(0xFF94A3B8) : const Color(0xFF475569), // 🔳 Structured Borders
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
          borderRadius: BorderRadius.circular(8), // Global Standard Radius
          side: BorderSide(

            color: colorScheme.outline,
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


      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          minimumSize: const Size(0, 48),
          elevation: 2,
          shadowColor: colorScheme.primary.withValues(alpha: 0.3),
          padding: const EdgeInsets.symmetric(horizontal: 16.0), // SbSpacing.lg
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),

          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.onSurface,
          minimumSize: const Size(0, 44),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          side: BorderSide(color: colorScheme.outline),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.onSurface,
          minimumSize: const Size(0, 44),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),


    );
  }
}
