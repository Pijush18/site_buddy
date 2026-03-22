/// CLASS: SteelWeightResult
class SteelWeightResult {
  final double weight; // kg
  final double unitWeight; // kg/m

  const SteelWeightResult({
    required this.weight,
    required this.unitWeight,
  });

  Map<String, dynamic> toMap() {
    return {
      'total_weight': weight,
      'unit_weight': unitWeight,
    };
  }
}
