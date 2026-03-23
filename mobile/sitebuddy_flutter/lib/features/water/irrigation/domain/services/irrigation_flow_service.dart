/// lib/features/water/irrigation/domain/services/irrigation_flow_service.dart
///
/// Flow distribution service for irrigation networks.
/// 
/// PURPOSE:
/// - Calculate flow distribution across canal networks
/// - Include seepage and evaporation losses
/// - Support multi-node distribution calculations
///
/// DOMAIN PURITY:
/// - All calculations performed here
/// - No Pro gating (handled in Application layer)
library;

import 'dart:math' as math;
import 'package:site_buddy/features/water/irrigation/domain/models/irrigation_models.dart';
import 'package:site_buddy/core/engineering/standards/hydrology/hydrology_standard.dart';

/// SERVICE: IrrigationFlowService
/// PURPOSE: Handles flow distribution calculations in canal networks.
class IrrigationFlowService {
  final HydrologyStandard hydrologyStandard;

  IrrigationFlowService(this.hydrologyStandard);

  /// Calculate flow distribution for a canal network.
  /// 
  /// [totalDischarge] - Total discharge at source (m³/s)
  /// [totalHead] - Total available head at source (m)
  /// [nodes] - Distribution network nodes
  /// [seepageLoss] - Seepage loss coefficient (m³/s per km)
  /// [evaporationLoss] - Evaporation loss (m³/s per km²)
  FlowDistributionResult calculateDistribution({
    required double totalDischarge,
    required double totalHead,
    required List<FlowNodeConfig> nodes,
    double seepageLoss = 0.001,
    double evaporationLoss = 0.0001,
  }) {
    final distributionNetwork = <FlowDistributionNode>[];
    double cumulativeLosses = 0;
    double remainingHead = totalHead;
    double remainingDischarge = totalDischarge;

    for (int i = 0; i < nodes.length; i++) {
      final node = nodes[i];
      
      // Calculate flow split ratio
      final splitRatio = node.flowRatio;
      final nodeDischarge = remainingDischarge * splitRatio;
      
      // Calculate losses up to this node
      final distance = node.distanceFromSource; // km
      final seepage = seepageLoss * distance;
      final evaporation = evaporationLoss * node.canalArea; // km²
      final nodeLosses = (seepage + evaporation) * (1 - i / nodes.length); // Distributed
      
      cumulativeLosses += nodeLosses;
      remainingHead -= nodeLosses * 0.001; // Simplified head loss
      remainingDischarge -= nodeLosses;

      // Calculate velocity (simplified Manning's)
      final velocity = _estimateVelocity(nodeDischarge, node.hydraulicRadius);

      final distributionNode = FlowDistributionNode(
        id: node.id,
        name: node.name,
        discharge: nodeDischarge,
        head: remainingHead.clamp(0, totalHead),
        velocity: velocity,
        losses: nodeLosses,
        children: [],
      );

      distributionNetwork.add(distributionNode);
    }

    // Calculate overall efficiency
    final efficiency = ((totalDischarge - cumulativeLosses) / totalDischarge) * 100;

    return FlowDistributionResult(
      totalDischarge: totalDischarge,
      totalHead: totalHead,
      distributionNetwork: distributionNetwork,
      overallEfficiency: efficiency.clamp(0, 100),
      totalLosses: cumulativeLosses,
    );
  }

  /// Calculate scenario-based irrigation requirements.
  /// 
  /// [scenario] - Design scenario
  /// [netWaterNeed] - Net water requirement (m³/day)
  /// [irrigationMethod] - Proposed irrigation method
  List<ScenarioIrrigationResult> calculateAllScenarios({
    required double netWaterNeed,
    required IrrigationMethod irrigationMethod,
    required double area,
  }) {
    final results = <ScenarioIrrigationResult>[];

    for (final scenario in IrrigationScenario.values) {
      // Apply scenario factor
      final adjustedNeed = netWaterNeed * scenario.waterApplicationFactor;

      // Apply method efficiency
      final grossApplication = adjustedNeed / (irrigationMethod.efficiency / 100);

      // Calculate discharge requirement (m³/s for continuous flow)
      // Assuming 12 hours of irrigation per day
      final dischargeRequired = grossApplication / (12 * 3600);

      // Generate assessment
      final assessment = _generateAssessment(scenario, irrigationMethod, grossApplication);

      results.add(ScenarioIrrigationResult(
        scenario: scenario,
        waterRequirement: adjustedNeed,
        grossApplication: grossApplication,
        efficiency: irrigationMethod.efficiency,
        recommendedMethod: irrigationMethod.displayName,
        dischargeRequired: dischargeRequired,
        assessment: assessment,
      ));
    }

    return results;
  }

  /// Calculate canal dimensions using Manning's equation.
  /// 
  /// [discharge] - Design discharge (m³/s)
  /// [slope] - Canal slope (m/m)
  /// [sideSlope] - Side slope (z:1)
  /// [manningN] - Manning's roughness coefficient
  CanalDimensions calculateCanalDimensions({
    required double discharge,
    required double slope,
    required double sideSlope,
    double manningN = 0.013,
  }) {
    // Manning's equation: Q = (1/n) × A × R^(2/3) × S^(1/2)
    // For trapezoidal channel:
    // A = (b + zy) × y
    // P = b + 2y√(1+z²)
    // R = A/P
    
    // Iterative solution for normal depth
    double y = 1.0; // Initial guess (m)
    const tolerance = 0.001;
    const maxIterations = 100;

    for (int iter = 0; iter < maxIterations; iter++) {
      final b = y * sideSlope * 2; // Start with proportional bed width
      final area = (b + sideSlope * y) * y;
      final perimeter = b + 2 * y * math.sqrt(1 + sideSlope * sideSlope);
      final hydraulicRadius = area / perimeter;

      // Calculate Q for this depth
      final qCalc = (1 / manningN) * area * math.pow(hydraulicRadius, 2 / 3) * math.sqrt(slope);

      // Update depth
      if (qCalc > discharge) {
        y *= 0.9; // Decrease if Q too high
      } else {
        y *= 1.1; // Increase if Q too low
      }

      // Check convergence
      if ((qCalc - discharge).abs() / discharge < tolerance) {
        break;
      }
    }

    // Calculate final dimensions
    final bedWidth = y * sideSlope * 2;
    final area = (bedWidth + sideSlope * y) * y;
    final perimeter = bedWidth + 2 * y * math.sqrt(1 + sideSlope * sideSlope);
    final velocity = discharge / area;

    return CanalDimensions(
      depth: y,
      bedWidth: bedWidth,
      waterArea: area,
      wettedPerimeter: perimeter,
      hydraulicRadius: perimeter > 0 ? area / perimeter : 0,
      velocity: velocity,
    );
  }

  /// Estimate velocity using continuity equation.
  double _estimateVelocity(double discharge, double hydraulicRadius) {
    if (hydraulicRadius <= 0) return 0.5; // Default
    // Simplified: v = Q / A, assuming A proportional to R²
    return discharge / (hydraulicRadius * 2);
  }

  /// Generate scenario assessment text.
  String _generateAssessment(
    IrrigationScenario scenario,
    IrrigationMethod method,
    double grossApplication,
  ) {
    if (scenario == IrrigationScenario.optimized && method.efficiency >= 80) {
      return 'EXCELLENT: Optimized design with efficient irrigation method';
    } else if (scenario == IrrigationScenario.standard) {
      return 'GOOD: Standard design per FAO guidelines';
    } else if (grossApplication > 1000) {
      return 'HIGH WATER USE: Consider more efficient methods';
    } else {
      return 'ACCEPTABLE: Design meets basic requirements';
    }
  }
}

/// Configuration for a flow distribution node.
class FlowNodeConfig {
  final String id;
  final String name;
  final double flowRatio; // Fraction of total flow (0-1)
  final double distanceFromSource; // km
  final double canalArea; // km² (for evaporation)
  final double hydraulicRadius; // m

  const FlowNodeConfig({
    required this.id,
    required this.name,
    required this.flowRatio,
    required this.distanceFromSource,
    this.canalArea = 0,
    this.hydraulicRadius = 1.0,
  });
}

/// Calculated canal dimensions.
class CanalDimensions {
  final double depth; // m
  final double bedWidth; // m
  final double waterArea; // m²
  final double wettedPerimeter; // m
  final double hydraulicRadius; // m
  final double velocity; // m/s

  const CanalDimensions({
    required this.depth,
    required this.bedWidth,
    required this.waterArea,
    required this.wettedPerimeter,
    required this.hydraulicRadius,
    required this.velocity,
  });
}
