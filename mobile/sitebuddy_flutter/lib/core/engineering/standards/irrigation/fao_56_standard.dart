/// lib/core/engineering/standards/irrigation/fao_56_standard.dart
///
/// FAO-56 based irrigation standard.
/// 
/// PURPOSE:
/// - Implements FAO Penman-Monteith method for ET₀
/// - Provides crop coefficients (Kc) for water requirement
/// - Supports scenario-based irrigation design
/// - Centralizes all scenario factor engineering rules
library;

import 'dart:math' as math;
import 'package:site_buddy/features/water/irrigation/domain/models/crop_models.dart';
import 'package:site_buddy/features/water/irrigation/domain/models/soil_models.dart';
import 'package:site_buddy/features/water/irrigation/domain/models/scenario_models.dart';

/// Irrigation standard based on FAO-56 guidelines
/// 
/// This class centralizes all engineering rules including:
/// - Scenario factors (display names, descriptions, water application factors)
/// - Crop coefficients (Kc)
/// - Evapotranspiration calculations
class FAO56Standard {
  /// Standard identifier
  String get codeIdentifier => 'FAO:56';

  // =========================================================================
  // SCENARIO FACTORS - All scenario-related engineering rules
  // =========================================================================
  
  /// Get display name for irrigation scenario
  String getScenarioDisplayName(IrrigationScenario scenario) {
    switch (scenario) {
      case IrrigationScenario.conservative:
        return 'Conservative (Safe)';
      case IrrigationScenario.standard:
        return 'Standard (Balanced)';
      case IrrigationScenario.optimized:
        return 'Optimized (Water-Saving)';
    }
  }

  /// Get description for irrigation scenario
  String getScenarioDescription(IrrigationScenario scenario) {
    switch (scenario) {
      case IrrigationScenario.conservative:
        return 'Higher water application with safety margins. Recommended for water-abundant areas.';
      case IrrigationScenario.standard:
        return 'Per FAO-56 guidelines. Balanced approach between water use and crop needs.';
      case IrrigationScenario.optimized:
        return 'Water-efficient design for water-scarce areas. Best with drip/sprinkler systems.';
    }
  }

  /// Water application factor for irrigation scenario.
  /// 
  /// - Conservative: +15% water (1.15)
  /// - Standard: Base FAO-56 (1.0)
  /// - Optimized: -15% water (0.85)
  double getScenarioWaterFactor(IrrigationScenario scenario) {
    switch (scenario) {
      case IrrigationScenario.conservative:
        return 1.15;
      case IrrigationScenario.standard:
        return 1.0;
      case IrrigationScenario.optimized:
        return 0.85;
    }
  }

  // =========================================================================
  // CROP GROWTH STAGE FACTORS
  // =========================================================================
  
  /// Duration in days (typical values per FAO-56)
  int getGrowthStageDuration(CropGrowthStage stage) {
    switch (stage) {
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
  double getKcMultiplier(CropGrowthStage stage) {
    switch (stage) {
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

  // =========================================================================
  // SOIL TYPE FACTORS
  // =========================================================================
  
  /// Field capacity (% volume)
  double getFieldCapacity(SoilType soilType) {
    switch (soilType) {
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
  double getWiltingPoint(SoilType soilType) {
    switch (soilType) {
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

  /// Infiltration rate (mm/hr)
  double getInfiltrationRate(SoilType soilType) {
    switch (soilType) {
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
  double getBulkDensity(SoilType soilType) {
    switch (soilType) {
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
  double getMaxRootingDepth(SoilType soilType) {
    switch (soilType) {
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

  // =========================================================================
  // IRRIGATION METHOD FACTORS
  // =========================================================================
  
  /// Get display name for irrigation method
  String getIrrigationMethodDisplayName(IrrigationMethod method) {
    switch (method) {
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
  double getIrrigationEfficiency(IrrigationMethod method) {
    switch (method) {
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
  double getApplicationRate(IrrigationMethod method) {
    switch (method) {
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
  double getWaterSavingFactor(IrrigationMethod method) {
    switch (method) {
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

  /// Calculate reference evapotranspiration (ET₀) using Penman-Monteith equation.
  /// 
  /// [temperature] - Mean daily temperature (°C)
  /// [humidity] - Mean relative humidity (%)
  /// [windSpeed] - Mean daily wind speed (m/s)
  /// [sunshineHours] - Actual sunshine hours per day
  /// [solarRadiation] - Solar radiation (MJ/m²/day)
  double calculateET0(ClimateData climate) {
    // Simplified Hargreaves-Samani equation for estimation
    // More accurate than full PM in data-limited conditions
    
    // Saturation vapor pressure (kPa)
    final es = 0.6108 * math.exp((17.27 * climate.temperature) / (climate.temperature + 237.3));
    
    // Actual vapor pressure (kPa)
    final ea = es * (climate.humidity / 100);
    
    // Slope of saturation vapor pressure curve (kPa/°C)
    final delta = (4098 * es) / math.pow(climate.temperature + 237.3, 2);
    
    // Psychrometric constant (kPa/°C)
    final gamma = 0.0665; // At sea level
    
    // Net radiation (MJ/m²/day) - simplified
    final rn = climate.solarRadiation * 0.77;
    
    // Soil heat flux (MJ/m²/day) - assumed zero for daily
    final g = 0.0;
    
    // Wind speed at 2m height adjustment
    final u2 = climate.windSpeed * (4.87 / math.log(67.8 * 10 - 5.42));
    
    // Penman-Monteith equation
    final numerator = 0.408 * delta * (rn - g) + gamma * (900 / (climate.temperature + 273)) * u2 * (es - ea);
    final denominator = delta + gamma * (1 + 0.34 * u2);
    
    return numerator / denominator; // mm/day
  }

  /// Get crop coefficient (Kc) for a crop at a given growth stage.
  double getCropCoefficient(CropType crop, CropGrowthStage stage) {
    // FAO-56 Kc values for different crops and stages
    final kcValues = _getKcTable();
    return kcValues[crop]?[stage] ?? 1.0; // Default to 1.0 if unknown
  }

  /// Get Kc table for all crops
  Map<CropType, Map<CropGrowthStage, double>> _getKcTable() {
    return {
      CropType.wheat: {
        CropGrowthStage.initial: 0.35,
        CropGrowthStage.development: 0.75,
        CropGrowthStage.midSeason: 1.15,
        CropGrowthStage.lateSeason: 0.40,
      },
      CropType.rice: {
        CropGrowthStage.initial: 0.35,
        CropGrowthStage.development: 0.75,
        CropGrowthStage.midSeason: 1.20,
        CropGrowthStage.lateSeason: 0.90,
      },
      CropType.maize: {
        CropGrowthStage.initial: 0.30,
        CropGrowthStage.development: 0.70,
        CropGrowthStage.midSeason: 1.20,
        CropGrowthStage.lateSeason: 0.60,
      },
      CropType.cotton: {
        CropGrowthStage.initial: 0.35,
        CropGrowthStage.development: 0.75,
        CropGrowthStage.midSeason: 1.15,
        CropGrowthStage.lateSeason: 0.75,
      },
      CropType.sugarcane: {
        CropGrowthStage.initial: 0.40,
        CropGrowthStage.development: 0.80,
        CropGrowthStage.midSeason: 1.25,
        CropGrowthStage.lateSeason: 0.90,
      },
      CropType.soybean: {
        CropGrowthStage.initial: 0.35,
        CropGrowthStage.development: 0.75,
        CropGrowthStage.midSeason: 1.10,
        CropGrowthStage.lateSeason: 0.60,
      },
      CropType.groundnut: {
        CropGrowthStage.initial: 0.40,
        CropGrowthStage.development: 0.80,
        CropGrowthStage.midSeason: 1.10,
        CropGrowthStage.lateSeason: 0.70,
      },
      CropType.potato: {
        CropGrowthStage.initial: 0.35,
        CropGrowthStage.development: 0.75,
        CropGrowthStage.midSeason: 1.15,
        CropGrowthStage.lateSeason: 0.75,
      },
      CropType.tomato: {
        CropGrowthStage.initial: 0.40,
        CropGrowthStage.development: 0.75,
        CropGrowthStage.midSeason: 1.15,
        CropGrowthStage.lateSeason: 0.80,
      },
      CropType.onion: {
        CropGrowthStage.initial: 0.40,
        CropGrowthStage.development: 0.80,
        CropGrowthStage.midSeason: 1.05,
        CropGrowthStage.lateSeason: 0.75,
      },
      CropType.banana: {
        CropGrowthStage.initial: 0.50,
        CropGrowthStage.development: 0.90,
        CropGrowthStage.midSeason: 1.20,
        CropGrowthStage.lateSeason: 1.00,
      },
      CropType.citrus: {
        CropGrowthStage.initial: 0.55,
        CropGrowthStage.development: 0.80,
        CropGrowthStage.midSeason: 0.95,
        CropGrowthStage.lateSeason: 0.80,
      },
      CropType.grapes: {
        CropGrowthStage.initial: 0.35,
        CropGrowthStage.development: 0.70,
        CropGrowthStage.midSeason: 0.90,
        CropGrowthStage.lateSeason: 0.70,
      },
      CropType.mango: {
        CropGrowthStage.initial: 0.50,
        CropGrowthStage.development: 0.80,
        CropGrowthStage.midSeason: 1.00,
        CropGrowthStage.lateSeason: 0.80,
      },
    };
  }

  /// Calculate crop evapotranspiration (ETc) = ET₀ × Kc
  double calculateETc(double et0, double kc) {
    return et0 * kc;
  }

  /// Calculate effective rainfall using USDA SCS method.
  double calculateEffectiveRainfall(double totalRainfall) {
    // USDA Natural Resources Conservation Service method
    if (totalRainfall <= 250) {
      return totalRainfall * 0.6;
    } else if (totalRainfall <= 500) {
      return 150 + (totalRainfall - 250) * 0.25;
    } else {
      return 212.5 + (totalRainfall - 500) * 0.10;
    }
  }

  /// Calculate gross irrigation requirement considering efficiency.
  double calculateGrossIrrigation({
    required double netIrrigation,
    required IrrigationMethod method,
  }) {
    final efficiency = getIrrigationEfficiency(method) / 100;
    return netIrrigation / efficiency;
  }

  /// Calculate discharge required for given area and irrigation interval.
  double calculateDischargeRequired({
    required double volumeRequired, // m³
    required double area, // hectares
    required int irrigationHours, // hours available
  }) {
    // Q = V / (A * t)
    // Q in m³/s, V in m³, A in m², t in seconds
    final areaM2 = area * 10000; // Convert ha to m²
    final timeSeconds = irrigationHours * 3600;
    return volumeRequired / (areaM2 * timeSeconds);
  }

  /// Calculate seepage loss in canal (m³/s per km).
  double calculateSeepageLoss({
    required double wettedPerimeter, // m
    required double hydraulicRadius, // m
    required double permeability, // m/day
  }) {
    // Simplified seepage calculation using Darcy's law
    // Seepage = K * A / L = K * wettedPerimeter * hydraulicRadius
    final seepageRate = (permeability / 1000) * wettedPerimeter / 100; // Convert to m³/s per m
    return seepageRate * 1000; // per km
  }

  /// Evaluate water adequacy for given crop and climate.
  String evaluateWaterAdequacy(double waterAvailable, double waterRequired) {
    final ratio = waterAvailable / waterRequired;
    if (ratio >= 1.2) {
      return 'EXCELLENT: Water supply exceeds requirement by >20%';
    } else if (ratio >= 1.0) {
      return 'ADEQUATE: Water supply meets requirement';
    } else if (ratio >= 0.8) {
      return 'MARGINAL: Water supply is 80-100% of requirement';
    } else if (ratio >= 0.6) {
      return 'INADEQUATE: Significant water deficit expected';
    } else {
      return 'CRITICAL: Severe water shortage will impact yield';
    }
  }
}
