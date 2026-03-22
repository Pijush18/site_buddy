import 'package:site_buddy/features/excavation_estimator/domain/models/excavation_estimator_input.dart';
import 'package:site_buddy/features/excavation_estimator/domain/models/excavation_estimator_result.dart';

/// SERVICE: ExcavationEstimatorService
/// PURPOSE: Pure logic for excavation volume calculation.
class ExcavationEstimatorService {
  const ExcavationEstimatorService();

  /// CALCULATE: Determines earthwork volume (Net and Loose).
  /// 
  /// FORMULA: 
  /// 1. Net Volume = L * W * D
  /// 2. Loose Volume = Net Volume * SwellFactor
  /// 
  /// UNITS: Cubic Meters (m3).
  /// SWELL FACTORS: 
  /// - Sand: 1.10 - 1.15
  /// - Clay: 1.20 - 1.40
  /// - Rock: 1.50 - 1.70
  ExcavationEstimatorResult calculate(ExcavationEstimatorInput input) {
    _validate(input);

    final netVolume = input.length * input.width * input.depth;
    final looseVolume = netVolume * input.swellFactor;

    return ExcavationEstimatorResult(
      volume: double.parse(netVolume.toStringAsFixed(3)),
      looseVolume: double.parse(looseVolume.toStringAsFixed(3)),
    );
  }

  void _validate(ExcavationEstimatorInput input) {
    if (input.length <= 0 || input.width <= 0 || input.depth <= 0) {
      throw ArgumentError('Excavation dimensions must be positive physical values');
    }
    if (input.swellFactor < 1.0) {
      throw ArgumentError('Swell factor must be at least 1.0 (soil expands when loose)');
    }
  }
}
