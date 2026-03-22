import 'package:site_buddy/features/level_calculator/domain/models/level_calculator_input.dart';
import 'package:site_buddy/features/level_calculator/domain/models/level_calculator_result.dart';

/// SERVICE: LevelCalculatorService
/// PURPOSE: Pure logic for leveling calculations.
class LevelCalculatorService {
  const LevelCalculatorService();

  /// CALCULATE: Performs leveling calculation using Rise/Fall method.
  /// 
  /// FORMULA: 
  /// 1. Difference = Backsight - Foresight
  /// 2. New RL = Current RL + Difference
  /// 
  /// UNITS: Meters (m) for all linear measurements.
  LevelCalculatorResult calculate(LevelCalculatorInput input) {
    _validate(input);

    final diff = input.backsight - input.foresight;
    
    final currentRL = input.benchmarkRL ?? 100.0;
    final newRL = currentRL + diff;

    return LevelCalculatorResult(
      riseOrFall: diff,
      reducedLevel: newRL,
      isRise: diff >= 0,
    );
  }

  void _validate(LevelCalculatorInput input) {
    // Basic structural validation is handled by type safety.
    // Negative values for BS/FS are allowed in inverted staff leveling (special case).
    if (input.benchmarkRL != null && input.benchmarkRL! < -10000) {
      throw ArgumentError('Benchmark RL is outside realistic engineering range');
    }
  }
}
