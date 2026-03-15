// lib/models/concrete_material_result.dart
//
// Immutable result model returned by [MaterialEstimationService.calculateConcreteMaterials].
// All volume values are in cubic metres (m³).
// All weight values are in kilograms (kg).
// Cement is also expressed in standard 50-kg bags for field convenience.

import 'package:flutter/foundation.dart';

/// Holds every computed quantity produced by a concrete material estimation.
///
/// Instances are immutable value objects. Use [copyWith] to derive variants.
///
/// Example:
/// ```dart
/// final result = MaterialEstimationService().calculateConcreteMaterials(
///   length: 5.0, width: 3.0, depth: 0.15, grade: ConcreteMixConstants.m20,
/// );
/// print('Cement bags: ${result.cementBags}');
/// ```
@immutable
class ConcreteMaterialResult {
  // -------------------------------------------------------------------------
  // Core concrete quantities
  // -------------------------------------------------------------------------

  /// Gross concrete volume (length × width × depth), in m³.
  final double concreteVolume;

  /// Number of standard 50-kg cement bags required.
  ///
  /// Computed from the dry volume, cement ratio, and cement bulk density
  /// (1440 kg/m³), rounded up to the nearest whole bag.
  final double cementBags;

  /// Weight of cement in kg (= cementBags × 50).
  final double cementWeight;

  /// Volume of fine aggregate (sand) required, in m³.
  final double sandVolume;

  /// Volume of coarse aggregate (gravel/crushed stone) required, in m³.
  final double aggregateVolume;

  // -------------------------------------------------------------------------
  // Reinforcement quantities (RCC elements only)
  // -------------------------------------------------------------------------

  /// Weight of main reinforcement steel required, in kg.
  ///
  /// Set to 0.0 for plain concrete (PCC) calculations.
  final double steelWeight;

  /// Weight of binding wire required to tie steel bars, in kg.
  ///
  /// Typically ≈ 0.8–1.0 % of [steelWeight]; set to 0.0 for PCC.
  final double bindingWire;

  // -------------------------------------------------------------------------
  // Supporting information
  // -------------------------------------------------------------------------

  /// The concrete grade used in this calculation (e.g. "M20").
  final String concreteGrade;

  /// Dry volume multiplier applied to convert wet volume to dry ingredients.
  /// Standard IS practice uses 1.54.
  final double dryVolumeFactor;

  // -------------------------------------------------------------------------
  // Constructor
  // -------------------------------------------------------------------------

  const ConcreteMaterialResult({
    required this.concreteVolume,
    required this.cementBags,
    required this.cementWeight,
    required this.sandVolume,
    required this.aggregateVolume,
    required this.steelWeight,
    required this.bindingWire,
    required this.concreteGrade,
    this.dryVolumeFactor = 1.54,
  });

  // -------------------------------------------------------------------------
  // Utilities
  // -------------------------------------------------------------------------

  /// Creates a copy of this result with the given fields replaced.
  ConcreteMaterialResult copyWith({
    double? concreteVolume,
    double? cementBags,
    double? cementWeight,
    double? sandVolume,
    double? aggregateVolume,
    double? steelWeight,
    double? bindingWire,
    String? concreteGrade,
    double? dryVolumeFactor,
  }) {
    return ConcreteMaterialResult(
      concreteVolume: concreteVolume ?? this.concreteVolume,
      cementBags: cementBags ?? this.cementBags,
      cementWeight: cementWeight ?? this.cementWeight,
      sandVolume: sandVolume ?? this.sandVolume,
      aggregateVolume: aggregateVolume ?? this.aggregateVolume,
      steelWeight: steelWeight ?? this.steelWeight,
      bindingWire: bindingWire ?? this.bindingWire,
      concreteGrade: concreteGrade ?? this.concreteGrade,
      dryVolumeFactor: dryVolumeFactor ?? this.dryVolumeFactor,
    );
  }

  /// Converts the result to a plain map (e.g. for Hive persistence or JSON).
  Map<String, dynamic> toMap() => {
    'concreteVolume': concreteVolume,
    'cementBags': cementBags,
    'cementWeight': cementWeight,
    'sandVolume': sandVolume,
    'aggregateVolume': aggregateVolume,
    'steelWeight': steelWeight,
    'bindingWire': bindingWire,
    'concreteGrade': concreteGrade,
    'dryVolumeFactor': dryVolumeFactor,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConcreteMaterialResult &&
          runtimeType == other.runtimeType &&
          concreteVolume == other.concreteVolume &&
          cementBags == other.cementBags &&
          sandVolume == other.sandVolume &&
          aggregateVolume == other.aggregateVolume &&
          steelWeight == other.steelWeight &&
          bindingWire == other.bindingWire &&
          concreteGrade == other.concreteGrade;

  @override
  int get hashCode => Object.hash(
    concreteVolume,
    cementBags,
    sandVolume,
    aggregateVolume,
    steelWeight,
    bindingWire,
    concreteGrade,
  );

  @override
  String toString() =>
      'ConcreteMaterialResult('
      'grade: $concreteGrade, '
      'volume: ${concreteVolume.toStringAsFixed(3)} m³, '
      'cement: ${cementBags.toStringAsFixed(1)} bags, '
      'sand: ${sandVolume.toStringAsFixed(3)} m³, '
      'aggregate: ${aggregateVolume.toStringAsFixed(3)} m³, '
      'steel: ${steelWeight.toStringAsFixed(1)} kg'
      ')';
}
