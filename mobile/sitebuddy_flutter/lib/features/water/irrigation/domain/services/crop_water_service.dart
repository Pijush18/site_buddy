/// lib/features/water/irrigation/domain/services/crop_water_service.dart
///
/// Crop water requirement calculation service.
/// 
/// PURPOSE:
/// - Calculate crop evapotranspiration using FAO-56
/// - Compute daily and seasonal water requirements
/// - Apply scenario factors for different irrigation strategies
///
/// DOMAIN PURITY:
/// - All calculations performed here
/// - No Pro gating (handled in Application layer)
library;

import 'package:site_buddy/core/engineering/standards/irrigation/fao_56_standard.dart';
import 'package:site_buddy/features/water/irrigation/domain/models/irrigation_models.dart';

/// SERVICE: CropWaterService
/// PURPOSE: Handles crop water requirement calculations.
class CropWaterService {
  final FAO56Standard standard;

  CropWaterService(this.standard);

  /// Calculate complete crop water requirement.
  /// 
  /// [cropType] - Type of crop
  /// [growthStage] - Current growth stage
  /// [area] - Cultivation area in hectares
  /// [climate] - Climate data
  /// [effectiveRainfall] - Effective rainfall in mm
  CropWaterRequirement calculateWaterRequirement({
    required CropType cropType,
    required CropGrowthStage growthStage,
    required double area,
    required ClimateData climate,
    required double effectiveRainfall,
  }) {
    // 1. Calculate reference evapotranspiration (ET₀)
    final et0 = standard.calculateET0(climate);

    // 2. Get crop coefficient (Kc)
    final kc = standard.getCropCoefficient(cropType, growthStage);

    // 3. Calculate crop evapotranspiration (ETc)
    final etc = standard.calculateETc(et0, kc);

    // 4. Calculate net irrigation requirement (mm/day)
    // Net = ETc - Effective Rainfall (simplified daily)
    final effectiveRainfallDaily = effectiveRainfall / 30; // Approximate daily
    final netIrrigationDaily = (etc - effectiveRainfallDaily).clamp(0, double.infinity);

    // 5. Convert to volume
    // Area in hectares, depth in mm -> volume in liters
    // 1 ha * 1 mm = 10,000 liters = 10 m³
    final dailyWaterNeed = netIrrigationDaily * area * 10; // m³/day

    // 6. Seasonal water need (assuming 30 days per stage * typical duration)
    final stageDays = growthStage.typicalDuration;
    final seasonalWaterNeed = dailyWaterNeed * stageDays;

    // 7. Apply default efficiency for flood irrigation
    final grossIrrigation = seasonalWaterNeed / 0.5; // 50% efficiency

    return CropWaterRequirement(
      cropType: cropType,
      growthStage: growthStage,
      area: area,
      climate: climate,
      evapotranspiration: et0,
      cropEvapotranspiration: etc,
      dailyWaterNeed: dailyWaterNeed,
      seasonalWaterNeed: seasonalWaterNeed,
      irrigationWaterNeed: seasonalWaterNeed,
      grossIrrigation: grossIrrigation,
    );
  }

  /// Calculate water requirement for all growth stages of a crop.
  Map<CropGrowthStage, CropWaterRequirement> calculateAllStages({
    required CropType cropType,
    required double area,
    required ClimateData climate,
    required double effectiveRainfall,
  }) {
    final results = <CropGrowthStage, CropWaterRequirement>{};
    
    for (final stage in CropGrowthStage.values) {
      results[stage] = calculateWaterRequirement(
        cropType: cropType,
        growthStage: stage,
        area: area,
        climate: climate,
        effectiveRainfall: effectiveRainfall,
      );
    }
    
    return results;
  }

  /// Calculate discharge required for given volume and time.
  double calculateDischarge({
    required double volumeM3,
    required double areaHa,
    required int hoursAvailable,
  }) {
    // Q = Volume / (Area * Time)
    // Q in m³/s, Volume in m³, Area in m², Time in seconds
    final areaM2 = areaHa * 10000;
    final timeSeconds = hoursAvailable * 3600.0;
    return volumeM3 / (areaM2 * timeSeconds);
  }
}
