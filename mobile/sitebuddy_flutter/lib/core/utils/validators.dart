/// FILE HEADER
/// ----------------------------------------------
/// File: validators.dart
/// Feature: core
/// Layer: utils
///
/// PURPOSE:
/// Centralized repository of data validation logic used primarily by controllers.
///
/// RESPONSIBILITIES:
/// - Ensuring required text is present.
/// - Verifying strings define valid, positive numbers.
/// - Returning clear AppFailure errors if the validation fails.
///
/// DEPENDENCIES:
/// - AppFailure model
///
/// FUTURE IMPROVEMENTS:
/// - Add bounds checking (min/max).
/// - Add Regex-based validators for complex inputs.
/// ----------------------------------------------
library;


import 'package:site_buddy/core/errors/app_failure.dart';

/// CLASS: Validators
/// PURPOSE: A static utility class to validate form inputs computationally.
/// WHY: Prevents scattered `if(val.isEmpty)` checks in every single Controller or UseCase.
class Validators {
  Validators._(); // Prevent instantiation

  /// METHOD: requiredString
  /// PURPOSE: Ensures a string is not completely empty or null.
  /// PARAMETERS: value: the string to check, fieldName: the human name of the field.
  /// RETURNS: An AppFailure if empty, otherwise null.
  /// LOGIC: Trims the string to avoid whitespace-only passes.
  static AppFailure? requiredString(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return AppFailure('$fieldName is required.');
    }
    return null;
  }

  /// METHOD: parsePositiveNumber
  /// PURPOSE: Verifies a string can be parsed as a double and is strictly > 0.
  /// PARAMETERS: value: the string input, fieldName: the human name of the field.
  /// RETURNS: A Map with either the parsed `double` or an `AppFailure`.
  /// LOGIC: Uses double.tryParse and basic inequality.
  static ({double? value, AppFailure? failure}) parsePositiveNumber(
    String? value,
    String fieldName,
  ) {
    final requiredCheck = requiredString(value, fieldName);
    if (requiredCheck != null) {
      return (value: null, failure: requiredCheck);
    }

    final parsed = double.tryParse(value!.trim());
    if (parsed == null) {
      return (
        value: null,
        failure: AppFailure('$fieldName must be a valid number.'),
      );
    }

    if (parsed <= 0) {
      return (
        value: null,
        failure: AppFailure('$fieldName must be strictly positive.'),
      );
    }

    return (value: parsed, failure: null);
  }
}



