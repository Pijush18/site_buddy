/// lib/features/water/irrigation/domain/models/soil_models.dart
///
/// Soil-related domain models for irrigation engineering.
///
/// PURPOSE:
/// - Soil classification and properties
/// - Irrigation method definitions
/// - Soil water balance modeling
library;

/// Soil types for irrigation modeling
enum SoilType {
  clay,
  siltyClay,
  sandyClay,
  loam,
  siltLoam,
  sandyLoam,
  sand,
  gravel,
}

/// Irrigation method types
enum IrrigationMethod {
  flood,
  furrow,
  sprinkler,
  drip,
  centerPivot,
}

/// Soil irrigation parameters
class SoilIrrigationModel {
  final SoilType soilType;
  
  /// Effective rainfall (mm)
  final double effectiveRainfall;
  
  /// Field capacity (% volume)
  final double fieldCapacity;
  
  /// Wilting point (% volume)
  final double wiltingPoint;
  
  /// Available water (mm/m)
  final double availableWater;
  
  /// Infiltration rate (mm/hr)
  final double infiltrationRate;
  
  /// Root zone depth (m)
  final double rootZoneDepth;
  
  /// Management Allowable Depletion (MAD) as fraction (0-1)
  final double depletionAllowable;

  const SoilIrrigationModel({
    required this.soilType,
    required this.effectiveRainfall,
    required this.fieldCapacity,
    required this.wiltingPoint,
    required this.availableWater,
    required this.infiltrationRate,
    required this.rootZoneDepth,
    required this.depletionAllowable,
  });

  /// Calculate total available water in root zone (mm)
  double get totalAvailableWater => availableWater * rootZoneDepth;

  /// Calculate readily available water (mm)
  double get readilyAvailableWater => totalAvailableWater * depletionAllowable;

  /// Estimate irrigation interval based on daily crop water need (days)
  double irrigationInterval(double dailyETc) {
    if (dailyETc <= 0) return 999;
    return readilyAvailableWater / dailyETc;
  }

  Map<String, dynamic> toMap() => {
    'soilType': soilType.name,
    'effectiveRainfall': effectiveRainfall,
    'fieldCapacity': fieldCapacity,
    'wiltingPoint': wiltingPoint,
    'availableWater': availableWater,
    'infiltrationRate': infiltrationRate,
    'rootZoneDepth': rootZoneDepth,
    'depletionAllowable': depletionAllowable,
  };

  /// Create from map
  factory SoilIrrigationModel.fromMap(Map<String, dynamic> map) {
    return SoilIrrigationModel(
      soilType: SoilType.values.firstWhere(
        (e) => e.name == map['soilType'],
        orElse: () => SoilType.loam,
      ),
      effectiveRainfall: (map['effectiveRainfall'] as num).toDouble(),
      fieldCapacity: (map['fieldCapacity'] as num).toDouble(),
      wiltingPoint: (map['wiltingPoint'] as num).toDouble(),
      availableWater: (map['availableWater'] as num).toDouble(),
      infiltrationRate: (map['infiltrationRate'] as num).toDouble(),
      rootZoneDepth: (map['rootZoneDepth'] as num).toDouble(),
      depletionAllowable: (map['depletionAllowable'] as num).toDouble(),
    );
  }

  /// Creates a copy with optional parameter overrides
  SoilIrrigationModel copyWith({
    SoilType? soilType,
    double? effectiveRainfall,
    double? fieldCapacity,
    double? wiltingPoint,
    double? availableWater,
    double? infiltrationRate,
    double? rootZoneDepth,
    double? depletionAllowable,
  }) {
    return SoilIrrigationModel(
      soilType: soilType ?? this.soilType,
      effectiveRainfall: effectiveRainfall ?? this.effectiveRainfall,
      fieldCapacity: fieldCapacity ?? this.fieldCapacity,
      wiltingPoint: wiltingPoint ?? this.wiltingPoint,
      availableWater: availableWater ?? this.availableWater,
      infiltrationRate: infiltrationRate ?? this.infiltrationRate,
      rootZoneDepth: rootZoneDepth ?? this.rootZoneDepth,
      depletionAllowable: depletionAllowable ?? this.depletionAllowable,
    );
  }
}

// =========================================================================
// EXTENSIONS - Backward compatibility layer (delegates to FAO56Standard)
// =========================================================================

/// Extension for soil type properties
extension SoilTypeExtension on SoilType {
  String get displayName {
    switch (this) {
      case SoilType.clay:
        return 'Clay';
      case SoilType.siltyClay:
        return 'Silty Clay';
      case SoilType.sandyClay:
        return 'Sandy Clay';
      case SoilType.loam:
        return 'Loam';
      case SoilType.siltLoam:
        return 'Silt Loam';
      case SoilType.sandyLoam:
        return 'Sandy Loam';
      case SoilType.sand:
        return 'Sand';
      case SoilType.gravel:
        return 'Gravel';
    }
  }

  /// Field capacity (% volume)
  double get fieldCapacity {
    switch (this) {
      case SoilType.clay:
        return 36.0;
      case SoilType.siltyClay:
        return 34.0;
      case SoilType.sandyClay:
        return 28.0;
      case SoilType.loam:
        return 27.0;
      case SoilType.siltLoam:
        return 24.0;
      case SoilType.sandyLoam:
        return 18.0;
      case SoilType.sand:
        return 10.0;
      case SoilType.gravel:
        return 8.0;
    }
  }

  /// Wilting point (% volume)
  double get wiltingPoint {
    switch (this) {
      case SoilType.clay:
        return 18.0;
      case SoilType.siltyClay:
        return 16.0;
      case SoilType.sandyClay:
        return 14.0;
      case SoilType.loam:
        return 12.0;
      case SoilType.siltLoam:
        return 10.0;
      case SoilType.sandyLoam:
        return 6.0;
      case SoilType.sand:
        return 4.0;
      case SoilType.gravel:
        return 3.0;
    }
  }

  /// Available water capacity (field capacity - wilting point)
  double get availableWater => fieldCapacity - wiltingPoint;

  /// Infiltration rate (mm/hr)
  double get infiltrationRate {
    switch (this) {
      case SoilType.clay:
        return 5.0;
      case SoilType.siltyClay:
        return 8.0;
      case SoilType.sandyClay:
        return 15.0;
      case SoilType.loam:
        return 25.0;
      case SoilType.siltLoam:
        return 15.0;
      case SoilType.sandyLoam:
        return 30.0;
      case SoilType.sand:
        return 50.0;
      case SoilType.gravel:
        return 75.0;
    }
  }

  /// Bulk density (g/cm³) - typical values
  double get bulkDensity {
    switch (this) {
      case SoilType.clay:
        return 1.30;
      case SoilType.siltyClay:
        return 1.35;
      case SoilType.sandyClay:
        return 1.45;
      case SoilType.loam:
        return 1.50;
      case SoilType.siltLoam:
        return 1.40;
      case SoilType.sandyLoam:
        return 1.60;
      case SoilType.sand:
        return 1.65;
      case SoilType.gravel:
        return 1.70;
    }
  }

  /// Maximum rooting depth (m) - typical for field crops
  double get maxRootingDepth {
    switch (this) {
      case SoilType.clay:
        return 0.8;
      case SoilType.siltyClay:
        return 0.9;
      case SoilType.sandyClay:
        return 1.0;
      case SoilType.loam:
        return 1.2;
      case SoilType.siltLoam:
        return 1.1;
      case SoilType.sandyLoam:
        return 1.3;
      case SoilType.sand:
        return 1.5;
      case SoilType.gravel:
        return 1.0;
    }
  }
}

/// Extension for irrigation method properties
extension IrrigationMethodExtension on IrrigationMethod {
  String get displayName {
    switch (this) {
      case IrrigationMethod.flood:
        return 'Flood/Basin';
      case IrrigationMethod.furrow:
        return 'Furrow';
      case IrrigationMethod.sprinkler:
        return 'Sprinkler';
      case IrrigationMethod.drip:
        return 'Drip/Trickle';
      case IrrigationMethod.centerPivot:
        return 'Center Pivot';
    }
  }

  /// Application efficiency (%)
  double get efficiency {
    switch (this) {
      case IrrigationMethod.flood:
        return 50.0;
      case IrrigationMethod.furrow:
        return 60.0;
      case IrrigationMethod.sprinkler:
        return 75.0;
      case IrrigationMethod.drip:
        return 90.0;
      case IrrigationMethod.centerPivot:
        return 80.0;
    }
  }

  /// Typical application rate (mm/hr)
  double get applicationRate {
    switch (this) {
      case IrrigationMethod.flood:
        return 10.0;
      case IrrigationMethod.furrow:
        return 8.0;
      case IrrigationMethod.sprinkler:
        return 5.0;
      case IrrigationMethod.drip:
        return 2.0;
      case IrrigationMethod.centerPivot:
        return 6.0;
    }
  }

  /// Water requirement reduction factor (compared to flood)
  double get waterSavingFactor {
    switch (this) {
      case IrrigationMethod.flood:
        return 1.0;
      case IrrigationMethod.furrow:
        return 0.85;
      case IrrigationMethod.sprinkler:
        return 0.70;
      case IrrigationMethod.drip:
        return 0.55;
      case IrrigationMethod.centerPivot:
        return 0.65;
    }
  }
}
