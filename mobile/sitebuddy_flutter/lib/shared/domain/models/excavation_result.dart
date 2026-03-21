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

  factory ExcavationResult.fromMap(Map<String, dynamic> map) {
    return ExcavationResult(
      volumeM3: (map['volumeM3'] as num).toDouble(),
      length: (map['length'] as num).toDouble(),
      width: (map['width'] as num).toDouble(),
      depth: (map['depth'] as num).toDouble(),
      clearance: (map['clearance'] as num).toDouble(),
      swellFactor: (map['swellFactor'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'volumeM3': volumeM3,
      'length': length,
      'width': width,
      'depth': depth,
      'clearance': clearance,
      'swellFactor': swellFactor,
    };
  }

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
