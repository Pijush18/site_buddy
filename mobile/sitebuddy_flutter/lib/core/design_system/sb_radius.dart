import 'package:flutter/material.dart';

/// CLASS: SbRadius
/// PURPOSE: Standardized border radius scale for SiteBuddy.
///
/// Scale:
/// - small  -> 8 px
/// - medium -> 16 px
class SbRadius {
  SbRadius._();

  /// 8 px — Small border radius.
  static const double small = 8.0;

  /// 12 px — Medium-small/Medium border radius (Inputs, Dropdowns).
  static const double md = 12.0;

  /// 16 px — Medium border radius (Cards).
  static const double medium = 16.0;

  static final BorderRadius borderSmall = BorderRadius.circular(small);
  static final BorderRadius borderMd = BorderRadius.circular(md);
  static final BorderRadius borderMedium = BorderRadius.circular(medium);
}



