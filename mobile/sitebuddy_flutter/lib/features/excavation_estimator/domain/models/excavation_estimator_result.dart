/// CLASS: ExcavationEstimatorResult
class ExcavationEstimatorResult {
  final double volume;
  final double looseVolume;

  const ExcavationEstimatorResult({
    required this.volume,
    required this.looseVolume,
  });

  Map<String, dynamic> toMap() {
    return {
      'volume': volume,
      'loose_volume': looseVolume,
    };
  }
}
