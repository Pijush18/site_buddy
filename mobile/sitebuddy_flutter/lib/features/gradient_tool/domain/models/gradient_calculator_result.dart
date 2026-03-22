/// CLASS: GradientCalculatorResult
/// PURPOSE: Contains the output of a gradient calculation.
class GradientCalculatorResult {
  final double slopePercent;
  final String ratio;
  final double angleDegrees;

  const GradientCalculatorResult({
    required this.slopePercent,
    required this.ratio,
    required this.angleDegrees,
  });

  Map<String, dynamic> toMap() {
    return {
      'slope_percent': slopePercent,
      'ratio': ratio,
      'angle_degrees': angleDegrees,
    };
  }
}
