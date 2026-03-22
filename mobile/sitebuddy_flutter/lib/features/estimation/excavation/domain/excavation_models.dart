
/// MODEL: ExcavationInput
class ExcavationInput {
  final double length;
  final double width;
  final double depth;
  final double clearance;
  final double swellFactor;

  ExcavationInput({
    required this.length,
    required this.width,
    required this.depth,
    this.clearance = 0.3,
    this.swellFactor = 1.25,
  });
}

/// MODEL: ExcavationResult
class ExcavationResult {
  final double volumeM3;
  final double length;
  final double width;
  final double depth;
  final double clearance;
  final double swellFactor;

  ExcavationResult({
    required this.volumeM3,
    required this.length,
    required this.width,
    required this.depth,
    required this.clearance,
    required this.swellFactor,
  });

  Map<String, dynamic> toMap() => {
    'volume': volumeM3,
    'length': length,
    'width': width,
    'depth': depth,
    'clearance': clearance,
    'swell': swellFactor,
  };
}
