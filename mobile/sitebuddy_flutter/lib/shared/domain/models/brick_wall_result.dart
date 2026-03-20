// lib/models/brick_wall_result.dart
//
// Immutable result model returned by [MaterialEstimationService.calculateBrickWallMaterials].
// Covers both brick masonry and the mortar (cement + sand) needed for jointing.
//
// Conventions:
//   • All volumes in cubic metres (m³), unless explicitly noted.
//   • Cement expressed in standard 50-kg bags for field use.
//   • Mortar ratio is nominal (e.g. 1:6 → 1 part cement : 6 parts sand).

import 'package:flutter/foundation.dart';

/// Holds every quantity produced by a brick wall material estimation.
///
/// Instances are immutable value objects. Use [copyWith] to derive variants.
///
/// Example:
/// ```dart
/// final result = MaterialEstimationService().calculateBrickWallMaterials(
///   length: 10.0, height: 3.0, thickness: 0.23,
///   mortarRatio: '1:6',
/// );
/// print('Bricks needed: ${result.numberOfBricks}');
/// ```
@immutable
class BrickWallResult {
  // -------------------------------------------------------------------------
  // Brick quantities
  // -------------------------------------------------------------------------

  /// Gross wall volume (length × height × thickness), in m³.
  final double wallVolume;

  /// Number of bricks required (including a standard 5% wastage allowance).
  final int numberOfBricks;

  /// Volume occupied by bricks alone (without mortar joints), in m³.
  final double brickVolume;

  // -------------------------------------------------------------------------
  // Mortar quantities
  // -------------------------------------------------------------------------

  /// Net volume of mortar in the wall (wallVolume − brickVolume), in m³.
  final double mortarVolume;

  /// Dry mortar volume after applying the 1.3 bulking factor, in m³.
  final double dryMortarVolume;

  /// Number of 50-kg cement bags required for mortar.
  final double cementBags;

  /// Weight of cement in kg (= cementBags × 50).
  final double cementWeight;

  /// Volume of sand required for mortar, in m³.
  final double sandVolume;

  // -------------------------------------------------------------------------
  // Supporting information
  // -------------------------------------------------------------------------

  /// Mortar mix ratio label as entered by the caller (e.g. "1:6").
  final String mortarRatio;

  /// Standard brick size used in calculations, in mm (L × W × H).
  /// Defaults to the IS modular brick: 190 × 90 × 90 mm.
  final String brickSize;

  /// Mortar joint thickness used in calculations, in mm. Defaults to 10 mm.
  final double mortarJointThickness;

  // -------------------------------------------------------------------------
  // Constructor
  // -------------------------------------------------------------------------

  const BrickWallResult({
    required this.wallVolume,
    required this.numberOfBricks,
    required this.brickVolume,
    required this.mortarVolume,
    required this.dryMortarVolume,
    required this.cementBags,
    required this.cementWeight,
    required this.sandVolume,
    required this.mortarRatio,
    this.brickSize = '190 × 90 × 90 mm',
    this.mortarJointThickness = 10.0,
  });

  // -------------------------------------------------------------------------
  // Utilities
  // -------------------------------------------------------------------------

  /// Creates a copy of this result with the given fields replaced.
  BrickWallResult copyWith({
    double? wallVolume,
    int? numberOfBricks,
    double? brickVolume,
    double? mortarVolume,
    double? dryMortarVolume,
    double? cementBags,
    double? cementWeight,
    double? sandVolume,
    String? mortarRatio,
    String? brickSize,
    double? mortarJointThickness,
  }) {
    return BrickWallResult(
      wallVolume: wallVolume ?? this.wallVolume,
      numberOfBricks: numberOfBricks ?? this.numberOfBricks,
      brickVolume: brickVolume ?? this.brickVolume,
      mortarVolume: mortarVolume ?? this.mortarVolume,
      dryMortarVolume: dryMortarVolume ?? this.dryMortarVolume,
      cementBags: cementBags ?? this.cementBags,
      cementWeight: cementWeight ?? this.cementWeight,
      sandVolume: sandVolume ?? this.sandVolume,
      mortarRatio: mortarRatio ?? this.mortarRatio,
      brickSize: brickSize ?? this.brickSize,
      mortarJointThickness: mortarJointThickness ?? this.mortarJointThickness,
    );
  }

  /// Converts the result to a plain map (e.g. for Hive persistence or JSON).
  Map<String, dynamic> toMap() => {
    'wallVolume': wallVolume,
    'numberOfBricks': numberOfBricks,
    'brickVolume': brickVolume,
    'mortarVolume': mortarVolume,
    'dryMortarVolume': dryMortarVolume,
    'cementBags': cementBags,
    'cementWeight': cementWeight,
    'sandVolume': sandVolume,
    'mortarRatio': mortarRatio,
    'brickSize': brickSize,
    'mortarJointThickness': mortarJointThickness,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BrickWallResult &&
          runtimeType == other.runtimeType &&
          wallVolume == other.wallVolume &&
          numberOfBricks == other.numberOfBricks &&
          mortarVolume == other.mortarVolume &&
          cementBags == other.cementBags &&
          sandVolume == other.sandVolume &&
          mortarRatio == other.mortarRatio;

  @override
  int get hashCode => Object.hash(
    wallVolume,
    numberOfBricks,
    mortarVolume,
    cementBags,
    sandVolume,
    mortarRatio,
  );

  @override
  String toString() =>
      'BrickWallResult('
      'bricks: $numberOfBricks, '
      'cement: ${cementBags.toStringAsFixed(1)} bags, '
      'sand: ${sandVolume.toStringAsFixed(3)} m³, '
      'mortar: $mortarRatio'
      ')';
}



