/// FILE HEADER
/// ----------------------------------------------
/// File: calculate_gradient_usecase.dart
/// Feature: calculator
/// Layer: domain/usecases
///
/// PURPOSE:
/// Computes slope-related metrics given vertical rise and horizontal run.
///
/// RESPONSIBILITIES:
/// - Validate inputs (run must not equal zero, values reasonable).
/// - Compute slope, percentage, angle, and classification.
///
/// NOTE:
/// - Uses dart:math for angle calculation.
/// - Pure Dart; no Flutter dependencies.
/// ----------------------------------------------
library;


import 'dart:math';

import 'package:site_buddy/features/calculator/domain/entities/gradient_result.dart';

/// Use case performing gradient calculations.
class CalculateGradientUseCase {
  const CalculateGradientUseCase();

  /// Executes the calculation, returning a [GradientResult].
  ///
  /// Throws [ArgumentError] if run is zero or inputs are NaN.
  GradientResult execute({required double rise, required double run}) {
    if (rise.isNaN || run.isNaN) {
      throw ArgumentError('Inputs must be valid numbers.');
    }
    if (run == 0) {
      throw ArgumentError('Run cannot be zero.');
    }

    final slope = rise / run;
    final percentage = slope * 100;
    final angle = atan(slope) * (180 / pi);

    // ratio: store only the denominator for formatting in UI
    final double ratioDenominator = rise == 0 ? double.infinity : run / rise;

    GradientClassification classification;
    if (percentage == 0) {
      classification = GradientClassification.flat;
    } else if (percentage > 0 && percentage <= 5) {
      classification = GradientClassification.mild;
    } else if (percentage > 5 && percentage <= 15) {
      classification = GradientClassification.moderate;
    } else {
      classification = GradientClassification.steep;
    }

    return GradientResult(
      rise: rise,
      run: run,
      slope: slope,
      percentage: percentage,
      angle: angle,
      ratio: ratioDenominator,
      classification: classification,
    );
  }
}
