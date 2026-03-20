/// FILE: excavation_result.dart
/// LAYER: domain/models
///
/// PURPOSE:
/// Data entity representing the earthwork volume for site excavation.
class ExcavationResult {
  final double volumeM3;
  final double length;
  final double width;
  final double depth;
  final double clearance;
  final double swellFactor;

  const ExcavationResult({
    required this.volumeM3,
    required this.length,
    required this.width,
    required this.depth,
    required this.clearance,
    required this.swellFactor,
  });

  factory ExcavationResult.empty() {
    return const ExcavationResult(
      volumeM3: 0,
      length: 0,
      width: 0,
      depth: 0,
      clearance: 0.3,
      swellFactor: 1.25,
    );
  }
}



