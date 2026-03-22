import 'package:flutter/foundation.dart' show immutable;

/// lib/features/water/irrigation/domain/models/discharge_result.dart
///
/// Immutable result model for Irrigation Discharge calculations.
@immutable
class DischargeResult {
  /// Rate of flow in cubic metres per second (m³/s).
  final double dischargeQ;

  /// Rate of flow in litres per second (l/s).
  final double dischargeLPS;

  /// Total volume of water in cubic metres (m³) if duration was provided.
  final double? totalVolume;

  /// The methodology used for the calculation.
  final String methodology;

  const DischargeResult({
    required this.dischargeQ,
    required this.dischargeLPS,
    this.totalVolume,
    required this.methodology,
  });

  /// Converts the result to a map for persistence.
  Map<String, dynamic> toMap() => {
    'dischargeQ': dischargeQ,
    'dischargeLPS': dischargeLPS,
    'totalVolume': totalVolume,
    'methodology': methodology,
  };
}
