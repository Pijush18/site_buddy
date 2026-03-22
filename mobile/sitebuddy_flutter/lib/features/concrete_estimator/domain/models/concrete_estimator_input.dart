/// CLASS: ConcreteEstimatorInput
class ConcreteEstimatorInput {
  final double volume; // Wet volume in m3
  final double cementRatio;
  final double sandRatio;
  final double aggregateRatio;
  final double wastePercent;
  final double bagWeight; // Usually 50kg

  const ConcreteEstimatorInput({
    required this.volume,
    required this.cementRatio,
    required this.sandRatio,
    required this.aggregateRatio,
    this.wastePercent = 5.0,
    this.bagWeight = 50.0,
  });
}
