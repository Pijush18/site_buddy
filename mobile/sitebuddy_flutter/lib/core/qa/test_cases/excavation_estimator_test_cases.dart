import 'package:site_buddy/core/qa/golden_test_cases.dart';
import 'package:site_buddy/features/excavation_estimator/domain/models/excavation_estimator_input.dart';
import 'package:site_buddy/features/excavation_estimator/domain/models/excavation_estimator_result.dart';

final excavationEstimatorTestCases = [
  const GoldenTestCase<ExcavationEstimatorInput, ExcavationEstimatorResult>(
    id: 'EXC_001',
    description: '2x2x2 Pit (20% Swell)',
    input: ExcavationEstimatorInput(length: 2.0, width: 2.0, depth: 2.0, swellFactor: 1.2),
    expected: ExcavationEstimatorResult(volume: 8.0, looseVolume: 9.6),
  ),
  const GoldenTestCase<ExcavationEstimatorInput, ExcavationEstimatorResult>(
    id: 'EXC_002',
    description: 'Surface Strip (10m x 10m x 0.15m)',
    input: ExcavationEstimatorInput(length: 10.0, width: 10.0, depth: 0.15, swellFactor: 1.15),
    expected: ExcavationEstimatorResult(volume: 15.0, looseVolume: 17.25),
  ),
  const GoldenTestCase<ExcavationEstimatorInput, ExcavationEstimatorResult>(
    id: 'EXC_003',
    description: 'Trench (50m x 0.6m x 1m)',
    input: ExcavationEstimatorInput(length: 50.0, width: 0.6, depth: 1.0, swellFactor: 1.3),
    expected: ExcavationEstimatorResult(volume: 30.0, looseVolume: 39.0),
  ),
];
