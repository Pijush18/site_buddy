import 'package:site_buddy/features/concrete_estimator/domain/models/concrete_estimator_input.dart';
import 'package:site_buddy/features/concrete_estimator/domain/models/concrete_estimator_result.dart';

/// SERVICE: ConcreteEstimatorService
/// PURPOSE: Pure logic for concrete material estimation.
class ConcreteEstimatorService {
  const ConcreteEstimatorService();

  static const double _dryVolumeFactor = 1.54; // Dry volume = 1.54 * Wet volume
  static const double _cementDensity = 1440.0; // kg/m3

  /// ESTIMATE: Calculates required cement bags, sand, and aggregate for wet concrete.
  /// 
  /// FORMULA: 
  /// 1. Dry Volume = Wet Volume * 1.54 (Bulge + Voids factor)
  /// 2. Cement Vol = (CementRatio / TotalRatio) * DryVolume
  /// 3. Cement Bags = (CementVol * 1440kg/m3) / BagWeight
  /// 
  /// UNITS: 
  /// - Volume: Cubic meters (m3)
  /// - Weight: Kilograms (kg)
  ConcreteEstimatorResult estimate(ConcreteEstimatorInput input) {
    _validate(input);

    final totalRatio = input.cementRatio + input.sandRatio + input.aggregateRatio;
    
    // 1. Calculate Dry Volume (including waste)
    final dryVolume = input.volume * _dryVolumeFactor * (1 + input.wastePercent / 100);

    // 2. Individual Volumes
    final cementVol = (input.cementRatio / totalRatio) * dryVolume;
    final sandVol = (input.sandRatio / totalRatio) * dryVolume;
    final aggregateVol = (input.aggregateRatio / totalRatio) * dryVolume;

    // 3. Convert Cement Volume to Bags
    final cementWeight = cementVol * _cementDensity;
    final cementBags = cementWeight / input.bagWeight;

    return ConcreteEstimatorResult(
      cementBags: double.parse(cementBags.toStringAsFixed(2)),
      sandVolume: double.parse(sandVol.toStringAsFixed(2)),
      aggregateVolume: double.parse(aggregateVol.toStringAsFixed(2)),
      dryVolume: double.parse(dryVolume.toStringAsFixed(2)),
    );
  }

  void _validate(ConcreteEstimatorInput input) {
    if (input.volume <= 0) {
      throw ArgumentError('Wet volume must be greater than zero');
    }
    if (input.cementRatio < 0 || input.sandRatio < 0 || input.aggregateRatio < 0) {
      throw ArgumentError('Mix ratios cannot be negative');
    }
    if (input.bagWeight <= 0) {
      throw ArgumentError('Cement bag weight must be a positive value (e.g., 50kg)');
    }
  }
}
