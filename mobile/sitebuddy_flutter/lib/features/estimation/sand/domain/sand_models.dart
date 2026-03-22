
/// MODEL: SandResult
class SandResult {
  final double wetVolume;
  final double dryVolume;
  final double cubicFeet;
  final double? totalCost;

  SandResult({
    required this.wetVolume,
    required this.dryVolume,
    required this.cubicFeet,
    this.totalCost,
  });

  Map<String, dynamic> toMap() => {
    'wetVolume': wetVolume,
    'dryVolume': dryVolume,
    'cubicFeet': cubicFeet,
    'totalCost': totalCost,
  };
}
