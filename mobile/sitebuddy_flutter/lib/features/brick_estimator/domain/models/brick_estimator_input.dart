/// CLASS: BrickEstimatorInput
class BrickEstimatorInput {
  final double length;
  final double height;
  final double thickness;
  final double brickLength;
  final double brickHeight;
  final double brickWidth;
  final double mortarThickness;
  final double wastePercent;

  const BrickEstimatorInput({
    required this.length,
    required this.height,
    required this.thickness,
    required this.brickLength,
    required this.brickHeight,
    required this.brickWidth,
    this.mortarThickness = 0.01, // 10mm
    this.wastePercent = 5.0,
  });
}
