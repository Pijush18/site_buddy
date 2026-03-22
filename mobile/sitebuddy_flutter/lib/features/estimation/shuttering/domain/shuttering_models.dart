
/// MODEL: ShutteringInput
class ShutteringInput {
  final double length;
  final double width;
  final double depth;
  final bool includeBottom;

  ShutteringInput({
    required this.length,
    required this.width,
    required this.depth,
    this.includeBottom = false,
  });
}

/// MODEL: ShutteringResult
class ShutteringResult {
  final double areaM2;
  final double length;
  final double width;
  final double depth;
  final Map<String, double> breakdown;

  ShutteringResult({
    required this.areaM2,
    required this.length,
    required this.width,
    required this.depth,
    required this.breakdown,
  });

  Map<String, dynamic> toMap() => {
    'area': areaM2,
    'length': length,
    'width': width,
    'depth': depth,
    ...breakdown,
  };
}
