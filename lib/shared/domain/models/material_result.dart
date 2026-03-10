/// FILE HEADER
/// ----------------------------------------------
/// File: material_result.dart
/// Feature: calculator
/// Layer: domain
///
/// PURPOSE:
/// Represents the calculated result for concrete volume and required materials.
///
/// RESPONSIBILITIES:
/// - Holds final calculated volume, dry volume, and required cement bags.
///
/// DEPENDENCIES:
/// - none
///
/// FUTURE IMPROVEMENTS:
/// - Add fields for sand and aggregate calculations.
///
/// ----------------------------------------------
library;


/// CLASS: MaterialResult
/// PURPOSE: Data entity representing the final calculation for concrete materials.
/// WHY: To provide a structured and strongly-typed result from the usecase back to the presentation layer.
class MaterialResult {
  final double volume;
  final double dryVolume;
  final int cementBags;
  final String? unit;

  const MaterialResult({
    required this.volume,
    required this.dryVolume,
    required this.cementBags,
    this.unit,
  });

  MaterialResult copyWith({
    double? volume,
    double? dryVolume,
    int? cementBags,
    String? unit,
  }) {
    return MaterialResult(
      volume: volume ?? this.volume,
      dryVolume: dryVolume ?? this.dryVolume,
      cementBags: cementBags ?? this.cementBags,
      unit: unit ?? this.unit,
    );
  }

  @override
  String toString() {
    final u = unit ?? 'm³';
    return 'MaterialResult(volume: ${volume.toStringAsFixed(2)} $u, dryVolume: ${dryVolume.toStringAsFixed(2)} $u, cementBags: $cementBags)';
  }

  /// METHOD: empty
  /// PURPOSE: Returns an empty result before any calculations have been performed.
  /// PARAMETERS: None
  /// RETURNS:
  /// - MaterialResult with all zero values.
  /// LOGIC:
  /// - Instantiates a default result structure.
  factory MaterialResult.empty() {
    return const MaterialResult(volume: 0, dryVolume: 0, cementBags: 0);
  }
}
