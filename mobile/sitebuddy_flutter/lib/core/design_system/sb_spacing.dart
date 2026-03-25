// ignore_for_file: constant_identifier_names
/// CLASS: SbSpacing
/// PURPOSE: Spacing system for SiteBuddy.
<<<<<<< HEAD
/// DESIGN SCALE: 4, 8, 12, 16, 24, 32, 48
class SbSpacing {
  SbSpacing._();

  static const double xs = 4;    // Extra Small - tight gaps
  static const double sm = 8;    // Small - icon gaps, inline spacing
  static const double md = 12;   // Medium - internal component spacing
  static const double lg = 16;   // Large - page padding, card padding
  static const double xl = 24;   // Extra Large - section gaps
  static const double xxl = 32;  // 2x Large - page-level spacing
  static const double xxxl = 48; // 3x Large - major section separation
=======
/// DESIGN SCALE: 4, 8, 12, 16, 24, 32 
/// 
/// USAGE RULES:
/// - xs (4px):   Tight spacing within components (icon gaps)
/// - sm (8px):   Internal component spacing (card content)
/// - md (12px):  Grid item spacing (between grid items)
/// - lg (16px):  Screen edge padding, section list separators
/// - xl (24px):  Section gaps (between major sections)
/// - xxl (24px): Reserved for larger section separations
class SbSpacing {
  SbSpacing._();

  static const double xs = 4;   // Extra Small - icon gaps, tight spacing
  static const double sm = 8;    // Small - internal card content spacing
  static const double md = 12;   // Medium - grid item spacing
  static const double lg = 16;   // Large - screen edge padding, section separators
  static const double xl = 24;   // Extra Large - section gaps (24px)
  static const double xxl = 24; // Reserved for larger separations (24px)
>>>>>>> 64d70f8 (fix(navigation): resolve Home opening Project tab due to ShellRoute index mismatch)
}
