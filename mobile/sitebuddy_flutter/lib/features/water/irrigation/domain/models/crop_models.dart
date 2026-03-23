/// lib/features/water/irrigation/domain/models/crop_models.dart
///
/// Crop-related domain models for irrigation engineering.
///
/// PURPOSE:
/// - Crop water requirement calculations (FAO-based)
/// - Growth stage modeling
/// - Climate data handling
library;

/// Crop types for water requirement calculations
enum CropType {
  wheat,
  rice,
  maize,
  cotton,
  sugarcane,
  soybean,
  groundnut,
  potato,
  tomato,
  onion,
  banana,
  citrus,
  grapes,
  mango,
}

/// Growth stages for crops
enum CropGrowthStage {
  initial,
  development,
  midSeason,
  lateSeason,
}

/// Climate data for water requirement calculation
class ClimateData {
  /// Mean daily temperature (°C)
  final double temperature;
  
  /// Mean relative humidity (%)
  final double humidity;
  
  /// Mean daily wind speed (m/s)
  final double windSpeed;
  
  /// Actual sunshine hours per day
  final double sunshineHours;
  
  /// Solar radiation (MJ/m²/day)
  final double solarRadiation;
  
  /// Rainfall per period (mm)
  final double rainfall;

  const ClimateData({
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.sunshineHours,
    required this.solarRadiation,
    required this.rainfall,
  });

  /// Creates a copy with optional parameter overrides
  ClimateData copyWith({
    double? temperature,
    double? humidity,
    double? windSpeed,
    double? sunshineHours,
    double? solarRadiation,
    double? rainfall,
  }) {
    return ClimateData(
      temperature: temperature ?? this.temperature,
      humidity: humidity ?? this.humidity,
      windSpeed: windSpeed ?? this.windSpeed,
      sunshineHours: sunshineHours ?? this.sunshineHours,
      solarRadiation: solarRadiation ?? this.solarRadiation,
      rainfall: rainfall ?? this.rainfall,
    );
  }

  Map<String, dynamic> toMap() => {
    'temperature': temperature,
    'humidity': humidity,
    'windSpeed': windSpeed,
    'sunshineHours': sunshineHours,
    'solarRadiation': solarRadiation,
    'rainfall': rainfall,
  };

  /// Create from map
  factory ClimateData.fromMap(Map<String, dynamic> map) {
    return ClimateData(
      temperature: (map['temperature'] as num).toDouble(),
      humidity: (map['humidity'] as num).toDouble(),
      windSpeed: (map['windSpeed'] as num).toDouble(),
      sunshineHours: (map['sunshineHours'] as num).toDouble(),
      solarRadiation: (map['solarRadiation'] as num).toDouble(),
      rainfall: (map['rainfall'] as num).toDouble(),
    );
  }
}

/// Crop water requirement result
class CropWaterRequirement {
  final CropType cropType;
  final CropGrowthStage growthStage;
  
  /// Area in hectares
  final double area;
  
  final ClimateData climate;
  
  /// ET₀ in mm/day
  final double evapotranspiration;
  
  /// ETc in mm/day
  final double cropEvapotranspiration;
  
  /// Liters/day
  final double dailyWaterNeed;
  
  /// m³/season
  final double seasonalWaterNeed;
  
  /// After rainfall consideration
  final double irrigationWaterNeed;
  
  /// Considering efficiency
  final double grossIrrigation;

  const CropWaterRequirement({
    required this.cropType,
    required this.growthStage,
    required this.area,
    required this.climate,
    required this.evapotranspiration,
    required this.cropEvapotranspiration,
    required this.dailyWaterNeed,
    required this.seasonalWaterNeed,
    required this.irrigationWaterNeed,
    required this.grossIrrigation,
  });

  Map<String, dynamic> toMap() => {
    'cropType': cropType.name,
    'growthStage': growthStage.name,
    'area': area,
    'evapotranspiration': evapotranspiration,
    'cropEvapotranspiration': cropEvapotranspiration,
    'dailyWaterNeed': dailyWaterNeed,
    'seasonalWaterNeed': seasonalWaterNeed,
    'irrigationWaterNeed': irrigationWaterNeed,
    'grossIrrigation': grossIrrigation,
  };
}

// =========================================================================
// EXTENSIONS - Backward compatibility layer (delegates to FAO56Standard)
// =========================================================================

/// Extension for growth stage display names
extension CropGrowthStageExtension on CropGrowthStage {
  String get displayName {
    switch (this) {
      case CropGrowthStage.initial:
        return 'Initial';
      case CropGrowthStage.development:
        return 'Development';
      case CropGrowthStage.midSeason:
        return 'Mid-Season';
      case CropGrowthStage.lateSeason:
        return 'Late-Season';
    }
  }

  /// Duration in days (typical values)
  int get typicalDuration {
    switch (this) {
      case CropGrowthStage.initial:
        return 20;
      case CropGrowthStage.development:
        return 30;
      case CropGrowthStage.midSeason:
        return 40;
      case CropGrowthStage.lateSeason:
        return 20;
    }
  }

  /// Kc factor multiplier (FAO-56 reference values)
  double get kcMultiplier {
    switch (this) {
      case CropGrowthStage.initial:
        return 0.35;
      case CropGrowthStage.development:
        return 0.75;
      case CropGrowthStage.midSeason:
        return 1.15;
      case CropGrowthStage.lateSeason:
        return 0.90;
    }
  }
}
