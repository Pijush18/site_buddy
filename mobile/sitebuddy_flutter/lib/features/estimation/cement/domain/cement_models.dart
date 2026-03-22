
/// MODEL: CementResult
class CementResult {
  final double wetVolume;
  final double dryVolume;
  final double cementWeight;
  final double numberOfBags;
  final double? totalCost;

  CementResult({
    required this.wetVolume,
    required this.dryVolume,
    required this.cementWeight,
    required this.numberOfBags,
    this.totalCost,
  });

  Map<String, dynamic> toMap() => {
    'wetVolume': wetVolume,
    'dryVolume': dryVolume,
    'cementWeight': cementWeight,
    'numberOfBags': numberOfBags,
    'totalCost': totalCost,
  };
}
