/// FILE HEADER
/// ----------------------------------------------
/// File: ui_radius.dart
/// Feature: core (design system)
/// Layer: constants
///
/// PURPOSE:
/// Strict definition of corner radius values for cards, buttons, and inputs.
/// ----------------------------------------------
library;


import 'package:flutter/material.dart';

/// CLASS: UiRadius
/// Enforces consistent border radii across the application.
class UiRadius {
  const UiRadius._();

  static const double small = 4.0;
  static const double medium = 8.0;
  static const double large = 12.0;
  static const double extraLarge = 16.0;

  // Specific Use Cases
  static const double card = 8.0;
  static const double button = 8.0;
  static const double input = 8.0;

  static BorderRadius get mediumBorder => BorderRadius.circular(medium);
  static BorderRadius get cardBorder => BorderRadius.circular(card);
}



