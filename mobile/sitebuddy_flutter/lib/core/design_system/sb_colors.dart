import 'package:flutter/material.dart';

/// CLASS: SbColors
/// PURPOSE: Standardized color policy for SiteBuddy UI system.
class SbColors {
  SbColors._();

  /// Primary background color based on brightness.
  /// Light mode -> White
  /// Dark mode -> Black
  static Color background(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light 
        ? Colors.white 
        : Colors.black;
  }
  
  /// Surface color for cards and containers.
  static Color surface(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light 
        ? Colors.white 
        : const Color(0xFF121212); // Slightly lighter than black for elevation
  }
}
