/// ENUM: ConversionType
enum ConversionType {
  length,
  area,
  volume
}

/// CLASS: UnitConverterInput
class UnitConverterInput {
  final double value;
  final String fromUnit;
  final String toUnit;
  final ConversionType type;

  const UnitConverterInput({
    required this.value,
    required this.fromUnit,
    required this.toUnit,
    required this.type,
  });
}
