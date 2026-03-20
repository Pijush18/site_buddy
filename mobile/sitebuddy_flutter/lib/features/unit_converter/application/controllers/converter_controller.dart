/// FILE HEADER
/// ----------------------------------------------
/// File: converter_controller.dart
/// Feature: unit_converter
/// Layer: application/controllers
///
/// PURPOSE:
/// Orchestrates NLP parsing and dispatches to the correct calculation logic, handling Dual Mode bridging.
///
/// RESPONSIBILITIES:
/// - Takes raw user strings from the smart input.
/// - Handles Manual Mode inputs entirely decoupled from AI latency.
/// - Executes `ConvertUnitUseCase` or `CalculateMaterialUseCase`.
/// - Fallback auto-switching from AI to Manual when AI fails.
///
/// DEPENDENCIES:
/// - Riverpod for NotifierProvider
/// - `EngineeringUnits`
/// - `ParseAiQueryUseCase`
/// - `ConvertUnitUseCase`
/// - `CalculateMaterialUseCase`
///
/// FUTURE IMPROVEMENTS:
/// - Cache previous NLP results.
/// ----------------------------------------------
library;


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/features/unit_converter/domain/entities/unit_definition.dart';
import 'package:site_buddy/core/errors/error_handler.dart';
import 'package:site_buddy/features/unit_converter/domain/entities/engineering_units.dart';
import 'package:site_buddy/features/unit_converter/domain/enums/unit_type.dart';
import 'package:site_buddy/features/unit_converter/application/controllers/converter_state.dart';
import 'package:site_buddy/features/unit_converter/application/controllers/converter_mode_provider.dart';
import 'package:site_buddy/features/unit_converter/application/providers/unit_usecase_providers.dart';
import 'package:site_buddy/features/calculator/application/providers/calculator_usecase_providers.dart';
import 'package:site_buddy/features/unit_converter/application/usecases/convert_unit_usecase.dart';
import 'package:site_buddy/features/unit_converter/application/usecases/parse_ai_query_usecase.dart';
import 'package:site_buddy/features/calculator/domain/usecases/calculate_material_usecase.dart';

/// Provider exposing the Smart Converter logic to the presentation layer.
final converterControllerProvider =
    NotifierProvider<ConverterController, ConverterState>(
      ConverterController.new,
    );

/// CLASS: ConverterController
/// PURPOSE: Binds the Smart Input Bar to pure functional calculation UseCases.
class ConverterController extends Notifier<ConverterState> {
  late final ParseAiQueryUseCase _parseUseCase;
  late final ConvertUnitUseCase _convertUseCase;
  late final CalculateMaterialUseCase _calculateMaterialUseCase;

  @override
  ConverterState build() {
    // Inject use cases via providers
    _parseUseCase = ref.watch(parseAiQueryUseCaseProvider);
    _convertUseCase = ref.watch(convertUnitUseCaseProvider);
    _calculateMaterialUseCase = ref.watch(calculateMaterialUseCaseProvider);

    // Set default initial units for Length so the dropdown isn't totally blank.
    final defaultUnits = EngineeringUnits.getUnitsForType(UnitType.length);
    return ConverterState(
      fromUnit: defaultUnits.first,
      toUnit: defaultUnits.length > 1 ? defaultUnits[1] : defaultUnits.first,
    );
  }

  // ==========================================
  // MANUAL CONTROLS
  // ==========================================

  /// METHOD: updateManualType
  /// PARAMETERS: [type] new UnitType category.
  /// RETURNS: void
  /// LOGIC: Selects the new type and pre-populates default from/to limits safely. Resets computation.
  void updateManualType(UnitType type) {
    final pool = EngineeringUnits.getUnitsForType(type);
    if (pool.isEmpty) return;

    state = state.copyWith(
      selectedType: type,
      fromUnit: pool.first,
      toUnit: pool.length > 1 ? pool[1] : pool.first,
      clearResults: true,
      clearErrors: true,
      clearManualValue: true, // reset input when type swaps
    );
  }

  void updateManualValue(BuildContext context, String valueStr) {
    if (valueStr.isEmpty) {
      state = state.copyWith(clearManualValue: true, clearResults: true);
      return;
    }

    final val = double.tryParse(valueStr);
    if (val != null) {
      state = state.copyWith(manualValue: val, clearErrors: true);
      processManualConversion(context);
    }
  }

  void updateFromUnit(BuildContext context, UnitDefinition? unit) {
    if (unit != null) {
      state = state.copyWith(fromUnit: unit);
      processManualConversion(context);
    }
  }

  void updateToUnit(BuildContext context, UnitDefinition? unit) {
    if (unit != null) {
      state = state.copyWith(toUnit: unit);
      processManualConversion(context);
    }
  }

  void swapUnits(BuildContext context) {
    state = state.copyWith(fromUnit: state.toUnit, toUnit: state.fromUnit);
    processManualConversion(context);
  }

  /// METHOD: processManualConversion
  /// PARAMETERS: None
  /// RETURNS: void
  /// LOGIC: Directly pushes UI state dropdown definitions into `ConvertUnitUseCase` continuously.
  void processManualConversion(BuildContext context) {
    if (state.manualValue == null ||
        state.fromUnit == null ||
        state.toUnit == null) {
      return;
    }

    try {
      final result = _convertUseCase.execute(
        value: state.manualValue!,
        fromUnit: state.fromUnit!.symbol,
        toUnit: state.toUnit!.symbol,
      );

      state = state.copyWith(
        conversionResult: result,
        clearErrors: true,
        // Manual mode never produces concrete results
        concreteResult: null,
      );
    } catch (e) {
      final appError = AppErrorHandler.handle(context, e);
      state = state.copyWith(error: appError.message);
    }
  }

  /// METHOD: updateInput
  /// PURPOSE: Keeps the state's raw input string in sync as the user types.
  void updateInput(String value) {
    state = state.copyWith(input: value, clearErrors: true);
  }

  /// METHOD: processInput
  /// PURPOSE: Extracts meaning from the natural language query and computes results synchronously.
  /// RETURNS: void
  /// LOGIC:
  /// - Parses the string using Regex templates.
  /// - Tests if valid. If fails, sets `mode = AiMode.manual` and applies error to trigger fallback UI.
  /// - Based on `intent`, triggers conversion engine or concrete engine.
  Future<void> processInput(BuildContext context) async {
    final query = state.input.trim();
    if (query.isEmpty) return;

    try {
      final parsed = _parseUseCase.execute(query);

      // Auto Fallback Logic (Atomic Update)
      if (!parsed.isValid) {
        state = state.copyWith(
          parsedQuery: parsed,
          error: parsed.errorMessage ?? "I couldn't calculate that.",
          clearResults: true,
        );
        // Safely trigger mode switch externally
        ref.read(converterModeProvider.notifier).setMode(ConverterMode.manual);
        return;
      }

      if (parsed.intent == 'conversion') {
        if (parsed.value == null ||
            parsed.fromUnit == null ||
            parsed.toUnit == null) {
          throw Exception(
            'Could not securely determine conversion parameters. Try: "10 ft to m"',
          );
        }

        final result = _convertUseCase.execute(
          value: parsed.value!,
          fromUnit: parsed.fromUnit!,
          toUnit: parsed.toUnit!,
        );

        state = state.copyWith(
          parsedQuery: parsed,
          conversionResult: result,
          clearErrors: true,
          concreteResult: null,
        );
      } else if (parsed.intent == 'concrete') {
        if (!parsed.hasValidDimensions) {
          throw Exception(
            'Incomplete concrete dimensions. Try: "10x5x0.2 slab m20"',
          );
        }

        final result = _calculateMaterialUseCase.execute(
          length: parsed.length!,
          width: parsed.width!,
          depth: parsed.depth!,
          grade: parsed.grade!,
        );

        state = state.copyWith(
          parsedQuery: parsed,
          concreteResult: result,
          clearErrors: true,
          conversionResult: null,
        );
      } else {
        throw Exception(
          'I couldn\'t understand that. Try "15 kg to lbs" or "5x5x0.15 m20"',
        );
      }
    } catch (e) {
      final appError = AppErrorHandler.handle(
        context,
        e,
        onRetry: () => processInput(context),
      );
      state = state.copyWith(error: appError.message);
    }
  }
}



