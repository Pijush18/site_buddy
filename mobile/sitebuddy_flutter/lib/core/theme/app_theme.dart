import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:site_buddy/core/theme/app_text_styles.dart';

/// CLASS: AppTheme
/// PURPOSE: Centralized theme definitions for Site Buddy.
/// REFACTOR: Professional Color System (Surface/Background inversion).
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme => _createTheme(Brightness.light);
  static ThemeData get darkTheme => _createTheme(Brightness.dark);

  static ThemeData _createTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF1E3A8A), // 🎯 Single Source of Truth: Deep Blue
      brightness: brightness,
    );

    final baseTheme = ThemeData.from(
      colorScheme: colorScheme,
      useMaterial3: true,
    );

    return baseTheme.copyWith(
      textTheme: GoogleFonts.interTextTheme(baseTheme.textTheme).copyWith(
        displayLarge: GoogleFonts.inter(fontWeight: FontWeight.bold, color: colorScheme.onSurface),
        displayMedium: GoogleFonts.inter(fontWeight: FontWeight.bold, color: colorScheme.onSurface),
        displaySmall: GoogleFonts.inter(fontWeight: FontWeight.bold, color: colorScheme.onSurface),
        headlineLarge: GoogleFonts.inter(fontWeight: FontWeight.bold, color: colorScheme.onSurface),
        headlineMedium: GoogleFonts.inter(fontWeight: FontWeight.w600, color: colorScheme.onSurface),
        headlineSmall: GoogleFonts.inter(fontWeight: FontWeight.w600, color: colorScheme.onSurface),
        titleLarge: GoogleFonts.inter(fontWeight: FontWeight.w600, color: colorScheme.onSurface),
        titleMedium: GoogleFonts.inter(fontWeight: FontWeight.w500, color: colorScheme.onSurface),
        titleSmall: GoogleFonts.inter(fontWeight: FontWeight.w500, color: colorScheme.onSurface),
        bodyLarge: GoogleFonts.inter(fontWeight: FontWeight.normal, color: colorScheme.onSurface),
        bodyMedium: GoogleFonts.inter(fontWeight: FontWeight.normal, color: colorScheme.onSurface),
        bodySmall: GoogleFonts.inter(fontWeight: FontWeight.normal, color: colorScheme.onSurfaceVariant),
        labelLarge: GoogleFonts.inter(fontWeight: FontWeight.w500, color: colorScheme.onSurface),
        labelMedium: GoogleFonts.inter(fontWeight: FontWeight.w500, color: colorScheme.onSurfaceVariant),
        labelSmall: GoogleFonts.robotoMono(fontWeight: FontWeight.w400, color: colorScheme.onSurfaceVariant),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 1.0, 
        shadowColor: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
        centerTitle: false,
        titleTextStyle: AppTextStyles.headlineLarge.copyWith(fontSize: 20, color: colorScheme.onSurface),
        iconTheme: IconThemeData(color: colorScheme.onSurface, size: 22),
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // 👈 Slightly unified radius
          side: BorderSide(
            color: colorScheme.primary.withValues(alpha: 0.08), // 👈 Even subtler tint
            width: 1.0,
          ),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        elevation: 12, // 👈 More lift for nav bar
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 11),
        unselectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 11),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceVariant.withValues(alpha: 0.3),
        contentPadding: const EdgeInsets.symmetric(horizontal: AppLayout.pMedium, vertical: AppLayout.pSmall),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppLayout.inputRadius),
          borderSide: BorderSide(color: colorScheme.outline, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppLayout.inputRadius),
          borderSide: BorderSide(color: colorScheme.outline, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppLayout.inputRadius),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
        labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
        hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: AppLayout.pMedium),
          elevation: 2, // 👈 Distinct CTA lift
          shadowColor: colorScheme.primary.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          padding: const EdgeInsets.symmetric(horizontal: AppLayout.pMedium),
          side: BorderSide(color: colorScheme.outline),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
    );
  }
}
