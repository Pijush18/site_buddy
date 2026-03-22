/// CLASS: UnitConverterResult
class UnitConverterResult {
  final double value;
  final String unit;

  const UnitConverterResult({
    required this.value,
    required this.unit,
  });

  Map<String, dynamic> toMap() {
    return {
      'converted_value': value,
      'unit': unit,
    };
  }
}
