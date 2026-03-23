/// lib/features/transport/road/domain/services/traffic_growth_service.dart
///
/// Traffic growth projection service.
/// 
/// PURPOSE:
/// - Multi-year traffic growth projection
/// - Year-by-year breakdown of traffic
/// - Cumulative ESAL and MSA calculation
///
/// DOMAIN PURITY:
/// - All calculations performed here (no Pro gating)
/// - Returns complete, truthful results
library;

import 'dart:math' as math;
import 'package:site_buddy/core/engineering/standards/transport/road_standard.dart';
import 'package:site_buddy/features/transport/road/domain/models/traffic_growth.dart';

/// SERVICE: TrafficGrowthService
/// PURPOSE: Handles all traffic-related calculations and projections.
class TrafficGrowthService {
  final RoadStandard standard;

  TrafficGrowthService(this.standard);

  /// Generate complete traffic growth projection with year-by-year data.
  /// 
  /// [initialTraffic] - Base year traffic (CVPD)
  /// [growthRate] - Annual growth rate (%)
  /// [designLife] - Design period in years
  /// [vdf] - Vehicle Damage Factor
  /// [ldf] - Lane Distribution Factor
  TrafficGrowthProjection projectTrafficGrowth({
    required double initialTraffic,
    required double growthRate,
    required int designLife,
    required double vdf,
    required double ldf,
  }) {
    final yearlyData = <YearlyTrafficData>[];
    double cumulativeESAL = 0.0;
    double prevTraffic = initialTraffic;

    for (int year = 1; year <= designLife; year++) {
      // Traffic for this year
      final growthFactor = math.pow(1 + (growthRate / 100), year);
      final dailyTraffic = initialTraffic * growthFactor;

      // ESAL for this year: 365 * daily * vdf * ldf
      final yearlyESAL = 365 * dailyTraffic * vdf * ldf;
      cumulativeESAL += yearlyESAL;

      // Growth from previous year
      final growthPercent = ((dailyTraffic - prevTraffic) / prevTraffic) * 100;

      yearlyData.add(YearlyTrafficData(
        year: year,
        dailyTraffic: dailyTraffic,
        cumulativeESAL: cumulativeESAL,
        growthPercent: growthPercent,
      ));

      prevTraffic = dailyTraffic;
    }

    final finalYearTraffic = yearlyData.last.dailyTraffic;
    final msaDesign = cumulativeESAL / 1e6;

    return TrafficGrowthProjection(
      initialTraffic: initialTraffic,
      growthRate: growthRate,
      designLife: designLife,
      vdf: vdf,
      ldf: ldf,
      yearlyData: yearlyData,
      finalYearTraffic: finalYearTraffic,
      cumulativeESAL: cumulativeESAL,
      msaDesign: msaDesign,
      trafficCategory: standard.classifyTraffic(msaDesign),
    );
  }

  /// Calculate adjusted MSA for a given scenario using standard factors.
  /// 
  /// This delegates scenario factor lookup to the Standard layer,
  /// keeping business rules centralized.
  double calculateScenarioMSA({
    required double baseMSA,
    required DesignScenario scenario,
  }) {
    final factor = standard.getScenarioTrafficFactor(scenario);
    return baseMSA * factor;
  }

  /// Calculate cost estimate per square meter for a given scenario.
  /// 
  /// [thickness] - Total pavement thickness in mm
  /// [scenario] - Design scenario
  /// 
  /// Returns estimated cost per 1000 sqm.
  double estimateScenarioCost({
    required double thickness,
    required DesignScenario scenario,
  }) {
    final baseCostPerM3 = _getBaseCostPerCubicMeter(scenario);
    // Cost per sqm = base cost per m³ * thickness in meters
    final costPerSqM = baseCostPerM3 * (thickness / 1000);
    return costPerSqM * 1000; // per 1000 sqm
  }

  /// Get base material cost per cubic meter based on scenario.
  double _getBaseCostPerCubicMeter(DesignScenario scenario) {
    switch (scenario) {
      case DesignScenario.conservative:
        return 5500; // Higher quality materials
      case DesignScenario.standard:
        return 5000; // Standard IRC materials
      case DesignScenario.optimized:
        return 4500; // Cost-optimized materials
    }
  }

  /// Generate recommendation text for a scenario.
  String generateScenarioRecommendation({
    required DesignScenario scenario,
    required double thickness,
  }) {
    switch (scenario) {
      case DesignScenario.conservative:
        return thickness > 700 
          ? 'Recommended for heavy commercial corridors'
          : 'Suitable for high-traffic urban roads';
      case DesignScenario.standard:
        return 'IRC 37-2018 compliant design';
      case DesignScenario.optimized:
        return thickness < 650
          ? 'Cost-effective for medium traffic'
          : 'Consider standard design for durability';
    }
  }
}
