import 'package:site_buddy/core/qa/golden_test_cases.dart';
import 'package:site_buddy/features/concrete_estimator/domain/models/concrete_estimator_input.dart';
import 'package:site_buddy/features/concrete_estimator/domain/models/concrete_estimator_result.dart';

final concreteEstimatorTestCases = [
  const GoldenTestCase<ConcreteEstimatorInput, ConcreteEstimatorResult>(
    id: 'CON_001',
    description: 'Standard 1:2:4 Mix (1 m3 Wet)',
    input: ConcreteEstimatorInput(
      volume: 1.0,
      cementRatio: 1.0,
      sandRatio: 2.0,
      aggregateRatio: 4.0,
      wastePercent: 0.0,
      bagWeight: 50.0,
    ),
    expected: ConcreteEstimatorResult(
      cementBags: 6.35, 
      sandVolume: 0.44,
      aggregateVolume: 0.88,
      dryVolume: 1.54,
    ),
    tolerance: 0.5,
  ),
  const GoldenTestCase<ConcreteEstimatorInput, ConcreteEstimatorResult>(
    id: 'CON_002',
    description: '10 m3 with 5% waste (1:1.5:3)',
    input: ConcreteEstimatorInput(
      volume: 10.0,
      cementRatio: 1.0,
      sandRatio: 1.5,
      aggregateRatio: 3.0,
      wastePercent: 5.0,
      bagWeight: 50.0,
    ),
    expected: ConcreteEstimatorResult(
      cementBags: 84.67, 
      sandVolume: 4.41,
      aggregateVolume: 8.82,
      dryVolume: 16.17,
    ),
    tolerance: 0.5,
  ),
  const GoldenTestCase<ConcreteEstimatorInput, ConcreteEstimatorResult>(
    id: 'CON_003',
    description: 'Small footing (0.5 m3, 1:2.5:5)',
    input: ConcreteEstimatorInput(
      volume: 0.5,
      cementRatio: 1.0,
      sandRatio: 2.5,
      aggregateRatio: 5.0,
      wastePercent: 0.0,
      bagWeight: 50.0,
    ),
    expected: ConcreteEstimatorResult(
      cementBags: 2.61, 
      sandVolume: 0.23,
      aggregateVolume: 0.45,
      dryVolume: 0.77,
    ),
    tolerance: 0.5,
  ),
];
