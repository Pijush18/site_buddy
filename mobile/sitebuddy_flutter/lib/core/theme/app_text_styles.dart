import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// CLASS: AppTextStyles
/// PURPOSE: Centralized strict typography system for App.
/// DESIGN: Uses Google Fonts (Inter) with controlled weights (w400/w600) and line heights for a compact UI.
class AppTextStyles {
  // ── BASE STYLES (PUBLIC) ──
  
  static final TextStyle screenTitleBase = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  static final TextStyle sectionTitleBase = GoogleFonts.inter(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    height: 1.25,
    letterSpacing: 0.1,
  );

  static final TextStyle cardTitleBase = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.25,
    letterSpacing: 0.2,
  );

  static final TextStyle bodyBase = GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.35,
  );

  static final TextStyle captionBase = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.3,
  );

  // ── CONTEXT-AWARE STYLES (PUBLIC) ──

  static TextStyle screenTitle(BuildContext context) => screenTitleBase.copyWith(
    color: Theme.of(context).colorScheme.onSurface,
  );

  static TextStyle sectionTitle(BuildContext context) => sectionTitleBase.copyWith(
    color: Theme.of(context).colorScheme.onSurface,
  );

  static TextStyle cardTitle(BuildContext context) => cardTitleBase.copyWith(
    color: Theme.of(context).colorScheme.onSurface,
  );

  static TextStyle body(BuildContext context, {bool secondary = false}) => bodyBase.copyWith(
    color: secondary 
        ? Theme.of(context).colorScheme.onSurfaceVariant 
        : Theme.of(context).colorScheme.onSurface,
  );

  static TextStyle caption(BuildContext context) => captionBase.copyWith(
    color: Theme.of(context).colorScheme.onSurfaceVariant,
  );
}
