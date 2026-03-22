/// CLASS: LevelCalculatorInput
/// PURPOSE: Data container for leveling measurements.
class LevelCalculatorInput {
  final double backsight;
  final double foresight;
  final double? benchmarkRL;

  const LevelCalculatorInput({
    required this.backsight,
    required this.foresight,
    this.benchmarkRL,
  });
}
