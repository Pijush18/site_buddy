

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
  factory SandResult.fromMap(Map<String, dynamic> map) {
    return SandResult(
      wetVolume: (map['wetVolume'] as num).toDouble(),
      dryVolume: (map['dryVolume'] as num).toDouble(),
      cubicFeet: (map['cubicFeet'] as num).toDouble(),
      totalCost: (map['totalCost'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'wetVolume': wetVolume,
      'dryVolume': dryVolume,
      'cubicFeet': cubicFeet,
      'totalCost': totalCost,
    };
  }
}



