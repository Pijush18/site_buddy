import 'package:flutter/material.dart';

/// CLASS: SbColors
/// PURPOSE: Standardized color policy for SiteBuddy UI system.
class SbColors {
  SbColors._();

  /// Primary background color based on theme.
  static Color background(BuildContext context) {
    return Theme.of(context).colorScheme.surface;
  }
  
  /// Surface color for cards and containers.
  static Color surface(BuildContext context) {
    return Theme.of(context).colorScheme.surface;
  }
}



