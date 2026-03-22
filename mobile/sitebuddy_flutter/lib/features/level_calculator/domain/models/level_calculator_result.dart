/// CLASS: LevelCalculatorResult
/// PURPOSE: Contains the output of a leveling calculation.
class LevelCalculatorResult {
  final double riseOrFall;
  final double reducedLevel;
  final bool isRise;

  const LevelCalculatorResult({
    required this.riseOrFall,
    required this.reducedLevel,
    required this.isRise,
  });

  Map<String, dynamic> toMap() {
    return {
      'rise_or_fall': riseOrFall.abs(),
      'reduced_level': reducedLevel,
      'is_rise': isRise,
      'type': isRise ? 'Rise' : 'Fall',
    };
  }
}
