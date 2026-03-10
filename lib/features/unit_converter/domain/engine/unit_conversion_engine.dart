/// FILE HEADER
/// ----------------------------------------------
/// File: unit_conversion_engine.dart
/// Feature: unit_converter
/// Layer: domain/engine
///
/// PURPOSE:
/// Pure Dart logic core for mathematical unit conversions using base factors.
///
/// RESPONSIBILITIES:
/// - Converts between explicitly defined engineering units.
/// - Returns raw scalar values.
///
/// DEPENDENCIES:
/// - EngineeringUnits
/// - UnitDefinition
///
/// FUTURE IMPROVEMENTS:
/// - Expand secondary conversions logically by magnitude.
/// ----------------------------------------------
library;


import 'package:site_buddy/features/unit_converter/domain/entities/engineering_units.dart';
import 'package:site_buddy/features/unit_converter/domain/entities/unit_definition.dart';
import 'package:site_buddy/features/unit_converter/domain/enums/unit_type.dart';

/// CLASS: UnitConversionEngine
/// PURPOSE: Singleton-like abstract offering pure static functions for calculations via unit definitions.
class UnitConversionEngine {
  const UnitConversionEngine._();

  /// Converts a value from one unit definition to another using their base factors.
  /// Throws [ArgumentError] if the units are unsupported or mismatched types.
  static double convertDirect(
    double value,
    UnitDefinition from,
    UnitDefinition to,
  ) {
    if (from == to) return value;

    // Convert to base unit first
    final valueInBase = value * from.toBaseFactor;

    // Convert from base to target
    final result = valueInBase / to.toBaseFactor;

    return result;
  }

  /// Calculates intelligent secondary conversions to show contextual metrics.
  static Map<String, double> getSecondaryConversionsByName(
    double value,
    String fromName,
  ) {
    final fromDef = EngineeringUnits.parseUnit(fromName);
    if (fromDef == null) return {};

    final results = <String, double>{};

    UnitType? identifiedType;
    List<UnitDefinition> pool = [];

    // Identify the pool
    if (EngineeringUnits.lengthUnits.contains(fromDef)) {
      identifiedType = UnitType.length;
      pool = EngineeringUnits.lengthUnits;
    } else if (EngineeringUnits.areaUnits.contains(fromDef)) {
      identifiedType = UnitType.area;
      pool = EngineeringUnits.areaUnits;
    } else if (EngineeringUnits.volumeUnits.contains(fromDef)) {
      identifiedType = UnitType.volume;
      pool = EngineeringUnits.volumeUnits;
    } else if (EngineeringUnits.weightUnits.contains(fromDef)) {
      identifiedType = UnitType.weight;
      pool = EngineeringUnits.weightUnits;
    } else if (EngineeringUnits.pressureUnits.contains(fromDef)) {
      identifiedType = UnitType.pressure;
      pool = EngineeringUnits.pressureUnits;
    }

    if (identifiedType == null) return results;

    // Pick a few common targets to show for free, excluding the original.
    // For length, show mm, cm, m, ft, in smartly
    int maxSecondaries = 4;
    for (var target in pool) {
      if (target == fromDef) continue;

      // For simplicity, just convert to all others in the pool (UI will wrap).
      results[target.symbol] = convertDirect(value, fromDef, target);
      if (results.length >= maxSecondaries) break;
    }

    return results;
  }
}
