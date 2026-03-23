/// lib/features/transport/road/domain/models/pavement_design_report.dart
///
/// Structured design report for pavement engineering.
/// 
/// PURPOSE:
/// - Comprehensive output structure for reporting
/// - Ready for PDF/export integration
/// - All calculations included (gating handled in Application)
library;

import 'package:site_buddy/features/transport/road/domain/models/pavement_structure.dart';
import 'package:site_buddy/features/transport/road/domain/models/traffic_growth.dart';

/// Complete pavement design report
class PavementDesignReport {
  /// Project information
  final String projectTitle;
  final String location;
  final DateTime designDate;
  final String designedBy;
  
  /// Design standards reference
  final String standardCode;
  final String standardDescription;
  
  /// Input parameters
  final DesignInputSummary inputs;
  
  /// Traffic analysis
  final TrafficGrowthProjection trafficProjection;
  
  /// Selected design scenario
  final DesignScenario selectedScenario;
  
  /// All scenario comparisons
  final List<ScenarioDesignResult> scenarioComparisons;
  
  /// Recommended scenario
  final ScenarioDesignResult recommendedScenario;
  
  /// Pavement structure design
  final PavementStructure pavementStructure;
  
  /// Material optimization (PRO feature - computed always)
  final MaterialOptimizationResult? materialOptimization;
  
  /// Safety evaluation
  final SafetyEvaluation safetyEvaluation;
  
  /// Construction notes
  final List<String> constructionNotes;
  
  /// Maintenance recommendations
  final List<String> maintenanceRecommendations;

  const PavementDesignReport({
    required this.projectTitle,
    required this.location,
    required this.designDate,
    required this.designedBy,
    required this.standardCode,
    required this.standardDescription,
    required this.inputs,
    required this.trafficProjection,
    required this.selectedScenario,
    required this.scenarioComparisons,
    required this.recommendedScenario,
    required this.pavementStructure,
    this.materialOptimization,
    required this.safetyEvaluation,
    required this.constructionNotes,
    required this.maintenanceRecommendations,
  });

  Map<String, dynamic> toMap() => {
    'projectTitle': projectTitle,
    'location': location,
    'designDate': designDate.toIso8601String(),
    'designedBy': designedBy,
    'standardCode': standardCode,
    'standardDescription': standardDescription,
    'inputs': inputs.toMap(),
    'trafficProjection': trafficProjection.toMap(),
    'selectedScenario': selectedScenario.name,
    'scenarioComparisons': scenarioComparisons.map((s) => s.toMap()).toList(),
    'recommendedScenario': recommendedScenario.toMap(),
    'pavementStructure': pavementStructure.toMap(),
    'materialOptimization': materialOptimization?.toMap(),
    'safetyEvaluation': safetyEvaluation.toMap(),
    'constructionNotes': constructionNotes,
    'maintenanceRecommendations': maintenanceRecommendations,
  };
}

/// Summary of design inputs
class DesignInputSummary {
  final double subgradeCBR;
  final String subgradeDescription;
  final double initialTraffic;
  final double growthRate;
  final int designLife;
  final double vdf;
  final double ldf;
  final String roadCategory;
  final String terrainType;

  const DesignInputSummary({
    required this.subgradeCBR,
    required this.subgradeDescription,
    required this.initialTraffic,
    required this.growthRate,
    required this.designLife,
    required this.vdf,
    required this.ldf,
    required this.roadCategory,
    this.terrainType = 'Plain',
  });

  /// Get CBR classification
  String get cbrClassification {
    if (subgradeCBR < 2) return 'Very Poor';
    if (subgradeCBR < 5) return 'Poor';
    if (subgradeCBR < 10) return 'Fair';
    if (subgradeCBR < 15) return 'Good';
    return 'Very Good';
  }

  Map<String, dynamic> toMap() => {
    'subgradeCBR': subgradeCBR,
    'subgradeDescription': subgradeDescription,
    'initialTraffic': initialTraffic,
    'growthRate': growthRate,
    'designLife': designLife,
    'vdf': vdf,
    'ldf': ldf,
    'roadCategory': roadCategory,
    'terrainType': terrainType,
  };
}

/// Safety evaluation result
class SafetyEvaluation {
  final String classification;
  final double reliabilityPercent;
  final double fatigueLife;
  final double ruttingResistance;
  final String overallAssessment;
  final List<SafetyConcern> concerns;
  final List<String> recommendations;

  const SafetyEvaluation({
    required this.classification,
    required this.reliabilityPercent,
    required this.fatigueLife,
    required this.ruttingResistance,
    required this.overallAssessment,
    required this.concerns,
    required this.recommendations,
  });

  Map<String, dynamic> toMap() => {
    'classification': classification,
    'reliabilityPercent': reliabilityPercent,
    'fatigueLife': fatigueLife,
    'ruttingResistance': ruttingResistance,
    'overallAssessment': overallAssessment,
    'concerns': concerns.map((c) => c.toMap()).toList(),
    'recommendations': recommendations,
  };
}

/// Individual safety concern
class SafetyConcern {
  final String type;
  final String description;
  final String severity;
  final String mitigation;

  const SafetyConcern({
    required this.type,
    required this.description,
    required this.severity,
    required this.mitigation,
  });

  Map<String, dynamic> toMap() => {
    'type': type,
    'description': description,
    'severity': severity,
    'mitigation': mitigation,
  };
}
