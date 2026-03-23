/// lib/core/theme/app_spacing.dart
///
/// PURPOSE:
/// Strict spacing scale for SiteBuddy. All spacing values must use
/// these constants - no arbitrary values allowed.
///
/// SCALE:
/// - xs: 4px  (tight spacing)
/// - sm: 8px  (compact spacing)
/// - md: 12px (default spacing)
/// - lg: 16px (standard spacing)
/// - xl: 20px (comfortable spacing)
/// - xxl: 24px (spacious spacing)
/// - xxxl: 32px (section spacing)
///
/// REQUIREMENTS:
/// - Static constants only
/// - No dependencies
/// - Production ready
class AppSpacing {
  AppSpacing._();

  /// Extra small - 4px (tight spacing, icon-text gap)
  static const double xs = 4.0;

  /// Small - 8px (compact internal spacing)
  static const double sm = 8.0;

  /// Medium - 12px (default component spacing)
  static const double md = 12.0;

  /// Large - 16px (standard padding/margins)
  static const double lg = 16.0;

  /// Extra large - 20px (comfortable spacing)
  static const double xl = 20.0;

  /// XXL - 24px (spacious spacing)
  static const double xxl = 24.0;

  /// XXXL - 32px (section-level spacing)
  static const double xxxl = 32.0;

  /// Standard horizontal padding for screens
  static const double screenPadding = lg;

  /// Standard vertical padding for screens
  static const double screenPaddingVertical = lg;

  /// Standard card padding
  static const double cardPadding = md;

  /// Standard button padding (horizontal)
  static const double buttonPaddingH = lg;

  /// Standard input field padding (horizontal)
  static const double inputPaddingH = sm;
}