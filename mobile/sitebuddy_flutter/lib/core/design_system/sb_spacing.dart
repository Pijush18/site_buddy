import 'package:flutter/material.dart';

/// CLASS: SbSpacing
/// PURPOSE: Production-grade spacing system for SiteBuddy.
/// REFINEMENT: Shifting to a more generous architectural scale for premium rhythm.
class SbSpacing {
  SbSpacing._();

  // =========================
  // 🔹 Base Scale (4pt system)
  // =========================

  static const double xxs = 2; 
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;
  static const double huge = 40;

  // =========================
  // 🔹 Semantic Spacing
  // =========================

  /// Default horizontal padding for screens
  static const double screenPadding = lg; // 16

  /// Gap between major sections: Increased to XXXL (32) for premium breathing room
  static const double sectionGap = xxxl; // 32

  /// Gap between components (cards, fields)
  static const double componentGap = lg; // 16

  /// Gap between tightly related elements
  static const double itemGap = sm; // 8

  // =========================
  // 🔹 EdgeInsets Helpers
  // =========================

  static const EdgeInsets screenHorizontal = EdgeInsets.symmetric(
    horizontal: screenPadding,
  );

  static const EdgeInsets paddingXS = EdgeInsets.all(xs);
  static const EdgeInsets paddingSM = EdgeInsets.all(sm);
  static const EdgeInsets paddingMD = EdgeInsets.all(md);
  static const EdgeInsets paddingLG = EdgeInsets.all(lg);
  static const EdgeInsets paddingXL = EdgeInsets.all(xl);

  static const EdgeInsets horizontalSM = EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets horizontalLG = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets verticalSM = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets verticalLG = EdgeInsets.symmetric(vertical: lg);
}
