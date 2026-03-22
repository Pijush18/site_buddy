/// CLASS: ExcavationEstimatorInput
class ExcavationEstimatorInput {
  final double length;
  final double width;
  final double depth;
  final double swellFactor; // e.g. 1.2 for 20% swell

  const ExcavationEstimatorInput({
    required this.length,
    required this.width,
    required this.depth,
    this.swellFactor = 1.0,
  });
}
