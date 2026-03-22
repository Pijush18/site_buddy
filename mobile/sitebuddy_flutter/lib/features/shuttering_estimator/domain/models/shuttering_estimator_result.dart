/// CLASS: ShutteringEstimatorResult
class ShutteringEstimatorResult {
  final double area;

  const ShutteringEstimatorResult({
    required this.area,
  });

  Map<String, dynamic> toMap() {
    return {
      'area': area,
    };
  }
}
