/// FILE HEADER
/// ----------------------------------------------
/// File: ui_duration.dart
/// Feature: core (design system)
/// Layer: constants
///
/// PURPOSE:
/// Strict definition of animation timing bounds.
/// ----------------------------------------------
library;


/// CLASS: UiDuration
/// Enforces standard delays and animation timelines.
class UiDuration {
  const UiDuration._();

  static const Duration fast = Duration(milliseconds: 150);
  static const Duration medium = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
}
