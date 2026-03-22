/// FILE HEADER
/// ----------------------------------------------
/// File: rebar_result.dart
/// Feature: calculator
/// Layer: domain/entities
///
/// PURPOSE:
/// Represents the output of the rebar length and weight estimation.
///
/// RESPONSIBILITIES:
/// - Hold computed metrics: number of bars, total length, total weight.
///
/// NOTE:
/// Pure Dart object used by usecases and controllers.
/// ----------------------------------------------
library;


/// Output model for rebar estimations.
class RebarResult {
  final double numberOfBars;
  final double totalLength;
  final double totalWeight;

  const RebarResult({
    required this.numberOfBars,
    required this.totalLength,
    required this.totalWeight,
  });

  Map<String, dynamic> toMap() => {
        'numberOfBars': numberOfBars,
        'totalLength': totalLength,
        'totalWeight': totalWeight,
      };
}



