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



