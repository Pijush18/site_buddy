import 'package:flutter/foundation.dart' show immutable;

/// lib/features/transport/road/domain/models/pavement_input.dart
///
/// Immutable input model for Road Pavement design.
@immutable
class PavementInput {
  /// California Bearing Ratio (CBR) percentage of the subgrade.
  final double subgradeCBR;

  /// Cumulative traffic in Million Standard Axles (msa).
  final double trafficMSA;

  /// Percentage of total thickness to allocate to Bituminous (BC + DBM) layer.
  /// Defaults to 0.25 (25%).
  final double bituminousPercent;

  const PavementInput({
    required this.subgradeCBR,
    required this.trafficMSA,
    this.bituminousPercent = 0.25,
  });
}
