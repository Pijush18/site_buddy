// lib/core/theme/app_spacing.dart
//
// Global spacing scale for SiteBuddy.
//
// ┌─────────────────────────────────────────────────────────────────────────┐
// │  DESIGN SYSTEM NOTE                                                      │
// │  All padding, margin, and gap values across the app should trace back   │
// │  to one of these named steps rather than using raw numbers.             │
// │  This makes the layout provably consistent and easy to adjust globally. │
// └─────────────────────────────────────────────────────────────────────────┘
//
// Relationship to lib/core/ui/app_spacing.dart:
//   • lib/core/ui/app_spacing.dart — layout constants (screenPadding, sectionGap…)
//   • lib/core/theme/app_spacing.dart (THIS FILE) — semantic scale (xs…xl)
//   Both can be imported side-by-side; they serve different purposes.
//
// Usage examples:
//   Padding(padding: EdgeInsets.all(AppLayout.md))
//   SizedBox(height: AppLayout.lg)
//   EdgeInsets.symmetric(horizontal: AppLayout.sm, vertical: AppLayout.xs)
//   Gap(AppLayout.xl)   // if using the 'gap' package

import 'package:flutter/material.dart';

/// Semantic spacing scale.
///
/// Use these constants everywhere a raw pixel value would appear for
/// padding, margin, or gap — never write a bare number like `16.0` directly.
///
/// Scale:
/// ```
/// xs  →  4 px   — tight in-row gaps, icon-label spacing
/// sm  →  8 px   — compact list item padding
/// md  → 16 px   — standard card / widget padding   ← default choice
/// lg  → 24 px   — section separation within a screen
/// xl  → 32 px   — between major page sections
/// ```
class AppLayout {
  AppLayout._(); // prevent instantiation

  // ── Scale steps ────────────────────────────────────────────────────────────

  /// 4 px — tight spacing between closely related elements.
  ///
  /// Example: gap between an icon and its adjacent label.
  /// ```dart
  /// SizedBox(width: AppLayout.xs)
  /// ```
  static const double xs = 4;

  /// 8 px — compact spacing for lists, chips, and small components.
  ///
  /// Example: inner padding on a dense list tile.
  /// ```dart
  /// EdgeInsets.all(AppLayout.sm)
  /// ```
  static const double sm = 8;

  /// 16 px — standard component padding. **Default choice** for most widgets.
  ///
  /// Example: card content padding, form field vertical gap.
  /// ```dart
  /// EdgeInsets.all(AppLayout.md)
  /// EdgeInsets.symmetric(horizontal: AppLayout.md)
  /// ```
  static const double md = 16;

  /// 24 px — section-level separation within a screen.
  ///
  /// Example: gap between two `AppCard` groups on a calculator screen.
  /// ```dart
  /// SizedBox(height: AppLayout.lg)
  /// ```
  static const double lg = 24;

  /// 32 px — major layout separation between top-level page sections.
  ///
  /// Example: vertical gap between the header banner and the first form row.
  /// ```dart
  /// SizedBox(height: AppLayout.xl)
  /// EdgeInsets.symmetric(vertical: AppLayout.xl)
  /// ```
  static const double xl = 32;

  // ── Convenience EdgeInsets factories ──────────────────────────────────────
  // Pre-built [EdgeInsets] objects for the most common use-cases.
  // Import this class and call e.g. AppLayout.paddingMedium instead of
  // writing EdgeInsets.all(AppLayout.md) each time.

  /// `EdgeInsets.all(xs)` — 4 px on every side.
  static const EdgeInsets paddingXs = EdgeInsets.all(xs);

  /// `EdgeInsets.all(sm)` — 8 px on every side.
  static const EdgeInsets paddingSm = EdgeInsets.all(sm);

  /// `EdgeInsets.all(md)` — 16 px on every side. *(most common)*
  static const EdgeInsets paddingMd = EdgeInsets.all(md);

  /// `EdgeInsets.all(lg)` — 24 px on every side.
  static const EdgeInsets paddingLg = EdgeInsets.all(lg);

  /// `EdgeInsets.all(xl)` — 32 px on every side.
  static const EdgeInsets paddingXl = EdgeInsets.all(xl);

  /// Horizontal-only padding: 16 px left + right.
  static const EdgeInsets horizontalMd = EdgeInsets.symmetric(horizontal: md);

  /// Vertical-only padding: 16 px top + bottom.
  static const EdgeInsets verticalMd = EdgeInsets.symmetric(vertical: md);

  /// Horizontal screen padding: 20 px left + right.
  /// Mirrors the `AppLayout.screenPadding` value from lib/core/ui/app_spacing.dart
  /// so callers can use one import for both concerns.
  static const EdgeInsets screenHorizontal = EdgeInsets.symmetric(
    horizontal: 20,
  );
}
