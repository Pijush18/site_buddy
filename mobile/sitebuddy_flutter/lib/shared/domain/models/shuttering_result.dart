/// FILE: shuttering_result.dart
/// LAYER: domain/models
///
/// PURPOSE:
/// Data entity representing the formwork area required for reinforced concrete.
class ShutteringResult {
  final double areaM2;
  final double length;
  final double width;
  final double depth;

  const ShutteringResult({
    required this.areaM2,
    required this.length,
    required this.width,
    required this.depth,
  });

  factory ShutteringResult.empty() {
    return const ShutteringResult(areaM2: 0, length: 0, width: 0, depth: 0);
  }
}



