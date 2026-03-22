import 'package:site_buddy/core/qa/golden_test_cases.dart';
import 'package:site_buddy/features/shuttering_estimator/domain/models/shuttering_estimator_input.dart';
import 'package:site_buddy/features/shuttering_estimator/domain/models/shuttering_estimator_result.dart';

final shutteringEstimatorTestCases = [
  const GoldenTestCase<ShutteringEstimatorInput, ShutteringEstimatorResult>(
    id: 'SHT_001',
    description: 'Slab (4m x 5m)',
    input: ShutteringEstimatorInput(length: 5.0, width: 4.0, height: 0.0, numberOfSides: 1),
    expected: ShutteringEstimatorResult(area: 20.0),
  ),
  const GoldenTestCase<ShutteringEstimatorInput, ShutteringEstimatorResult>(
    id: 'SHT_002',
    description: 'Beam (5m L, 0.23m W, 0.45m H, 2 sides)',
    input: ShutteringEstimatorInput(length: 5.0, width: 0.23, height: 0.45, numberOfSides: 2),
    expected: ShutteringEstimatorResult(area: 5.65), // (0.23*5) + (2*0.45*5)
  ),
  const GoldenTestCase<ShutteringEstimatorInput, ShutteringEstimatorResult>(
    id: 'SHT_003',
    description: 'Column (3m L, 0.3x0.3m, 4 sides)',
    input: ShutteringEstimatorInput(length: 3.0, width: 0.3, height: 0.3, numberOfSides: 4),
    expected: ShutteringEstimatorResult(area: 3.6), // 2*(0.3+0.3)*3
  ),
];
