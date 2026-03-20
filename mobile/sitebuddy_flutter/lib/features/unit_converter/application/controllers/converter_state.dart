/// FILE HEADER
/// ----------------------------------------------
/// File: converter_state.dart
/// Feature: unit_converter
/// Layer: application/controllers
///
/// PURPOSE:
/// Immutable state definition for the AI Smart Converter UI.
///
/// RESPONSIBILITIES:
/// - Holds current AI input string and parsed `AiQuery`.
/// - Holds manual mode structural inputs (Type, Value, From, To).
/// - Holds resulting output (`ConversionResult` or Concrete stats).
///
/// DEPENDENCIES:
/// - `UnitType`
/// - `UnitDefinition`
///
/// FUTURE IMPROVEMENTS:
/// - Save last selected units to local storage.
/// ----------------------------------------------
library;


import 'package:site_buddy/shared/domain/models/ai_query.dart';
import 'package:site_buddy/features/unit_converter/domain/entities/unit_definition.dart';
import 'package:site_buddy/features/unit_converter/domain/enums/unit_type.dart';
import 'package:site_buddy/shared/domain/models/conversion_result.dart';
import 'package:site_buddy/shared/domain/models/material_result.dart';

/// CLASS: ConverterState
/// PURPOSE: View state for the converter module strictly following Riverpod conventions.
class ConverterState {
  // AI specific
  final String input;
  final AiQuery? parsedQuery;

  // Manual specific
  final double? manualValue;
  final UnitType selectedType;
  final UnitDefinition? fromUnit;
  final UnitDefinition? toUnit;

  // Conversion specific
  final ConversionResult? conversionResult;

  // Concrete specific
  final MaterialResult? concreteResult;

  final String? error;

  const ConverterState({
    this.input = '',
    this.parsedQuery,
    this.manualValue,
    this.selectedType = UnitType.length,
    this.fromUnit,
    this.toUnit,
    this.conversionResult,
    this.concreteResult,
    this.error,
  });

  ConverterState copyWith({
    String? input,
    AiQuery? parsedQuery,
    double? manualValue,
    UnitType? selectedType,
    UnitDefinition? fromUnit,
    UnitDefinition? toUnit,
    ConversionResult? conversionResult,
    MaterialResult? concreteResult,
    String? error,
    bool clearErrors = false,
    bool clearResults = false,
    bool clearManualValue = false,
  }) {
    return ConverterState(
      input: input ?? this.input,
      parsedQuery: parsedQuery ?? this.parsedQuery,
      manualValue: clearManualValue ? null : (manualValue ?? this.manualValue),
      selectedType: selectedType ?? this.selectedType,
      fromUnit: fromUnit ?? this.fromUnit,
      toUnit: toUnit ?? this.toUnit,
      conversionResult: clearResults
          ? null
          : (conversionResult ?? this.conversionResult),
      concreteResult: clearResults
          ? null
          : (concreteResult ?? this.concreteResult),
      error: clearErrors ? null : (error ?? this.error),
    );
  }
}



