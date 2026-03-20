/// FILE HEADER
/// ----------------------------------------------
/// File: calculate_cement_usecase.dart
/// Feature: calculator
/// Layer: domain/usecases
///
/// PURPOSE:
/// Performs cement bag estimation using provided dimensions and mix ratio.
///
/// RESPONSIBILITIES:
/// - Validate inputs > 0
/// - Compute wet and dry volume
/// - Determine cement volume based on mix ratio
/// - Convert to weight and bag count
/// - Apply waste and optional cost
///
/// NOTE: pure Dart; no Flutter imports.
/// ----------------------------------------------
library;


import 'package:site_buddy/features/calculator/domain/entities/cement_result.dart';

class CalculateCementUseCase {
  const CalculateCementUseCase();

  CementResult execute({
    required double length,
    required double width,
    required double depth,
    required int mixCement,
    required int mixSand,
    required int mixAggregate,
    required double wastePercent,
    double? pricePerBag,
  }) {
    if (length <= 0 || width <= 0 || depth <= 0) {
      throw ArgumentError('Dimensions must be greater than zero.');
    }
    if (mixCement <= 0 || mixSand < 0 || mixAggregate < 0) {
      throw ArgumentError(
        'Mix ratios must be non-negative; cement at least 1.',
      );
    }
    if (wastePercent < 0) {
      throw ArgumentError('Waste percent cannot be negative.');
    }
    // wet volume
    final wet = length * width * depth;
    // dry volume
    final dry = wet * 1.54;
    // mix ratio total
    final ratioTotal = mixCement + mixSand + mixAggregate;
    if (ratioTotal <= 0) {
      throw ArgumentError('Invalid mix ratio.');
    }
    // cement portion volume
    final cementVolume = dry * (mixCement / ratioTotal);
    // cement weight in kg: volume * density
    final cementWeight = cementVolume * 1440;
    // number of bags before waste
    final bags = cementWeight / 50;
    final finalBags = bags * (1 + wastePercent / 100);
    double? cost;
    if (pricePerBag != null && pricePerBag > 0) {
      cost = finalBags * pricePerBag;
    }
    return CementResult(
      wetVolume: wet,
      dryVolume: dry,
      cementWeight: cementWeight,
      numberOfBags: finalBags,
      totalCost: cost,
    );
  }
}



