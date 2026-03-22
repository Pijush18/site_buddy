import 'package:site_buddy/features/brick_estimator/domain/models/brick_estimator_input.dart';
import 'package:site_buddy/features/brick_estimator/domain/models/brick_estimator_result.dart';

/// SERVICE: BrickEstimatorService
/// PURPOSE: Pure logic for brick wall estimation.
class BrickEstimatorService {
  const BrickEstimatorService();

  /// ESTIMATE: Calculates quantity of bricks and mortar volume for a masonry wall.
  /// 
  /// FORMULA: 
  /// 1. Wall Vol = L * H * T
  /// 2. Unit Vol (with mortar) = (BrickL + t) * (BrickH + t) * (BrickW + t)
  /// 3. Quantity = Wall Vol / Unit Vol
  /// 
  /// UNITS: Meters (m) for all dimensions and Cubic Meters (m3) for volume.
  BrickEstimatorResult estimate(BrickEstimatorInput input) {
    _validate(input);

    // 1. Volume of Wall
    final wallVolume = input.length * input.height * input.thickness;

    // 2. Volume of one brick with mortar (Standard 3D mortar bed)
    final brickWithMortarVol = (input.brickLength + input.mortarThickness) *
                               (input.brickHeight + input.mortarThickness) *
                               (input.brickWidth + input.mortarThickness);

    // 3. Number of Bricks
    var numBricks = wallVolume / brickWithMortarVol;
    numBricks = numBricks * (1 + input.wastePercent / 100);

    // 4. Volume of Bricks only
    final volumeOfBricksOnly = numBricks * (input.brickLength * input.brickHeight * input.brickWidth);

    // 5. Mortar Volume
    final mortarVolume = wallVolume - volumeOfBricksOnly;

    return BrickEstimatorResult(
      numberOfBricks: numBricks.roundToDouble(),
      mortarVolume: double.parse((mortarVolume > 0 ? mortarVolume : 0).toStringAsFixed(3)),
      wallVolume: double.parse(wallVolume.toStringAsFixed(3)),
    );
  }

  void _validate(BrickEstimatorInput input) {
    if (input.length <= 0 || input.height <= 0 || input.thickness <= 0) {
      throw ArgumentError('Wall dimensions must be positive physical values');
    }
    if (input.brickLength <= 0 || input.brickHeight <= 0 || input.brickWidth <= 0) {
      throw ArgumentError('Brick dimensions must be positive physical values');
    }
  }
}
