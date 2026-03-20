

class SandResult {
  final double wetVolume;
  final double dryVolume;
  final double cubicFeet;
  final double? totalCost;

  const SandResult({
    required this.wetVolume,
    required this.dryVolume,
    required this.cubicFeet,
    this.totalCost,
  });
}



