import 'package:flutter/material.dart';

/// lib/core/theme/app_radius.dart
///
/// PURPOSE:
/// Standard corner radius scale for SiteBuddy consistent styling.
///
/// SCALE:
/// - sm: 8px (standard small radius)
/// - md: 10px (medium radius - DEFAULT)
/// - lg: 16px (large radius)
///
/// REQUIREMENTS:
/// - Static constants only
/// - No dependencies
/// - Production ready
class AppRadius {
  AppRadius._();

  /// Small corner radius - 8px
  static const double sm = 8.0;

  /// Medium corner radius - 10px (DEFAULT STANDARD)
  static const double md = 10.0;

  /// Large corner radius - 16px
  static const double lg = 16.0;

  /// Constant Radius objects for convenience
  static final Radius radiusSm = const Radius.circular(sm);
  static final Radius radiusMd = const Radius.circular(md);
  static final Radius radiusLg = const Radius.circular(lg);

  /// BorderRadius objects for convenience
  static final BorderRadius borderSm = BorderRadius.circular(sm);
  static final BorderRadius borderMd = BorderRadius.circular(md);
  static final BorderRadius borderLg = BorderRadius.circular(lg);

  /// Standard radius (alias for md - the default)
  static const double standard = md;

  /// Standard BorderRadius (alias for borderMd - the default)
  static final BorderRadius borderStandard = borderMd;
}
