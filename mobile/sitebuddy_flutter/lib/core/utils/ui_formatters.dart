
/// A centralized utility class for formatting raw domain values for the UI.
/// This prevents the Domain layer from dictating presentation logic.
class UiFormatters {
  /// Formats a number to a specific decimal place.
  /// If [value] is null, returns a specified [fallback].
  static String decimal(
    num? value, {
    int fractionDigits = 2,
    String fallback = '-',
  }) {
    if (value == null) return fallback;
    return value.toStringAsFixed(fractionDigits);
  }

  /// Pads a number with leading zeros (e.g., for chainages: 050)
  static String padZero(num value, {int length = 3}) {
    return value.toStringAsFixed(0).padLeft(length, '0');
  }

  /// Formats a chainage (e.g., 2550 -> 2+550)
  static String chainage(double value) {
    int km = (value / 1000).truncate();
    double m = value % 1000;
    String mStr = padZero(m, length: 3);
    return '$km+$mStr';
  }

  /// Formats a gradient ratio (e.g., 200 -> 1:200.00)
  static String ratio(num denominator, {int fractionDigits = 2}) {
    return '1:${decimal(denominator, fractionDigits: fractionDigits)}';
  }

  /// Formats a percentage (e.g. 5.5 -> 5.50%)
  static String percentage(num value, {int fractionDigits = 2}) {
    return '${decimal(value, fractionDigits: fractionDigits)} %';
  }

  /// Appends a generic unit string to a value
  static String withUnit(
    num? value,
    String unit, {
    int fractionDigits = 2,
    String fallback = '-',
  }) {
    if (value == null) return fallback;
    return '${decimal(value, fractionDigits: fractionDigits)} $unit';
  }
}



