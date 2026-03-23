/// lib/features/water/irrigation/domain/services/soil_irrigation_service.dart
///
/// Soil-based irrigation modeling service.
/// 
/// PURPOSE:
/// - Model soil water retention and availability
/// - Calculate irrigation scheduling parameters
/// - Support different soil types and conditions
///
/// DOMAIN PURITY:
/// - All calculations performed here
/// - No Pro gating (handled in Application layer)
library;

import 'package:site_buddy/features/water/irrigation/domain/models/irrigation_models.dart';

/// SERVICE: SoilIrrigationService
/// PURPOSE: Handles soil-based irrigation modeling.
class SoilIrrigationService {
  
  SoilIrrigationService();

  /// Create soil irrigation model for given soil type.
  /// 
  /// [soilType] - Type of soil
  /// [effectiveRainfall] - Effective rainfall in mm
  /// [rootZoneDepth] - Root zone depth in meters (optional, uses soil default)
  /// [depletionAllowable] - Management allowable depletion (0-1, default 0.4)
  SoilIrrigationModel createSoilModel({
    required SoilType soilType,
    required double effectiveRainfall,
    double? rootZoneDepth,
    double depletionAllowable = 0.4,
  }) {
    return SoilIrrigationModel(
      soilType: soilType,
      effectiveRainfall: effectiveRainfall,
      fieldCapacity: soilType.fieldCapacity,
      wiltingPoint: soilType.wiltingPoint,
      availableWater: soilType.availableWater,
      infiltrationRate: soilType.infiltrationRate,
      rootZoneDepth: rootZoneDepth ?? soilType.maxRootingDepth,
      depletionAllowable: depletionAllowable,
    );
  }

  /// Calculate recommended irrigation depth for soil.
  /// 
  /// Returns depth in mm.
  double calculateIrrigationDepth(SoilIrrigationModel soil) {
    // Irrigation depth = Total Available Water × Depletion Fraction
    return soil.totalAvailableWater * soil.depletionAllowable;
  }

  /// Calculate irrigation interval based on daily ET.
  /// 
  /// [soil] - Soil irrigation model
  /// [dailyETc] - Daily crop evapotranspiration in mm/day
  /// 
  /// Returns interval in days.
  double calculateIrrigationInterval({
    required SoilIrrigationModel soil,
    required double dailyETc,
  }) {
    if (dailyETc <= 0) return 999; // No limit if no ET
    
    return soil.readilyAvailableWater / dailyETc;
  }

  /// Calculate time to infiltrate given depth.
  /// 
  /// [soil] - Soil irrigation model
  /// [depthRequired] - Irrigation depth in mm
  /// 
  /// Returns infiltration time in hours.
  double calculateInfiltrationTime({
    required SoilIrrigationModel soil,
    required double depthRequired,
  }) {
    if (soil.infiltrationRate <= 0) return 999;
    return depthRequired / soil.infiltrationRate;
  }

  /// Evaluate soil suitability for irrigation methods.
  /// 
  /// Returns a map of method to suitability score (0-100).
  Map<IrrigationMethod, String> evaluateMethodSuitability(SoilIrrigationModel soil) {
    final results = <IrrigationMethod, String>{};
    
    for (final method in IrrigationMethod.values) {
      // Evaluate based on soil type compatibility
      switch (method) {
        case IrrigationMethod.flood:
          if (soil.infiltrationRate <= 10) {
            results[method] = 'SUITABLE: Low infiltration prevents runoff';
          } else if (soil.infiltrationRate <= 30) {
            results[method] = 'ACCEPTABLE: Moderate infiltration';
          } else {
            results[method] = 'UNSUITABLE: High infiltration causes deep percolation';
          }
          break;
          
        case IrrigationMethod.furrow:
          if (soil.infiltrationRate >= 10 && soil.infiltrationRate <= 50) {
            results[method] = 'SUITABLE: Good for medium-textured soils';
          } else if (soil.infiltrationRate >= 5) {
            results[method] = 'ACCEPTABLE: May require frequent irrigation';
          } else {
            results[method] = 'UNSUITABLE: Too slow for furrow irrigation';
          }
          break;
          
        case IrrigationMethod.sprinkler:
          if (soil.infiltrationRate >= 5) {
            results[method] = 'SUITABLE: Adequate infiltration for sprinklers';
          } else {
            results[method] = 'CAUTION: May cause ponding';
          }
          break;
          
        case IrrigationMethod.drip:
          results[method] = 'SUITABLE: Works well for all soil types';
          break;
          
        case IrrigationMethod.centerPivot:
          if (soil.infiltrationRate >= 5 && soil.infiltrationRate <= 50) {
            results[method] = 'SUITABLE: Good for medium-textured fields';
          } else {
            results[method] = 'CAUTION: Check infiltration rate';
          }
          break;
      }
    }
    
    return results;
  }

  /// Calculate water balance for soil.
  /// 
  /// [soil] - Soil irrigation model
  /// [waterApplied] - Water applied in mm
  /// [rainfall] - Rainfall in mm
  /// [etOut] - Evapotranspiration in mm
  /// 
  /// Returns net change in soil moisture (positive = surplus, negative = deficit).
  double calculateWaterBalance({
    required SoilIrrigationModel soil,
    required double waterApplied,
    required double rainfall,
    required double etOut,
  }) {
    final totalIn = waterApplied + rainfall;
    final totalOut = etOut;
    final balance = totalIn - totalOut;
    
    // Note: If balance exceeds soil capacity, excess becomes deep percolation
    // This is handled in estimateDeepPercolation method
    return balance;
  }

  /// Estimate deep percolation losses.
  double estimateDeepPercolation({
    required double waterInput,
    required double soilFieldCapacity,
    required double currentSoilMoisture,
    required double rootZoneDepth,
  }) {
    // Water held = (FC - Current) × Root Zone Depth
    final heldCapacity = (soilFieldCapacity - currentSoilMoisture) * rootZoneDepth * 10; // Convert to mm
    
    if (waterInput <= heldCapacity) {
      return 0; // All water is held
    }
    
    // Excess water becomes deep percolation
    return waterInput - heldCapacity;
  }
}
