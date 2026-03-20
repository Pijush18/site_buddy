import 'package:flutter/material.dart';

/// CLASS: AppAnimation
/// PURPOSE: Centralized animation durations for the Design System.
/// Goal: Consistent motion feel across the entire application.
class AppAnimation {
  AppAnimation._();

  /// Short duration for hover effects or small transitions.
  static const Duration short = Duration(milliseconds: 200);

  /// Standard duration for page transitions or opening panels.
  static const Duration medium = Duration(milliseconds: 450);

  /// Long duration for complex animations or staging effects.
  static const Duration long = Duration(milliseconds: 800);

  /// Curve for all SiteBuddy animations.
  static const Curve curve = Curves.easeInOutCubic;
}



