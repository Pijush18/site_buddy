/// FILE HEADER
/// ----------------------------------------------
/// File: convert_unit_usecase.dart
/// Feature: unit_converter
/// Layer: application/usecases
///
/// PURPOSE:
/// Orchestrates the domain `UnitConversionEngine` to return a `ConversionResult`.
///
/// RESPONSIBILITIES:
/// - Takes simple strings and parses them through the core engine.
/// - Transforms strings into `UnitDefinition` bounds.
/// - Returns primary and secondary results securely.
///
/// DEPENDENCIES:
/// - `UnitConversionEngine` (domain logic)
/// - `EngineeringUnits` (domain entities)
///
/// FUTURE IMPROVEMENTS:
/// - Log conversions for analytics.
/// ----------------------------------------------
library;


import 'package:site_buddy/features/unit_converter/domain/engine/unit_conversion_engine.dart';
import 'package:site_buddy/features/unit_converter/domain/entities/engineering_units.dart';
import 'package:site_buddy/shared/domain/models/conversion_result.dart';

/// CLASS: ConvertUnitUseCase
/// PURPOSE: Execute conversion logic and build the resulting object for the State.
class ConvertUnitUseCase {
  const ConvertUnitUseCase();

  /// Executes unit conversion synchronously.
  /// Throws ArgumentError if units cannot be mapped.
  ConversionResult execute({
    required double value,
    required String fromUnit,
    required String toUnit,
  }) {
    final fromDef = EngineeringUnits.parseUnit(fromUnit);
    final toDef = EngineeringUnits.parseUnit(toUnit);

    if (fromDef == null || toDef == null) {
      throw ArgumentError(
        'Mismatched or unrecognized units: $fromUnit to $toUnit',
      );
    }

    final mainResult = UnitConversionEngine.convertDirect(
      value,
      fromDef,
      toDef,
    );
    final secondaries = UnitConversionEngine.getSecondaryConversionsByName(
      value,
      fromUnit,
    );

    // Remove the anchor "toUnit" from the secondaries so we don't display duplicates.
    secondaries.removeWhere((key, _) => key == toDef.symbol);

    return ConversionResult(
      mainValue: mainResult,
      secondaryValues: secondaries,
    );
  }
}



