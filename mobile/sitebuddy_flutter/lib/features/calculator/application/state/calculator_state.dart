/// FILE HEADER
/// ----------------------------------------------
/// File: calculator_state.dart
/// Feature: calculator
/// Layer: application
///
/// PURPOSE:
/// Holds the current input state of the concrete calculator and its result.
///
/// RESPONSIBILITIES:
/// - Stores dimension lengths (Length, Width, Depth).
/// - Stores the selected concrete grade.
/// - Stores Steel Ratio % and Waste Factor % inputs.
/// - Stores both the legacy [MaterialResult] and the richer [ConcreteMaterialResult].
/// - Provides a robust copyWith method for state updates.
///
/// DEPENDENCIES:
/// - Custom ConcreteGrade enum, MaterialResult entity, ConcreteMaterialResult model.
///
/// FUTURE IMPROVEMENTS:
/// - Add per-field validation flags.
///
/// ----------------------------------------------
library;

import 'package:flutter/foundation.dart' show immutable;
import 'package:site_buddy/shared/domain/models/concrete_grade.dart';
import 'package:site_buddy/shared/domain/models/material_result.dart';
import 'package:site_buddy/core/errors/app_failure.dart';
import 'package:site_buddy/shared/domain/models/concrete_material_result.dart';

/// CLASS: CalculatorState
/// PURPOSE: Immutable state container for the Material Calculator screen.
/// WHY: Following functional reactivity, state must be immutable to safely
///      track changes over time in Riverpod.
@immutable
class CalculatorState {
  // ──────────────────────────────────────────────────────────────────────────
  // Input fields
  // ──────────────────────────────────────────────────────────────────────────

  final String lengthInput;
  final String widthInput;

  /// Depth / thickness of the concrete element in metres.
  final String depthInput;

  /// Selected concrete grade (M15 / M20 / M25 kept for legacy compatibility).
  final ConcreteGrade grade;

  /// Steel reinforcement percentage by volume (e.g. "1" for 1%).
  /// Passed as a percentage and divided by 100 before passing to the service.
  final String steelRatioInput;

  /// Percentage volumetric waste to add on top of the calculated quantity
  /// (e.g. "5" for 5 %). Applied as a multiplier before the service call.
  final String wasteFactorInput;

  // ──────────────────────────────────────────────────────────────────────────
  // Result fields
  // ──────────────────────────────────────────────────────────────────────────

  /// Legacy result, retained so that any other widget still reading
  /// [MaterialResult] does not break.
  final MaterialResult result;

  /// Full, richly-typed result from [ConcreteDesignService].
  /// Null until the first successful calculation on this screen.
  final ConcreteMaterialResult? concreteResult;

  // ──────────────────────────────────────────────────────────────────────────
  // UI state
  // ──────────────────────────────────────────────────────────────────────────

  final bool isLoading;
  final AppFailure? failure;

  // ──────────────────────────────────────────────────────────────────────────
  // Constructor
  // ──────────────────────────────────────────────────────────────────────────

  const CalculatorState({
    required this.lengthInput,
    required this.widthInput,
    required this.depthInput,
    required this.grade,
    required this.steelRatioInput,
    required this.wasteFactorInput,
    required this.result,
    required this.isLoading,
    this.concreteResult,
    this.failure,
  });

  // ──────────────────────────────────────────────────────────────────────────
  // Factory: initial
  // ──────────────────────────────────────────────────────────────────────────

  /// METHOD: initial
  /// PURPOSE: Factory constructor to create a blank, default state.
  /// LOGIC:
  ///  - Dimension inputs default to empty strings.
  ///  - Grade defaults to M20.
  ///  - Steel ratio defaults to 1 %, waste factor to 0 %.
  factory CalculatorState.initial() {
    return const CalculatorState(
      lengthInput: '',
      widthInput: '',
      depthInput: '',
      grade: ConcreteGrade.m20,
      steelRatioInput: '1',
      wasteFactorInput: '0',
      result: MaterialResult(volume: 0, dryVolume: 0, cementBags: 0),
      isLoading: false,
      concreteResult: null,
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // copyWith
  // ──────────────────────────────────────────────────────────────────────────

  /// METHOD: copyWith
  /// PURPOSE: Creates a new [CalculatorState] by merging optional overrides
  ///          into the current state.
  /// NOTES:
  ///  - [clearFailure] wipes the current failure when true.
  ///  - [clearConcreteResult] wipes the concrete result when true
  ///    (useful when the user changes an input after a successful calculation,
  ///    though the UI currently keeps the stale result visible until recalc).
  CalculatorState copyWith({
    String? lengthInput,
    String? widthInput,
    String? depthInput,
    ConcreteGrade? grade,
    String? steelRatioInput,
    String? wasteFactorInput,
    MaterialResult? result,
    ConcreteMaterialResult? concreteResult,
    bool? isLoading,
    AppFailure? failure,
    bool clearFailure = false,
    bool clearConcreteResult = false,
  }) {
    return CalculatorState(
      lengthInput: lengthInput ?? this.lengthInput,
      widthInput: widthInput ?? this.widthInput,
      depthInput: depthInput ?? this.depthInput,
      grade: grade ?? this.grade,
      steelRatioInput: steelRatioInput ?? this.steelRatioInput,
      wasteFactorInput: wasteFactorInput ?? this.wasteFactorInput,
      result: result ?? this.result,
      concreteResult: clearConcreteResult
          ? null
          : (concreteResult ?? this.concreteResult),
      isLoading: isLoading ?? this.isLoading,
      failure: clearFailure ? null : (failure ?? this.failure),
    );
  }
}



