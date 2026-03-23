/// lib/features/transport/road/domain/models/traffic_growth.dart
///
/// Enhanced traffic model with multi-year growth projection.
/// 
/// PURPOSE:
/// - Support multi-year traffic projection (5-20 years)
/// - Year-by-year breakdown of traffic growth
/// - Cumulative load calculation
library;

/// Design scenario types
enum DesignScenario {
  /// Conservative: Higher safety margins, thicker pavement
  conservative,
  
  /// Standard: Balanced design per IRC guidelines
  standard,
  
  /// Optimized: Cost-efficient design, uses material optimization
  optimized,
}

/// Extension for scenario display names
extension DesignScenarioExtension on DesignScenario {
  String get displayName {
    switch (this) {
      case DesignScenario.conservative:
        return 'Conservative (Safe)';
      case DesignScenario.standard:
        return 'Standard (Balanced)';
      case DesignScenario.optimized:
        return 'Optimized (Cost-Efficient)';
    }
  }

  String get description {
    switch (this) {
      case DesignScenario.conservative:
        return 'Higher safety margins with increased pavement thickness. Recommended for heavy traffic corridors.';
      case DesignScenario.standard:
        return 'Per IRC 37-2018 guidelines. Balanced approach between safety and cost.';
      case DesignScenario.optimized:
        return 'Material-optimized design for cost efficiency. Best for projects with budget constraints.';
    }
  }

  /// Safety factor applied to traffic
  double get trafficSafetyFactor {
    switch (this) {
      case DesignScenario.conservative:
        return 1.2; // +20% traffic
      case DesignScenario.standard:
        return 1.0; // Standard
      case DesignScenario.optimized:
        return 0.9; // -10% traffic (but may need material upgrade)
    }
  }
}

/// Single year traffic data
class YearlyTrafficData {
  final int year;
  final double dailyTraffic;
  final double cumulativeESAL;
  final double growthPercent;

  const YearlyTrafficData({
    required this.year,
    required this.dailyTraffic,
    required this.cumulativeESAL,
    required this.growthPercent,
  });

  Map<String, dynamic> toMap() => {
    'year': year,
    'dailyTraffic': dailyTraffic,
    'cumulativeESAL': cumulativeESAL,
    'growthPercent': growthPercent,
  };
}

/// Traffic growth projection result
class TrafficGrowthProjection {
  /// Initial traffic (base year)
  final double initialTraffic;
  
  /// Growth rate (% per year)
  final double growthRate;
  
  /// Design life (years)
  final int designLife;
  
  /// Vehicle Damage Factor
  final double vdf;
  
  /// Lane Distribution Factor
  final double ldf;
  
  /// Year-by-year traffic data
  final List<YearlyTrafficData> yearlyData;
  
  /// Final year traffic
  final double finalYearTraffic;
  
  /// Total cumulative ESAL over design period
  final double cumulativeESAL;
  
  /// Design MSA (Million Standard Axles)
  final double msaDesign;
  
  /// Traffic category (LOW, MEDIUM, HEAVY)
  final String trafficCategory;

  const TrafficGrowthProjection({
    required this.initialTraffic,
    required this.growthRate,
    required this.designLife,
    required this.vdf,
    required this.ldf,
    required this.yearlyData,
    required this.finalYearTraffic,
    required this.cumulativeESAL,
    required this.msaDesign,
    required this.trafficCategory,
  });

  /// Get growth summary
  String get growthSummary {
    final totalGrowth = ((finalYearTraffic - initialTraffic) / initialTraffic * 100).toStringAsFixed(1);
    return 'Traffic grew from ${initialTraffic.toStringAsFixed(0)} to ${finalYearTraffic.toStringAsFixed(0)} CVPD (+$totalGrowth%) over $designLife years';
  }

  Map<String, dynamic> toMap() => {
    'initialTraffic': initialTraffic,
    'growthRate': growthRate,
    'designLife': designLife,
    'vdf': vdf,
    'ldf': ldf,
    'yearlyData': yearlyData.map((y) => y.toMap()).toList(),
    'finalYearTraffic': finalYearTraffic,
    'cumulativeESAL': cumulativeESAL,
    'msaDesign': msaDesign,
    'trafficCategory': trafficCategory,
  };
}

/// Scenario-based design result
class ScenarioDesignResult {
  final DesignScenario scenario;
  final double designThickness;
  final double designMSA;
  final String safetyClassification;
  final double estimatedCost;
  final double costPerSqM;
  final String recommendation;

  const ScenarioDesignResult({
    required this.scenario,
    required this.designThickness,
    required this.designMSA,
    required this.safetyClassification,
    required this.estimatedCost,
    required this.costPerSqM,
    required this.recommendation,
  });

  Map<String, dynamic> toMap() => {
    'scenario': scenario.name,
    'designThickness': designThickness,
    'designMSA': designMSA,
    'safetyClassification': safetyClassification,
    'estimatedCost': estimatedCost,
    'costPerSqM': costPerSqM,
    'recommendation': recommendation,
  };
}

/// Material comparison for optimization
class MaterialComparison {
  final String materialName;
  final double unitCost; // per m³
  final int durabilityYears;  // Changed from double to int
  final double loadCapacity; // in ESAL
  final double maintenanceCostPerYear;
  final double lifecycleCost;
  final int rank;
  final bool isRecommended;

  const MaterialComparison({
    required this.materialName,
    required this.unitCost,
    required this.durabilityYears,
    required this.loadCapacity,
    required this.maintenanceCostPerYear,
    required this.lifecycleCost,
    required this.rank,
    this.isRecommended = false,
  });

  Map<String, dynamic> toMap() => {
    'materialName': materialName,
    'unitCost': unitCost,
    'durabilityYears': durabilityYears,
    'loadCapacity': loadCapacity,
    'maintenanceCostPerYear': maintenanceCostPerYear,
    'lifecycleCost': lifecycleCost,
    'rank': rank,
    'isRecommended': isRecommended,
  };
}

/// Material optimization result (PRO feature - computed in domain, shown conditionally)
class MaterialOptimizationResult {
  final List<MaterialComparison> materialComparisons;
  final String recommendedMaterial;
  final double potentialSavings;
  final double savingsPercent;
  final String analysisSummary;

  const MaterialOptimizationResult({
    required this.materialComparisons,
    required this.recommendedMaterial,
    required this.potentialSavings,
    required this.savingsPercent,
    required this.analysisSummary,
  });

  Map<String, dynamic> toMap() => {
    'materialComparisons': materialComparisons.map((m) => m.toMap()).toList(),
    'recommendedMaterial': recommendedMaterial,
    'potentialSavings': potentialSavings,
    'savingsPercent': savingsPercent,
    'analysisSummary': analysisSummary,
  };
}
