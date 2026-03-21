import 'package:flutter/material.dart';

/// CLASS: SbRadius
/// PURPOSE: Standardized border radius scale for SiteBuddy.
/// UPDATED: Strict 8px Global System.
class SbRadius {
  SbRadius._();

  /// 8 px — Global standard border radius.
  static const double standard = 8.0;

  static const Radius radiusSmall = Radius.circular(standard);
  static const Radius radiusMd = Radius.circular(standard);
  static const Radius radiusMedium = Radius.circular(standard);

  static final BorderRadius borderSmall = BorderRadius.circular(standard);
  static final BorderRadius borderMd = BorderRadius.circular(standard);
  static final BorderRadius borderMedium = BorderRadius.circular(standard);
}
