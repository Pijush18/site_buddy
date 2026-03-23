/// lib/features/water/irrigation/domain/models/irrigation_models.dart
///
/// Core domain models for the enhanced irrigation engineering system.
/// 
/// PURPOSE:
/// - Crop water requirement calculations (FAO-based)
/// - Soil-based irrigation modeling
/// - Flow distribution across canal networks
/// - Scenario-based irrigation design
///
/// NOTE: This file re-exports all model files for backward compatibility.
/// New code should import specific model files directly:
///   - crop_models.dart - CropType, CropGrowthStage, ClimateData, CropWaterRequirement
///   - soil_models.dart - SoilType, IrrigationMethod, SoilIrrigationModel
///   - flow_models.dart - FlowDistributionNode, FlowDistributionResult, network models
///   - scenario_models.dart - IrrigationScenario (type only, values in FAO56Standard)
library;

export 'crop_models.dart';
export 'soil_models.dart';
export 'flow_models.dart';
export 'scenario_models.dart';
