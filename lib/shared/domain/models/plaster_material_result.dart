// lib/models/plaster_material_result.dart
//
// Immutable result model returned by [MaterialEstimationService.calculatePlasterMaterials].
// Covers the cement and sand quantities needed for a cement-sand plaster/render coat.
//
// Conventions:
//   • All volumes in cubic metres (m³).
//   • Cement expressed in standard 50-kg bags for field use.
//   • The standard dry mortar bulking factor of 1.3 is applied internally.

import 'package:flutter/foundation.dart';

/// Holds every quantity produced by a plaster material estimation.
///
/// Instances are immutable value objects. Use [copyWith] to derive variants.
///
/// Example:
/// ```dart
/// final result = MaterialEstimationService().calculatePlasterMaterials(
///   area: 120.0, thickness: 0.012, mortarRatio: '1:4',
/// );
/// print('Cement bags: ${result.cementBags}');
/// ```
@immutable
class PlasterMaterialResult {
  // -------------------------------------------------------------------------
  // Geometric quantities
  // -------------------------------------------------------------------------

  /// Surface area to be plastered, in m².
  final double plasterArea;

  /// Plaster coat thickness, in metres (e.g. 0.012 for 12 mm).
  final double thickness;

  // -------------------------------------------------------------------------
  // Volume quantities
  // -------------------------------------------------------------------------

  /// Wet plaster volume (area × thickness), in m³.
  final double wetVolume;

  /// Dry mortar volume after applying the 1.3 bulking factor, in m³.
  final double dryVolume;

  // -------------------------------------------------------------------------
  // Material quantities
  // -------------------------------------------------------------------------

  /// Number of standard 50-kg cement bags required.
  final double cementBags;

  /// Weight of cement in kg (= cementBags × 50).
  final double cementWeight;

  /// Volume of fine aggregate (sand) required, in m³.
  final double sandVolume;

  // -------------------------------------------------------------------------
  // Supporting information
  // -------------------------------------------------------------------------

  /// Mortar mix ratio label as supplied by the caller (e.g. "1:4" or "1:6").
  final String mortarRatio;

  /// Dry mortar bulking factor applied during calculation. Defaults to 1.3.
  final double dryVolumeFactor;

  // -------------------------------------------------------------------------
  // Constructor
  // -------------------------------------------------------------------------

  const PlasterMaterialResult({
    required this.plasterArea,
    required this.thickness,
    required this.wetVolume,
    required this.dryVolume,
    required this.cementBags,
    required this.cementWeight,
    required this.sandVolume,
    required this.mortarRatio,
    this.dryVolumeFactor = 1.3,
  });

  // -------------------------------------------------------------------------
  // Utilities
  // -------------------------------------------------------------------------

  /// Creates a copy of this result with the given fields replaced.
  PlasterMaterialResult copyWith({
    double? plasterArea,
    double? thickness,
    double? wetVolume,
    double? dryVolume,
    double? cementBags,
    double? cementWeight,
    double? sandVolume,
    String? mortarRatio,
    double? dryVolumeFactor,
  }) {
    return PlasterMaterialResult(
      plasterArea: plasterArea ?? this.plasterArea,
      thickness: thickness ?? this.thickness,
      wetVolume: wetVolume ?? this.wetVolume,
      dryVolume: dryVolume ?? this.dryVolume,
      cementBags: cementBags ?? this.cementBags,
      cementWeight: cementWeight ?? this.cementWeight,
      sandVolume: sandVolume ?? this.sandVolume,
      mortarRatio: mortarRatio ?? this.mortarRatio,
      dryVolumeFactor: dryVolumeFactor ?? this.dryVolumeFactor,
    );
  }

  /// Converts the result to a plain map (e.g. for Hive persistence or JSON).
  Map<String, dynamic> toMap() => {
    'plasterArea': plasterArea,
    'thickness': thickness,
    'wetVolume': wetVolume,
    'dryVolume': dryVolume,
    'cementBags': cementBags,
    'cementWeight': cementWeight,
    'sandVolume': sandVolume,
    'mortarRatio': mortarRatio,
    'dryVolumeFactor': dryVolumeFactor,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlasterMaterialResult &&
          runtimeType == other.runtimeType &&
          plasterArea == other.plasterArea &&
          thickness == other.thickness &&
          cementBags == other.cementBags &&
          sandVolume == other.sandVolume &&
          mortarRatio == other.mortarRatio;

  @override
  int get hashCode =>
      Object.hash(plasterArea, thickness, cementBags, sandVolume, mortarRatio);

  @override
  String toString() =>
      'PlasterMaterialResult('
      'area: ${plasterArea.toStringAsFixed(2)} m², '
      'thickness: ${(thickness * 1000).toStringAsFixed(0)} mm, '
      'cement: ${cementBags.toStringAsFixed(1)} bags, '
      'sand: ${sandVolume.toStringAsFixed(3)} m³, '
      'ratio: $mortarRatio'
      ')';
}
