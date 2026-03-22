import 'package:site_buddy/core/engineering/standards/hydrology/hydrology_standard.dart';
import 'package:site_buddy/features/water/irrigation/domain/models/discharge_input.dart';
import 'package:site_buddy/features/water/irrigation/domain/models/discharge_result.dart';

/// lib/features/water/irrigation/domain/services/irrigation_design_service.dart
///
/// Engineering service for irrigation discharge calculations.
/// Strictly stateless and follows the DDD domain service pattern.
class IrrigationDesignService {
  final HydrologyStandard standard;

  const IrrigationDesignService(this.standard);

  /// Computes the discharge (Q) based on area and velocity.
  /// Also calculates total volume if duration is provided.
  DischargeResult calculateDischarge(DischargeInput input) {
    // 1. Compute Discharge Q (m³/s) via Standard
    final double dischargeQ = standard.computeDischarge(
      area: input.area,
      velocity: input.velocity,
    );

    // 2. Convert to l/s (1 m³/s = 1000 l/s)
    final double dischargeLPS = dischargeQ * 1000.0;

    // 3. Compute Total Volume (m³) if duration is available (m³/s * 3600 * hrs)
    double? totalVolume;
    if (input.durationHours != null) {
      totalVolume = dischargeQ * 3600.0 * input.durationHours!;
    }

    return DischargeResult(
      dischargeQ: dischargeQ,
      dischargeLPS: dischargeLPS,
      totalVolume: totalVolume,
      methodology: standard.methodologyIdentifier,
    );
  }
}
