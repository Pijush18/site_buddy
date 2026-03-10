/// FILE HEADER
/// ----------------------------------------------
/// File: unit_definition.dart
/// Feature: unit_converter
/// Layer: domain/entities
///
/// PURPOSE:
/// Standardized definition for a computable unit.
///
/// RESPONSIBILITIES:
/// - Declares name and symbol for a unit.
/// - Provides `toBaseFactor` which allows the `UnitConversionEngine`
///   to perform scalable unified calculations.
///
/// DEPENDENCIES:
/// - None
///
/// FUTURE IMPROVEMENTS:
/// - Add offset support (for temperature conversion like Celsius/Fahrenheit).
/// ----------------------------------------------
library;


/// CLASS: UnitDefinition
/// PURPOSE: Data strictly mapping a real-world unit to its system base.
class UnitDefinition {
  final String name;
  final String symbol;

  /// The multiplier to convert 1 of THIS unit into the TYPE's base unit.
  /// (e.g. if base is 'meter', and this is 'centimeter', factor is 0.01).
  final double toBaseFactor;

  const UnitDefinition({
    required this.name,
    required this.symbol,
    required this.toBaseFactor,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UnitDefinition &&
          runtimeType == other.runtimeType &&
          symbol == other.symbol;

  @override
  int get hashCode => symbol.hashCode;
}
