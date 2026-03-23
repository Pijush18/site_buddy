/// lib/features/water/irrigation/domain/services/irrigation_optimization_service.dart
///
/// Irrigation optimization service (PRO feature).
/// 
/// PURPOSE:
/// - Compare irrigation methods for optimal selection
/// - Calculate water and cost savings
/// - Provide lifecycle cost analysis
///
/// NOTE: This is a PRO feature - computed in domain but gated in Application layer.
/// The domain layer ALWAYS returns full, truthful engineering results.
/// Pro/premium features are computed but not gated here.
///
/// DOMAIN PURITY:
/// - All calculations performed here
/// - Returns complete optimization analysis
library;

import 'package:site_buddy/features/water/irrigation/domain/models/irrigation_models.dart';

/// SERVICE: IrrigationOptimizationService
/// PURPOSE: Handles irrigation method optimization and comparison.
class IrrigationOptimizationService {
  
  IrrigationOptimizationService();

  /// Analyze and compare all irrigation methods.
  /// 
  /// [netWaterNeed] - Net water requirement (m³/day)
  /// [area] - Cultivation area (hectares)
  /// [soilType] - Soil type for suitability analysis
  IrrigationOptimizationResult analyzeOptimization({
    required double netWaterNeed,
    required double area,
    required SoilType soilType,
  }) {
    final comparisons = <IrrigationMethodComparison>[];

    // Analyze each irrigation method
    for (final method in IrrigationMethod.values) {
      // Calculate water requirement with method efficiency
      final grossWater = netWaterNeed / (method.efficiency / 100);

      // Calculate relative costs (index-based, 100 = baseline flood)
      // These are simplified relative costs
      final initialCostIndex = _getInitialCostIndex(method, area);
      final operatingCostIndex = _getOperatingCostIndex(method, grossWater);
      final lifecycleCost = initialCostIndex + (operatingCostIndex * 10); // 10-year lifecycle

      comparisons.add(IrrigationMethodComparison(
        method: method,
        waterRequirement: grossWater,
        efficiency: method.efficiency,
        initialCost: initialCostIndex,
        operatingCost: operatingCostIndex,
        lifecycleCost: lifecycleCost,
        rank: 0, // Will be set after sorting
      ));
    }

    // Sort by lifecycle cost
    comparisons.sort((a, b) => a.lifecycleCost.compareTo(b.lifecycleCost));

    // Assign ranks
    final rankedComparisons = <IrrigationMethodComparison>[];
    for (int i = 0; i < comparisons.length; i++) {
      rankedComparisons.add(IrrigationMethodComparison(
        method: comparisons[i].method,
        waterRequirement: comparisons[i].waterRequirement,
        efficiency: comparisons[i].efficiency,
        initialCost: comparisons[i].initialCost,
        operatingCost: comparisons[i].operatingCost,
        lifecycleCost: comparisons[i].lifecycleCost,
        rank: i + 1,
        isRecommended: i == 0,
      ));
    }

    final recommended = rankedComparisons.first;
    final baselineMethod = comparisons.last; // Worst is flood (last after sort)

    // Calculate savings compared to flood irrigation
    final waterSavings = ((baselineMethod.waterRequirement - recommended.waterRequirement) 
        / baselineMethod.waterRequirement) * 100;
    final costSavings = ((baselineMethod.lifecycleCost - recommended.lifecycleCost) 
        / baselineMethod.lifecycleCost) * 100;
    final efficiencyGain = recommended.efficiency - baselineMethod.efficiency;

    // Generate summary
    final summary = _generateSummary(recommended, waterSavings, costSavings);

    return IrrigationOptimizationResult(
      recommendedMethod: recommended.method,
      waterSavings: waterSavings.clamp(0, 100),
      costSavings: costSavings.clamp(0, 100),
      efficiencyGain: efficiencyGain,
      methodComparisons: rankedComparisons,
      analysisSummary: summary,
    );
  }

  /// Get relative initial cost index (baseline flood = 100).
  double _getInitialCostIndex(IrrigationMethod method, double area) {
    // Base cost per hectare (relative index)
    final baseCostPerHa = switch (method) {
      IrrigationMethod.flood => 15000,
      IrrigationMethod.furrow => 25000,
      IrrigationMethod.sprinkler => 80000,
      IrrigationMethod.drip => 120000,
      IrrigationMethod.centerPivot => 150000,
    };
    return (baseCostPerHa * area / 1000).clamp(50, 500); // Normalized
  }

  /// Get relative operating cost index.
  double _getOperatingCostIndex(IrrigationMethod method, double waterVolume) {
    // Energy and labor cost factor
    final energyFactor = switch (method) {
      IrrigationMethod.flood => 0.3,
      IrrigationMethod.furrow => 0.5,
      IrrigationMethod.sprinkler => 0.8,
      IrrigationMethod.drip => 0.6,
      IrrigationMethod.centerPivot => 0.9,
    };
    
    // Water volume factor (more water = more cost)
    final volumeFactor = waterVolume / 1000; // Normalize
    
    return energyFactor * (1 + volumeFactor);
  }

  /// Generate analysis summary.
  String _generateSummary(
    IrrigationMethodComparison recommended,
    double waterSavings,
    double costSavings,
  ) {
    final methodName = recommended.method.displayName;
    
    if (recommended.method == IrrigationMethod.drip && waterSavings > 40) {
      return 'Drip irrigation provides the best value with ${waterSavings.toStringAsFixed(0)}% water '
          'savings and ${costSavings.toStringAsFixed(0)}% lifecycle cost reduction. '
          'Recommended for high-value crops and water-scarce areas.';
    } else if (recommended.method == IrrigationMethod.sprinkler) {
      return 'Sprinkler irrigation offers good balance with ${waterSavings.toStringAsFixed(0)}% water '
          'savings and ${costSavings.toStringAsFixed(0)}% lifecycle cost reduction. '
          'Suitable for most field crops.';
    } else if (recommended.method == IrrigationMethod.flood) {
      return 'Traditional flood irrigation is most cost-effective for this application. '
          'Consider surface drainage management to improve efficiency.';
    } else {
      return '$methodName is recommended with ${waterSavings.toStringAsFixed(0)}% water '
          'savings and ${costSavings.toStringAsFixed(0)}% lifecycle cost reduction.';
    }
  }

  /// Calculate payback period for method upgrade.
  /// 
  /// [baseMethod] - Current/alternative method
  /// [newMethod] - Proposed method
  /// [annualWaterSavings] - Water savings per year (m³)
  /// [waterCost] - Cost per m³ of water
  double calculatePaybackPeriod({
    required IrrigationMethod baseMethod,
    required IrrigationMethod newMethod,
    required double annualWaterSavings,
    required double waterCost,
  }) {
    // Additional initial investment
    final baseCost = _getInitialCostIndex(baseMethod, 1);
    final newCost = _getInitialCostIndex(newMethod, 1);
    final additionalInvestment = newCost - baseCost;

    if (additionalInvestment <= 0) return 0; // No investment needed

    // Annual savings from water
    final annualSavings = annualWaterSavings * waterCost;

    if (annualSavings <= 0) return 999; // No savings

    return additionalInvestment / annualSavings; // Years
  }

  /// Suggest optimal irrigation schedule.
  /// 
  /// [method] - Irrigation method
  /// [netWaterNeed] - Net daily water need (m³/day)
  /// [area] - Area (hectares)
  /// [soilType] - Soil type
  IrrigationSchedule suggestSchedule({
    required IrrigationMethod method,
    required double netWaterNeed,
    required double area,
    required SoilType soilType,
  }) {
    // Calculate irrigation depth based on soil
    final availableWater = soilType.availableWater;
    final rootDepth = soilType.maxRootingDepth;
    final totalAvailable = availableWater * rootDepth;
    final irrigationDepth = totalAvailable * 0.5; // 50% MAD

    // Calculate frequency
    final dailyET = netWaterNeed / area / 10; // Convert to mm/day
    final frequency = dailyET > 0 ? irrigationDepth / dailyET : 7.0;
    final clampedFrequency = frequency.clamp(1.0, 14.0);

    // Calculate application rate based on method
    final duration = switch (method) {
      IrrigationMethod.flood => 8.0,
      IrrigationMethod.furrow => 6.0,
      IrrigationMethod.sprinkler => 4.0,
      IrrigationMethod.drip => 2.0,
      IrrigationMethod.centerPivot => 3.0,
    };

    return IrrigationSchedule(
      method: method,
      irrigationDepth: irrigationDepth,
      frequencyDays: clampedFrequency,
      applicationDuration: duration,
      waterPerApplication: netWaterNeed / clampedFrequency * 1000, // liters
    );
  }
}

/// Irrigation scheduling recommendation.
class IrrigationSchedule {
  final IrrigationMethod method;
  final double irrigationDepth; // mm
  final double frequencyDays; // days
  final double applicationDuration; // hours
  final double waterPerApplication; // liters

  const IrrigationSchedule({
    required this.method,
    required this.irrigationDepth,
    required this.frequencyDays,
    required this.applicationDuration,
    required this.waterPerApplication,
  });

  Map<String, dynamic> toMap() => {
    'method': method.name,
    'irrigationDepth': irrigationDepth,
    'frequencyDays': frequencyDays,
    'applicationDuration': applicationDuration,
    'waterPerApplication': waterPerApplication,
  };
}
