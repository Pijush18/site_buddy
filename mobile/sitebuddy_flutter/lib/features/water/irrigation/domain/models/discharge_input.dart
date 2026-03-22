import 'package:flutter/foundation.dart' show immutable;

/// lib/features/water/irrigation/domain/models/discharge_input.dart
///
/// Immutable input model for Irrigation Discharge calculation.
@immutable
class DischargeInput {
  /// Cross-sectional area of the water channel in square metres (m²).
  final double area;

  /// Mean velocity of the water flow in metres per second (m/s).
  final double velocity;

  /// Optional: Duration of flow in hours (for volume calculation).
  final double? durationHours;

  const DischargeInput({
    required this.area,
    required this.velocity,
    this.durationHours,
  });
}
