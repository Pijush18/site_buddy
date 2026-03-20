/// FILE HEADER
/// ----------------------------------------------
/// File: cement_result.dart
/// Feature: calculator
/// Layer: domain/entities
///
/// PURPOSE:
/// Represents output of cement bag calculation.
///
/// RESPONSIBILITIES:
/// - Stores volume, weight, bag count, and optional cost.
///
/// ----------------------------------------------
library;


class CementResult {
  final double wetVolume;
  final double dryVolume;
  final double cementWeight;
  final double numberOfBags;
  final double? totalCost;

  const CementResult({
    required this.wetVolume,
    required this.dryVolume,
    required this.cementWeight,
    required this.numberOfBags,
    this.totalCost,
  });
}



