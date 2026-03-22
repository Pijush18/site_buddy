/// CLASS: ShutteringEstimatorInput
class ShutteringEstimatorInput {
  final double length;
  final double width;
  final double height;
  final int numberOfSides; // 1 to 4 for beam/column sides

  const ShutteringEstimatorInput({
    required this.length,
    this.width = 0,
    this.height = 0,
    this.numberOfSides = 1,
  });
}
