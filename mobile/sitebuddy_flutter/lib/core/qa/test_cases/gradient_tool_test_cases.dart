import 'package:site_buddy/core/qa/golden_test_cases.dart';
import 'package:site_buddy/features/gradient_tool/domain/models/gradient_calculator_input.dart';
import 'package:site_buddy/features/gradient_tool/domain/models/gradient_calculator_result.dart';

final gradientToolTestCases = [
  const GoldenTestCase<GradientCalculatorInput, GradientCalculatorResult>(
    id: 'GRD_001',
    description: 'Standard 1:10 Slope',
    input: GradientCalculatorInput(rise: 1.0, run: 10.0),
    expected: GradientCalculatorResult(slopePercent: 10.0, ratio: '1 : 10.0', angleDegrees: 5.71),
    tolerance: 1.0,
  ),
  const GoldenTestCase<GradientCalculatorInput, GradientCalculatorResult>(
    id: 'GRD_002',
    description: '45 Degree Slope (1:1)',
    input: GradientCalculatorInput(rise: 5.0, run: 5.0),
    expected: GradientCalculatorResult(slopePercent: 100.0, ratio: '1 : 1.0', angleDegrees: 45.0),
  ),
  const GoldenTestCase<GradientCalculatorInput, GradientCalculatorResult>(
    id: 'GRD_003',
    description: 'Flat Surface (Zero Rise)',
    input: GradientCalculatorInput(rise: 0.0, run: 100.0),
    expected: GradientCalculatorResult(slopePercent: 0.0, ratio: '1 : Flat', angleDegrees: 0.0),
  ),
];
