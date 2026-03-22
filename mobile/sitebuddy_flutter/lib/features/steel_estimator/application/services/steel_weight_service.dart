import 'package:site_buddy/features/steel_estimator/domain/models/steel_weight_input.dart';
import 'package:site_buddy/features/steel_estimator/domain/models/steel_weight_result.dart';

/// SERVICE: SteelWeightService
/// PURPOSE: Pure logic for steel rebar weight calculation.
class SteelWeightService {
  const SteelWeightService();

  /// CALCULATE: Derives total weight of steel rebar from diameter and length.
  /// 
  /// FORMULA: 
  /// 1. Unit Weight (kg/m) = (Diameter^2) / 162
  /// 2. Total Weight (kg) = Unit Weight * Length
  /// 
  /// UNITS: 
  /// - Diameter: millimeters (mm)
  /// - Length: meters (m)
  SteelWeightResult calculate(SteelWeightInput input) {
    _validate(input);

    final unitWeight = (input.diameter * input.diameter) / 162.0;
    final totalWeight = unitWeight * input.length;

    return SteelWeightResult(
      weight: double.parse(totalWeight.toStringAsFixed(3)),
      unitWeight: double.parse(unitWeight.toStringAsFixed(3)),
    );
  }

  void _validate(SteelWeightInput input) {
    if (input.diameter <= 0 || input.length <= 0) {
      throw ArgumentError('Steel diameter and length must be positive physical values');
    }
  }
}
