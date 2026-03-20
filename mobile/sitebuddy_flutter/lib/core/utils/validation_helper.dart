

/// CLASS: ValidationHelper
/// PURPOSE: Standardized validation logic for structural inputs.
class ValidationHelper {
  /// Validates if a value is positive and non-zero.
  static String? validatePositive(String? value, String label) {
    if (value == null || value.isEmpty) {
      return '$label is required';
    }
    final numValue = double.tryParse(value);
    if (numValue == null) {
      return 'Enter a valid number for $label';
    }
    if (numValue <= 0) {
      return '$label must be greater than zero';
    }
    return null;
  }

  /// Validates percentage (0-100).
  static String? validatePercentage(String? value, String label) {
    final basicError = validatePositive(value, label);
    if (basicError != null) return basicError;

    final numValue = double.parse(value!);
    if (numValue > 100) {
      return '$label cannot exceed 100%';
    }
    return null;
  }
}



