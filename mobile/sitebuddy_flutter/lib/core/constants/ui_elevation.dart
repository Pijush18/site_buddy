/// FILE HEADER
/// ----------------------------------------------
/// File: ui_elevation.dart
/// Feature: core (design system)
/// Layer: constants
///
/// PURPOSE:
/// Strict definition of shadow depth and elevation values.
/// ----------------------------------------------
library;

import 'package:flutter/material.dart';

/// CLASS: AppElevation
/// Strictly defined elevation values for the application
class AppElevation {
  static const double level0 = 0;
  static const double level1 = 2;
  static const double level2 = 6;
}

/// CLASS: UiElevation
/// Provides professional, consistent shadow projections avoiding raw Material elevation artifacts.
class UiElevation {
  const UiElevation._();

  /// Standard shadow for cards and list items
  static List<BoxShadow> get card {
    return [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.08),
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ];
  }

  /// Floating Action Button or highlighted priority elements
  static List<BoxShadow> get floating {
    return [
      BoxShadow(
        color: const Color(0xFF2563EB).withValues(alpha: 0.1),
        blurRadius: 12,
        offset: const Offset(0, 6),
      ),
    ];
  }
}
