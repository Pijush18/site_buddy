import 'package:site_buddy/core/qa/golden_test_cases.dart';
import 'package:site_buddy/features/level_calculator/domain/models/level_calculator_input.dart';
import 'package:site_buddy/features/level_calculator/domain/models/level_calculator_result.dart';

final levelCalculatorTestCases = [
  const GoldenTestCase<LevelCalculatorInput, LevelCalculatorResult>(
    id: 'LVL_001',
    description: 'Standard Rise: BS > FS',
    input: LevelCalculatorInput(backsight: 1.550, foresight: 1.250, benchmarkRL: 100.0),
    expected: LevelCalculatorResult(riseOrFall: 0.300, reducedLevel: 100.300, isRise: true),
  ),
  const GoldenTestCase<LevelCalculatorInput, LevelCalculatorResult>(
    id: 'LVL_002',
    description: 'Standard Fall: BS < FS',
    input: LevelCalculatorInput(backsight: 1.100, foresight: 1.850, benchmarkRL: 100.0),
    expected: LevelCalculatorResult(riseOrFall: -0.750, reducedLevel: 99.250, isRise: false),
  ),
  const GoldenTestCase<LevelCalculatorInput, LevelCalculatorResult>(
    id: 'LVL_003',
    description: 'Neutral: BS = FS',
    input: LevelCalculatorInput(backsight: 1.500, foresight: 1.500, benchmarkRL: 105.0),
    expected: LevelCalculatorResult(riseOrFall: 0.000, reducedLevel: 105.000, isRise: true),
  ),
];
