/// FILE HEADER
/// ----------------------------------------------
/// File: gradient_result.dart
/// Feature: calculator
/// Layer: domain/entities
///
/// PURPOSE:
/// Represents the computed gradient details between two measurements.
///
/// RESPONSIBILITIES:
/// - Holds rise and run values.
/// - Stores derived slope, percentage, angle, ratio string and classification.
///
/// FUTURE IMPROVEMENTS:
/// - Add descriptive text or color-coding helpers.
/// ----------------------------------------------
library;


/// Classification categories for gradient steepness.
enum GradientClassification { flat, mild, moderate, steep }

/// Computed result from the gradient use case.
class GradientResult {
  final double rise;
  final double run;
  final double slope;
  final double percentage;
  final double angle;
  final double ratio;
  final GradientClassification classification;

  const GradientResult({
    required this.rise,
    required this.run,
    required this.slope,
    required this.percentage,
    required this.angle,
    required this.ratio,
    required this.classification,
  });
}



