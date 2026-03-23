/// lib/features/transport/road/domain/services/material_optimization_service.dart
///
/// Material optimization analysis service.
/// 
/// PURPOSE:
/// - Compare different base course materials
/// - Lifecycle cost analysis
/// - Material recommendation based on traffic and budget
///
/// DOMAIN PURITY:
/// - All calculations performed here (no Pro gating)
/// - Returns complete, truthful results
library;

import 'package:site_buddy/features/transport/road/domain/models/traffic_growth.dart';

/// SERVICE: MaterialOptimizationService
/// PURPOSE: Handles material comparison and lifecycle cost analysis.
class MaterialOptimizationService {
  
  MaterialOptimizationService();

  /// Analyze material options for pavement base course.
  /// 
  /// [thickness] - Total pavement thickness in mm
  /// [msa] - Design MSA (Million Standard Axles)
  /// [cbr] - Subgrade CBR percentage
  MaterialOptimizationResult analyzeMaterialOptimization({
    required double thickness,
    required double msa,
    required double cbr,
  }) {
    // Compare different base course materials
    final materials = <MaterialComparison>[];

    // 1. Wet Mix Macadam (WMM) - Standard IRC
    materials.add(_analyzeMaterial(
      name: 'Wet Mix Macadam (WMM)',
      unitCost: 4500, // per m³
      durabilityYears: 15,
      loadCapacity: msa,
      thickness: thickness * 0.35,
    ));

    // 2. Cement Treated Base (CTB)
    materials.add(_analyzeMaterial(
      name: 'Cement Treated Base (CTB)',
      unitCost: 5500, // per m³
      durabilityYears: 20,
      loadCapacity: msa * 1.3,
      thickness: thickness * 0.30,
    ));

    // 3. Dry Lean Concrete (DLC)
    materials.add(_analyzeMaterial(
      name: 'Dry Lean Concrete (DLC)',
      unitCost: 6500, // per m³
      durabilityYears: 25,
      loadCapacity: msa * 1.5,
      thickness: thickness * 0.25,
    ));

    // 4. Full Depth Asphalt
    materials.add(_analyzeMaterial(
      name: 'Full Depth Asphalt',
      unitCost: 8000, // per m³
      durabilityYears: 20,
      loadCapacity: msa * 1.4,
      thickness: thickness * 0.40,
    ));

    // Rank materials by lifecycle cost
    materials.sort((a, b) => a.lifecycleCost.compareTo(b.lifecycleCost));

    final rankedMaterials = <MaterialComparison>[];
    for (int i = 0; i < materials.length; i++) {
      rankedMaterials.add(MaterialComparison(
        materialName: materials[i].materialName,
        unitCost: materials[i].unitCost,
        durabilityYears: materials[i].durabilityYears,
        loadCapacity: materials[i].loadCapacity,
        maintenanceCostPerYear: materials[i].maintenanceCostPerYear,
        lifecycleCost: materials[i].lifecycleCost,
        rank: i + 1,
        isRecommended: i == 0,
      ));
    }

    final recommended = rankedMaterials.first;
    final potentialSavings = rankedMaterials.last.lifecycleCost - recommended.lifecycleCost;
    final savingsPercent = (potentialSavings / rankedMaterials.last.lifecycleCost) * 100;

    return MaterialOptimizationResult(
      materialComparisons: rankedMaterials,
      recommendedMaterial: recommended.materialName,
      potentialSavings: potentialSavings,
      savingsPercent: savingsPercent,
      analysisSummary: 'Analysis of ${rankedMaterials.length} base course materials over 20-year lifecycle. '
          '${recommended.materialName} offers best value with ${savingsPercent.toStringAsFixed(1)}% savings vs highest cost option.',
    );
  }

  /// Internal method to analyze a single material.
  MaterialComparison _analyzeMaterial({
    required String name,
    required double unitCost,
    required int durabilityYears,
    required double loadCapacity,
    required double thickness,
  }) {
    // Simplified lifecycle cost calculation
    // LCC = (Initial Cost * (1 + wastage)) + (Annual Maintenance * years) + (Rehab cost / years)
    final initialCost = unitCost * (thickness / 1000); // per sqm
    final annualMaintenance = initialCost * 0.02; // 2% of initial per year
    final rehabCost = initialCost * 0.5; // 50% of initial at mid-life
    final lifecycleCost = initialCost + (annualMaintenance * 20) + rehabCost;

    return MaterialComparison(
      materialName: name,
      unitCost: unitCost,
      durabilityYears: durabilityYears,
      loadCapacity: loadCapacity,
      maintenanceCostPerYear: annualMaintenance,
      lifecycleCost: lifecycleCost,
      rank: 0,
    );
  }
}
