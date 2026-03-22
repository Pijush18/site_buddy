import 'package:site_buddy/core/qa/golden_test_cases.dart';
import 'package:site_buddy/features/brick_estimator/domain/models/brick_estimator_input.dart';
import 'package:site_buddy/features/brick_estimator/domain/models/brick_estimator_result.dart';

final brickEstimatorTestCases = [
  const GoldenTestCase<BrickEstimatorInput, BrickEstimatorResult>(
    id: 'BRK_001',
    description: '1 m3 Wall (230x110x70 bricks, 10mm mortar)',
    input: BrickEstimatorInput(
      length: 1.0,
      height: 1.0,
      thickness: 1.0,
      brickLength: 0.23,
      brickWidth: 0.11,
      brickHeight: 0.07,
      mortarThickness: 0.01,
      wastePercent: 0.0,
    ),
    expected: BrickEstimatorResult(
      numberOfBricks: 434.0, 
      mortarVolume: 0.231, 
      wallVolume: 1.0,
    ),
    tolerance: 1.0,
  ),
  const GoldenTestCase<BrickEstimatorInput, BrickEstimatorResult>(
    id: 'BRK_002',
    description: 'Half Brick Wall (10m x 3m)',
    input: BrickEstimatorInput(
      length: 10.0,
      height: 3.0,
      thickness: 0.11,
      brickLength: 0.23,
      brickWidth: 0.11,
      brickHeight: 0.07,
      mortarThickness: 0.01,
      wastePercent: 5.0,
    ),
    expected: BrickEstimatorResult(
      numberOfBricks: 1504.0, 
      mortarVolume: 0.637, 
      wallVolume: 3.3,
    ),
    tolerance: 1.0,
  ),
  const GoldenTestCase<BrickEstimatorInput, BrickEstimatorResult>(
    id: 'BRK_003',
    description: 'Small pillar',
    input: BrickEstimatorInput(
      length: 0.45,
      height: 2.0,
      thickness: 0.45,
      brickLength: 0.23,
      brickWidth: 0.11,
      brickHeight: 0.07,
      mortarThickness: 0.01,
      wastePercent: 0.0,
    ),
    expected: BrickEstimatorResult(
      numberOfBricks: 176.0,
      mortarVolume: 0.094,
      wallVolume: 0.405,
    ),
    tolerance: 1.0,
  ),
];
