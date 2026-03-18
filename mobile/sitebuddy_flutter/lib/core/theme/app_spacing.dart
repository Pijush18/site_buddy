/// lib/core/theme/app_spacing.dart
///
/// PURPOSE:
/// Strict spacing scale for SiteBuddy layout consistency.
///
/// SCALE:
/// - sm: 8.0 (compact)
/// - md: 16.0 (standard)
/// - lg: 24.0 (loose)
///
/// REQUIREMENTS:
/// - Static constants only
/// - No dependencies
/// - Production ready
class AppSpacing {
  AppSpacing._();

  /// Extra small spacing (4.0px)
  static const double xs = 4.0;

  /// Small spacing (8.0px)
  static const double sm = 8.0;

  /// Medium spacing (16.0px) - STANDARD
  static const double md = 16.0;

  /// Large spacing (24.0px)
  static const double lg = 24.0;

  /// Extra large spacing (32.0px)
  static const double xl = 32.0;

  /// Double extra large spacing (48.0px) - CARD MIN
  static const double xxl = 48.0;

  /// Triple extra large spacing (64.0px)
  static const double xxxl = 64.0;
}
