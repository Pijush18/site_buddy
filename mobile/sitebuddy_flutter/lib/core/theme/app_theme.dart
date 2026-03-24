import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:site_buddy/core/design_system/sb_typography.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/theme/app_colors.dart';

/// CLASS: AppTheme
/// PURPOSE: Centralized theme definitions for Site Buddy.
/// Combines all design system values into ThemeData.
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme => _createTheme(Brightness.light);
  static ThemeData get darkTheme => _createTheme(Brightness.dark);

  static ThemeData _createTheme(Brightness brightness) {
    final bool isLight = brightness == Brightness.light;

    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primarySeed,
      brightness: brightness,
      // Surface Overrides
      surface: isLight ? AppColors.lightSurface : AppColors.darkSurface,
      surfaceContainer: isLight ? AppColors.lightContainer : AppColors.darkContainer,
      surfaceContainerHigh: isLight ? AppColors.lightContainerHigh : AppColors.darkContainerHigh,
      outline: isLight ? const Color(0xFF94A3B8) : const Color(0xFF475569),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      textTheme: GoogleFonts.interTextTheme(SbTypography.textTheme),

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
      ),

      // Cards
      cardTheme: CardThemeData(
        color: colorScheme.surfaceContainerHigh,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SbSpacing.sm),
          side: BorderSide(
            color: colorScheme.outline,
            width: 1.0,
          ),
        ),
      ),

      // Navigation
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),

      // Buttons - Primary
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          minimumSize: const Size(0, 48),
          elevation: 2,
          shadowColor: colorScheme.primary.withValues(alpha: 0.3),
          padding: const EdgeInsets.symmetric(horizontal: SbSpacing.lg),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SbSpacing.sm),
          ),
          textStyle: SbTypography.textTheme.labelLarge,
        ),
      ),

      // Buttons - Outlined
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.onSurface,
          minimumSize: const Size(0, 44),
          padding: const EdgeInsets.symmetric(horizontal: SbSpacing.lg),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SbSpacing.sm),
          ),
          side: BorderSide(color: colorScheme.outline),
          textStyle: SbTypography.textTheme.labelLarge,
        ),
      ),

      // Buttons - Text
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.onSurface,
          minimumSize: const Size(0, 44),
          padding: const EdgeInsets.symmetric(horizontal: SbSpacing.lg),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SbSpacing.sm),
          ),
          textStyle: SbTypography.textTheme.labelLarge,
        ),
      ),

      // Input Fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: SbSpacing.sm,
          vertical: SbSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SbSpacing.sm),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SbSpacing.sm),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SbSpacing.sm),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SbSpacing.sm),
          borderSide: BorderSide(color: colorScheme.error),
        ),
      ),

      // Divider
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
        space: SbSpacing.md,
      ),
    );
  }
}
