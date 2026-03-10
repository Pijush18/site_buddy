/// FILE HEADER
/// ----------------------------------------------
/// File: ui_dimensions.dart
/// Feature: core (design system)
/// Layer: constants
///
/// PURPOSE:
/// Strict definition of spacing, padding, and margin boundaries across the App.
///
/// RESPONSIBILITIES:
/// - Replaces ad-hoc `SizedBox` dimensions.
/// - Guarantees a consistent engineering feel.
///
/// ----------------------------------------------
library;


import 'package:flutter/material.dart';

/// CLASS: UiDimensions
/// Strict geometric tokens.
class UiDimensions {
  const UiDimensions._();

  // Screen layout limits (Global rule)
  static const double screenPaddingHorizontal = 4.0;
  static const double screenPaddingVertical = 4.0;

  // Spacing semantic aliases
  static const double spaceXs = 4.0;
  static const double spaceSm = 8.0;
  static const double spaceMd = 16.0;

  // Padding / Margins
  static const double p4 = 4.0;
  static const double p8 = 8.0;
  static const double p12 = 12.0;
  static const double p16 = 16.0;
  static const double p20 = 20.0;
  static const double p24 = 24.0;
  static const double p32 = 32.0;
  static const double p48 = 48.0;

  // Gaps (Vertical boxes)
  static const Widget gap4 = SizedBox(height: p4);
  static const Widget gap8 = SizedBox(height: p8);
  static const Widget gap12 = SizedBox(height: p12);
  static const Widget gap16 = SizedBox(height: p16);
  static const Widget gap20 = SizedBox(height: p20);
  static const Widget gap24 = SizedBox(height: p24);
  static const Widget gap32 = SizedBox(height: p32);

  // Gaps Width (Horizontal boxes)
  static const Widget gapW4 = SizedBox(width: p4);
  static const Widget gapW8 = SizedBox(width: p8);
  static const Widget gapW12 = SizedBox(width: p12);
  static const Widget gapW16 = SizedBox(width: p16);
  static const Widget gapW24 = SizedBox(width: p24);
}
