import 'package:flutter/foundation.dart' show immutable;

/// lib/features/transport/road/domain/models/pavement_result.dart
///
/// Immutable result model for Road Pavement design calculations.
@immutable
class PavementResult {
  /// Total calculated pavement thickness in mm.
  final double totalThickness;

  /// Thickness of Bituminous layer (mm).
  final double bituminousThickness;

  /// Thickness of Granular Base (WMM) layer (mm).
  final double baseThickness;

  /// Thickness of Granular Sub-base (GSB) layer (mm).
  final double subBaseThickness;

  /// The standard code used for this calculation.
  final String designCode;

  const PavementResult({
    required this.totalThickness,
    required this.bituminousThickness,
    required this.baseThickness,
    required this.subBaseThickness,
    required this.designCode,
  });

  /// Converts the result to a map for persistence.
  Map<String, dynamic> toMap() => {
    'totalThickness': totalThickness,
    'bituminousThickness': bituminousThickness,
    'baseThickness': baseThickness,
    'subBaseThickness': subBaseThickness,
    'designCode': designCode,
  };
}
