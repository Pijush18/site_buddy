import 'package:flutter/material.dart';

/// CLASS: SbSpacing
/// PURPOSE: Standardized spacing scale for SiteBuddy.
///
/// Scale:
/// - low    -> 8 px
/// - medium -> 16 px (Default choice)
/// - high   -> 24 px
class SbSpacing {
  SbSpacing._();

  /// 8 px — Compact spacing.
  static const double low = 8.0;

  /// 16 px — Standard spacing. Default choice for most widgets.
  static const double medium = 16.0;

  /// 24 px — Loose spacing.
  static const double high = 24.0;

  // Convenience EdgeInsets
  static const EdgeInsets paddingLow = EdgeInsets.all(low);
  static const EdgeInsets paddingMedium = EdgeInsets.all(medium);
  static const EdgeInsets paddingHigh = EdgeInsets.all(high);

  static const EdgeInsets horizontalLow = EdgeInsets.symmetric(horizontal: low);
  static const EdgeInsets horizontalMedium = EdgeInsets.symmetric(horizontal: medium);
  static const EdgeInsets horizontalHigh = EdgeInsets.symmetric(horizontal: high);

  static const EdgeInsets verticalLow = EdgeInsets.symmetric(vertical: low);
  static const EdgeInsets verticalMedium = EdgeInsets.symmetric(vertical: medium);
  static const EdgeInsets verticalHigh = EdgeInsets.symmetric(vertical: high);
}
