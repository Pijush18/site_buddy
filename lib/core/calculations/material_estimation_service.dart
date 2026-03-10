// lib/core/calculations/material_estimation_service.dart
//
// Central, reusable material estimation engine for SiteBuddy.
//
// ┌─────────────────────────────────────────────────────────────────────────┐
// │  ARCHITECTURE NOTE                                                       │
// │  All arithmetic lives here — never inside UI widgets.                   │
// │  This service is intentionally free of Flutter framework dependencies   │
// │  so that it can be unit-tested without a running Flutter engine.        │
// └─────────────────────────────────────────────────────────────────────────┘
//
// References:
//   • IS 456:2000 — Plain and Reinforced Concrete Code of Practice
//   • SP 34 (S&T):1987 — Handbook on Reinforcement and Detailing
//   • IS 2212:1991 — Code of Practice for Brickwork
//
// Usage example:
//   ```dart
//   final service = MaterialEstimationService();
//
//   final concrete = service.calculateConcreteMaterials(
//     length: 5.0, width: 3.0, depth: 0.15,
//     grade: ConcreteMixConstants.m20,
//   );
//
//   final wall = service.calculateBrickWallMaterials(
//     length: 10.0, height: 3.0, thickness: 0.23,
//     mortarRatioString: '1:6',
//   );
//
//   final plaster = service.calculatePlasterMaterials(
//     area: 80.0, thickness: 0.012,
//     mortarRatioString: '1:4',
//   );
//   ```

import 'package:site_buddy/shared/domain/models/brick_wall_result.dart';
import 'package:site_buddy/shared/domain/models/concrete_material_result.dart';
import 'package:site_buddy/shared/domain/models/plaster_material_result.dart';
import 'package:site_buddy/core/constants/concrete_mix_constants.dart';

/// Stateless service that performs all material quantity estimations.
///
/// Each public method takes plain dimensions / parameters and returns a
/// fully-typed, immutable result object. The service holds no mutable state
/// and is safe to share as a singleton (e.g. via a provider).
class MaterialEstimationService {
  // -------------------------------------------------------------------------
  // Physical constants (kept private — callers use result objects)
  // -------------------------------------------------------------------------

  /// Dry-to-wet volume conversion for concrete ingredients.
  ///
  /// When dry ingredients are mixed with water the volume reduces by ≈ 35%.
  /// Multiplying the wet concrete volume by 1.54 gives the required dry volume.
  static const double _concreteDryFactor = 1.54;

  /// Dry-to-wet volume conversion for cement-sand mortar.
  ///
  /// Dry mortar ingredients occupy ≈ 30% more volume than the wet mortar they
  /// produce. Factor = 1 / (1 − 0.20) ≈ 1.3 (IS 2212 guidance).
  static const double _mortarDryFactor = 1.30;

  /// Bulk density of cement, in kg/m³ (IS 269:2015 reference value).
  static const double _cementBulkDensityKgPerM3 = 1440.0;

  /// Standard cement bag weight in kg (50 kg bag, IS 456).
  static const double _cementBagWeightKg = 50.0;

  /// Standard IS modular brick dimensions in metres (190 × 90 × 90 mm).
  static const double _brickLengthM = 0.190;
  static const double _brickWidthM = 0.090;
  static const double _brickHeightM = 0.090;

  /// Standard mortar joint thickness in metres (10 mm).
  static const double _mortarJointM = 0.010;

  /// Brick wastage allowance expressed as a multiplier (5 % → 1.05).
  static const double _brickWastage = 1.05;

  // -------------------------------------------------------------------------
  // Public API
  // -------------------------------------------------------------------------

  // ·····················································
  // 1. Concrete Materials
  // ·····················································

  /// Estimates the dry ingredient quantities required to cast a concrete
  /// element of the given dimensions.
  ///
  /// ### Algorithm (IS 456:2000 volume-proportioning method)
  ///
  /// 1. Wet concrete volume  = length × width × depth
  /// 2. Dry volume           = wet volume × 1.54
  /// 3. Cement volume        = dry volume × (cRatio / totalParts)
  /// 4. Cement weight        = cement volume × 1440 kg/m³
  /// 5. Cement bags          = ⌈ cement weight / 50 ⌉
  /// 6. Sand volume          = dry volume × (sRatio / totalParts)
  /// 7. Aggregate volume     = dry volume × (aRatio / totalParts)
  /// 8. Steel weight         = wet volume × steelPercentage × 7850 kg/m³
  /// 9. Binding wire         = steel weight × 0.01  (≈ 1 %)
  ///
  /// ### Parameters
  ///
  /// - [length]          : Length of the concrete element, in metres.
  /// - [width]           : Width of the concrete element, in metres.
  /// - [depth]           : Depth / thickness of the concrete element, in metres.
  /// - [grade]           : Concrete mix grade (default: M20).
  /// - [steelPercentage] : Percentage of steel reinforcement by volume
  ///                       (e.g. 0.01 for 1 %). Pass 0.0 for plain concrete.
  ///
  /// Throws [ArgumentError] if any dimension is ≤ 0.
  ConcreteMaterialResult calculateConcreteMaterials({
    required double length,
    required double width,
    required double depth,
    ConcreteMix? grade,
    double steelPercentage = 0.01,
  }) {
    // ── Input validation ─────────────────────────────────────────────────────
    _assertPositive(length, 'length');
    _assertPositive(width, 'width');
    _assertPositive(depth, 'depth');
    _assertNonNegative(steelPercentage, 'steelPercentage');

    final mix = grade ?? ConcreteMixConstants.m20;

    // ── Volume calculations ───────────────────────────────────────────────────
    final double wetVolume = length * width * depth;
    final double dryVolume = wetVolume * _concreteDryFactor;
    final double totalParts = mix.totalParts;

    // ── Cement ───────────────────────────────────────────────────────────────
    final double cementVolumeM3 = dryVolume * (mix.cementRatio / totalParts);
    final double cementWeightKg = cementVolumeM3 * _cementBulkDensityKgPerM3;
    // Ceiling to whole bags — never round down on a construction site
    final double cementBags = (cementWeightKg / _cementBagWeightKg)
        .ceilToDouble();
    // Reconcile weight to match rounded-up bags
    final double actualCementWeightKg = cementBags * _cementBagWeightKg;

    // ── Sand ─────────────────────────────────────────────────────────────────
    final double sandVolumeM3 = dryVolume * (mix.sandRatio / totalParts);

    // ── Aggregate ────────────────────────────────────────────────────────────
    final double aggregateVolumeM3 =
        dryVolume * (mix.aggregateRatio / totalParts);

    // ── Reinforcement steel (RCC only) ────────────────────────────────────────
    // Steel density = 7850 kg/m³ (IS 1786 reference)
    final double steelWeightKg = wetVolume * steelPercentage * 7850.0;

    // ── Binding wire (≈ 1 % of steel weight) ─────────────────────────────────
    final double bindingWireKg = steelWeightKg * 0.01;

    return ConcreteMaterialResult(
      concreteVolume: _round(wetVolume),
      cementBags: cementBags,
      cementWeight: _round(actualCementWeightKg),
      sandVolume: _round(sandVolumeM3),
      aggregateVolume: _round(aggregateVolumeM3),
      steelWeight: _round(steelWeightKg),
      bindingWire: _round(bindingWireKg),
      concreteGrade: mix.grade,
      dryVolumeFactor: _concreteDryFactor,
    );
  }

  // ·····················································
  // 2. Brick Wall Materials
  // ·····················································

  /// Estimates the number of bricks and mortar quantities for a brick masonry
  /// wall of the given dimensions.
  ///
  /// ### Algorithm (IS 2212:1991 method)
  ///
  /// Standard IS modular brick: 190 × 90 × 90 mm (without mortar joint).
  /// With 10 mm mortar joint: 200 × 100 × 100 mm per brick.
  ///
  /// 1. Wall volume            = length × height × thickness
  /// 2. Volume per brick (with joint) = 0.200 × 0.100 × 0.100 = 0.002 m³
  /// 3. Number of bricks       = ⌈ wall volume / 0.002 ⌉ × 1.05 (5 % wastage)
  /// 4. Brick volume           = number of bricks (net) × pure brick volume
  /// 5. Mortar volume          = wall volume − brick volume
  /// 6. Dry mortar volume      = mortar volume × 1.30
  /// 7. Parse mortar ratio     "1:N" → cement parts = 1, sand parts = N
  /// 8. Cement volume          = dry mortar × 1/(1+N)
  /// 9. Cement weight          = cement volume × 1440
  /// 10. Sand volume           = dry mortar × N/(1+N)
  ///
  /// ### Parameters
  ///
  /// - [length]            : Wall length, in metres.
  /// - [height]            : Wall height, in metres.
  /// - [thickness]         : Wall thickness, in metres (e.g. 0.23 for 9-inch).
  /// - [mortarRatioString] : Cement-sand mortar ratio as "1:N" (e.g. "1:6").
  ///
  /// Throws [ArgumentError] for invalid dimensions or ratio strings.
  BrickWallResult calculateBrickWallMaterials({
    required double length,
    required double height,
    required double thickness,
    String mortarRatioString = '1:6',
  }) {
    // ── Input validation ─────────────────────────────────────────────────────
    _assertPositive(length, 'length');
    _assertPositive(height, 'height');
    _assertPositive(thickness, 'thickness');
    final (int cParts, int sParts) = _parseMortarRatio(mortarRatioString);

    // ── Wall volume ───────────────────────────────────────────────────────────
    final double wallVolume = length * height * thickness;

    // Volume occupied by one brick including its mortar joints on all faces
    final double brickWithJointVolume =
        (_brickLengthM + _mortarJointM) *
        (_brickWidthM + _mortarJointM) *
        (_brickHeightM + _mortarJointM);

    // ── Number of bricks ─────────────────────────────────────────────────────
    final int netBricks = (wallVolume / brickWithJointVolume).ceil();
    final int totalBricks = (netBricks * _brickWastage).ceil();

    // Pure brick volume (excluding mortar joints)
    final double pureBrickVolume = _brickLengthM * _brickWidthM * _brickHeightM;
    final double totalBrickVolume = netBricks * pureBrickVolume;

    // ── Mortar quantities ─────────────────────────────────────────────────────
    final double mortarVolume = wallVolume - totalBrickVolume;
    final double dryMortarVolume = mortarVolume * _mortarDryFactor;

    // Cement : Sand = cParts : sParts
    final int totalMortarParts = cParts + sParts;
    final double cementVolumeM3 = dryMortarVolume * cParts / totalMortarParts;
    final double cementWeightKg = cementVolumeM3 * _cementBulkDensityKgPerM3;
    final double cementBags = (cementWeightKg / _cementBagWeightKg)
        .ceilToDouble();
    final double actualCementWeightKg = cementBags * _cementBagWeightKg;
    final double sandVolumeM3 = dryMortarVolume * sParts / totalMortarParts;

    return BrickWallResult(
      wallVolume: _round(wallVolume),
      numberOfBricks: totalBricks,
      brickVolume: _round(totalBrickVolume),
      mortarVolume: _round(mortarVolume),
      dryMortarVolume: _round(dryMortarVolume),
      cementBags: cementBags,
      cementWeight: _round(actualCementWeightKg),
      sandVolume: _round(sandVolumeM3),
      mortarRatio: mortarRatioString,
    );
  }

  // ·····················································
  // 3. Plaster Materials
  // ·····················································

  /// Estimates the cement and sand quantities required for a plastering job.
  ///
  /// ### Algorithm (standard volume-proportioning method)
  ///
  /// 1. Wet volume             = area × thickness
  /// 2. Dry volume             = wet volume × 1.30
  /// 3. Parse mortar ratio     "1:N" → cement parts = 1, sand parts = N
  /// 4. Cement volume          = dry volume × 1/(1+N)
  /// 5. Cement weight          = cement volume × 1440
  /// 6. Cement bags            = ⌈ cement weight / 50 ⌉
  /// 7. Sand volume            = dry volume × N/(1+N)
  ///
  /// ### Parameters
  ///
  /// - [area]              : Surface area to be plastered, in m².
  /// - [thickness]         : Plaster coat thickness in metres (e.g. 0.012 for 12 mm).
  /// - [mortarRatioString] : Cement-sand ratio as "1:N" (e.g. "1:4" or "1:6").
  ///
  /// Throws [ArgumentError] for invalid dimensions or ratio strings.
  PlasterMaterialResult calculatePlasterMaterials({
    required double area,
    required double thickness,
    String mortarRatioString = '1:4',
  }) {
    // ── Input validation ─────────────────────────────────────────────────────
    _assertPositive(area, 'area');
    _assertPositive(thickness, 'thickness');
    final (int cParts, int sParts) = _parseMortarRatio(mortarRatioString);

    // ── Volume calculations ───────────────────────────────────────────────────
    final double wetVolume = area * thickness;
    final double dryVolume = wetVolume * _mortarDryFactor;

    // ── Cement ───────────────────────────────────────────────────────────────
    final int totalParts = cParts + sParts;
    final double cementVolumeM3 = dryVolume * cParts / totalParts;
    final double cementWeightKg = cementVolumeM3 * _cementBulkDensityKgPerM3;
    final double cementBags = (cementWeightKg / _cementBagWeightKg)
        .ceilToDouble();
    final double actualCementWeightKg = cementBags * _cementBagWeightKg;

    // ── Sand ─────────────────────────────────────────────────────────────────
    final double sandVolumeM3 = dryVolume * sParts / totalParts;

    return PlasterMaterialResult(
      plasterArea: _round(area),
      thickness: thickness,
      wetVolume: _round(wetVolume),
      dryVolume: _round(dryVolume),
      cementBags: cementBags,
      cementWeight: _round(actualCementWeightKg),
      sandVolume: _round(sandVolumeM3),
      mortarRatio: mortarRatioString,
      dryVolumeFactor: _mortarDryFactor,
    );
  }

  // -------------------------------------------------------------------------
  // Private helpers
  // -------------------------------------------------------------------------

  /// Parses a mortar ratio string of the form "1:N" and returns
  /// (cementParts, sandParts) as a record.
  ///
  /// Throws [ArgumentError] if the string cannot be parsed or produces
  /// non-positive values.
  (int, int) _parseMortarRatio(String ratio) {
    final parts = ratio.trim().split(':');
    if (parts.length != 2) {
      throw ArgumentError(
        'Invalid mortar ratio "$ratio". Expected format "1:N" (e.g. "1:4").',
      );
    }
    final int? c = int.tryParse(parts[0].trim());
    final int? s = int.tryParse(parts[1].trim());
    if (c == null || s == null || c <= 0 || s <= 0) {
      throw ArgumentError(
        'Mortar ratio parts must be positive integers. Got "$ratio".',
      );
    }
    return (c, s);
  }

  /// Asserts that [value] is strictly positive.
  void _assertPositive(double value, String name) {
    if (value <= 0) {
      throw ArgumentError.value(
        value,
        name,
        '$name must be greater than zero.',
      );
    }
  }

  /// Asserts that [value] is zero or positive.
  void _assertNonNegative(double value, String name) {
    if (value < 0) {
      throw ArgumentError.value(value, name, '$name must be zero or positive.');
    }
  }

  /// Rounds [value] to 6 decimal places to remove floating-point noise
  /// while preserving engineering precision.
  double _round(double value) => (value * 1e6).roundToDouble() / 1e6;
}
