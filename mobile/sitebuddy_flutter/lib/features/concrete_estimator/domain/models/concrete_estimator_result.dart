/// CLASS: ConcreteEstimatorResult
class ConcreteEstimatorResult {
  final double cementBags;
  final double sandVolume; // m3
  final double aggregateVolume; // m3
  final double dryVolume;

  const ConcreteEstimatorResult({
    required this.cementBags,
    required this.sandVolume,
    required this.aggregateVolume,
    required this.dryVolume,
  });

  Map<String, dynamic> toMap() {
    return {
      'cement_bags': cementBags,
      'sand_volume': sandVolume,
      'aggregate_volume': aggregateVolume,
      'dry_volume': dryVolume,
    };
  }
}
