import 'package:site_buddy/core/qa/golden_test_cases.dart';
import 'package:site_buddy/features/steel_estimator/domain/models/steel_weight_input.dart';
import 'package:site_buddy/features/steel_estimator/domain/models/steel_weight_result.dart';

final steelEstimatorTestCases = [
  const GoldenTestCase<SteelWeightInput, SteelWeightResult>(
    id: 'STL_001',
    description: '10mm Bar, 12m length',
    input: SteelWeightInput(diameter: 10.0, length: 12.0),
    expected: SteelWeightResult(weight: 7.407, unitWeight: 0.617),
    tolerance: 0.5,
  ),
  const GoldenTestCase<SteelWeightInput, SteelWeightResult>(
    id: 'STL_002',
    description: '12mm Bar, 12m length',
    input: SteelWeightInput(diameter: 12.0, length: 12.0),
    expected: SteelWeightResult(weight: 10.667, unitWeight: 0.889),
    tolerance: 0.5,
  ),
  const GoldenTestCase<SteelWeightInput, SteelWeightResult>(
    id: 'STL_003',
    description: '8mm Bar, 1m starter',
    input: SteelWeightInput(diameter: 8.0, length: 1.0),
    expected: SteelWeightResult(weight: 0.395, unitWeight: 0.395),
    tolerance: 0.5,
  ),
];
