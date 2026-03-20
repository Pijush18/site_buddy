/// FILE HEADER
/// ----------------------------------------------
/// File: calculate_rebar_usecase.dart
/// Feature: calculator
/// Layer: domain/usecases
///
/// PURPOSE:
/// Performs rebar length and weight calculations based on input parameters.
///
/// RESPONSIBILITIES:
/// - Validate spacing and diameter > 0
/// - Compute number of bars, total length, gross and final weight
/// - Apply waste factor
/// - Return [RebarResult]
///
/// NOTE:
/// Uses dart:math for floor; no Flutter imports.
/// ----------------------------------------------
library;


import 'package:site_buddy/features/calculator/domain/entities/rebar_result.dart';

/// Use case implementing core rebar estimation formulas.
class CalculateRebarUseCase {
  const CalculateRebarUseCase();

  /// Executes estimation.
  ///
  /// Throws [ArgumentError] on invalid inputs.
  RebarResult execute({
    required double memberLength,
    required double spacing,
    required double diameter,
    required double wastePercent,
  }) {
    if (spacing <= 0) {
      throw ArgumentError('Spacing must be greater than zero.');
    }
    if (diameter <= 0) {
      throw ArgumentError('Diameter must be greater than zero.');
    }
    if (memberLength <= 0) {
      throw ArgumentError('Member length must be greater than zero.');
    }
    if (wastePercent < 0) {
      throw ArgumentError('Waste percent cannot be negative.');
    }

    // number of bars
    final bars = (memberLength / spacing).floor() + 1;
    final totalLength = bars * memberLength;

    // weight per meter = D^2 / 162
    final weightPerMeter = (diameter * diameter) / 162;
    final grossWeight = totalLength * weightPerMeter;
    final finalWeight = grossWeight * (1 + wastePercent / 100);

    return RebarResult(
      numberOfBars: bars.toDouble(),
      totalLength: totalLength,
      totalWeight: finalWeight,
    );
  }
}



