/// lib/core/qa/test_cases/integration_tests.dart
///
/// End-to-end integration tests for Road and Irrigation modules.
/// 
/// PURPOSE:
/// - Validate full pipeline consistency
/// - Ensure no data mismatch between services
/// - Test system behavior as users experience it
/// 
/// INTEGRATION PHILOSOPHY:
/// These tests chain services together to validate the complete
/// data flow from input to final output.
library;

import 'package:site_buddy/core/engineering/standards/irrigation/fao_56_standard.dart';
import 'package:site_buddy/core/engineering/standards/transport/irc_37_2018.dart';
import 'package:site_buddy/features/transport/road/domain/models/traffic_growth.dart';
import 'package:site_buddy/features/water/irrigation/domain/models/crop_models.dart';
import 'package:site_buddy/features/water/irrigation/domain/models/soil_models.dart';
import 'package:site_buddy/features/water/irrigation/domain/models/scenario_models.dart';
import 'package:site_buddy/features/water/irrigation/domain/models/flow_models.dart';

// ============================================================================
// INTEGRATION TEST FRAMEWORK
// ============================================================================

/// Integration test result.
class IntegrationTestResult {
  final String id;
  final String description;
  final bool passed;
  final Map<String, dynamic>? output;
  final List<String> validations;
  final String? error;

  const IntegrationTestResult({
    required this.id,
    required this.description,
    required this.passed,
    this.output,
    this.validations = const [],
    this.error,
  });
}

/// Integration test case.
class IntegrationTestCase {
  final String id;
  final String description;
  final Map<String, dynamic> input;
  final Map<String, dynamic> Function() run;
  final List<ValidationRule> validations;

  const IntegrationTestCase({
    required this.id,
    required this.description,
    required this.input,
    required this.run,
    required this.validations,
  });

  IntegrationTestResult execute() {
    try {
      final output = run();
      final failedValidations = <String>[];
      
      for (final validation in validations) {
        if (!validation.check(output)) {
          failedValidations.add(validation.description);
        }
      }

      return IntegrationTestResult(
        id: id,
        description: description,
        passed: failedValidations.isEmpty,
        output: output,
        validations: failedValidations,
      );
    } catch (e) {
      return IntegrationTestResult(
        id: id,
        description: description,
        passed: false,
        error: e.toString(),
      );
    }
  }
}

/// Validation rule for checking output.
class ValidationRule {
  final String description;
  final bool Function(Map<String, dynamic>) check;

  const ValidationRule({
    required this.description,
    required this.check,
  });
}

// ============================================================================
// ROAD MODULE INTEGRATION TESTS
// ============================================================================

/// Road module integration test cases.
/// 
/// Tests the complete pipeline:
/// Input → Traffic Projection → Pavement Design → Safety Evaluation
final roadIntegrationTests = [
  IntegrationTestCase(
    id: 'INT_RD_001',
    description: 'Standard highway: traffic → pavement → report',
    input: {
      'initialTraffic': 1000.0,
      'growthRate': 5.0,
      'designLife': 15,
      'cbr': 10.0,
      'vdf': 3.5,
      'ldf': 1.0,
      'scenario': DesignScenario.standard,
    },
    run: () {
      final irc37 = IRC37Standard();
      
      // Step 1: Calculate ESAL
      final esal = irc37.calculateESAL(
        initialTraffic: 1000.0,
        growthRate: 5.0,
        designLife: 15,
        vdf: 3.5,
        ldf: 1.0,
      );
      final msa = irc37.msaFromTraffic(esal);
      
      // Step 2: Calculate pavement thickness
      final thickness = irc37.designThickness(10.0, msa);
      
      // Step 3: Classify traffic
      final trafficClass = irc37.classifyTraffic(msa);
      
      // Step 4: Evaluate safety
      final safety = irc37.evaluateSafety(cbr: 10.0, thickness: thickness);
      
      // Step 5: Apply scenario factor
      final scenarioFactor = irc37.getScenarioTrafficFactor(DesignScenario.standard);
      final adjustedThickness = thickness * scenarioFactor;
      
      // Step 6: Design layers
      final layers = irc37.designLayers(cbr: 10.0, msa: msa);
      
      return {
        'esal': esal,
        'msa': msa,
        'thickness': thickness,
        'trafficClass': trafficClass,
        'safety': safety,
        'scenarioFactor': scenarioFactor,
        'adjustedThickness': adjustedThickness,
        'layerCount': layers.length,
        'layerNames': layers.map((l) => l.name).toList(),
      };
    },
    validations: [
      ValidationRule(
        description: 'MSA should be approximately 8 (1000 CVPD × 15yr)',
        check: (output) => (output['msa'] as num).toDouble() >= 7.5 && (output['msa'] as num).toDouble() <= 8.5,
      ),
      ValidationRule(
        description: 'Thickness should be reasonable (400-500mm)',
        check: (output) => (output['thickness'] as num).toDouble() >= 400 && (output['thickness'] as num).toDouble() <= 500,
      ),
      ValidationRule(
        description: 'Traffic class should be MEDIUM',
        check: (output) => output['trafficClass'] == 'MEDIUM',
      ),
      ValidationRule(
        description: 'Safety should be SAFE',
        check: (output) => (output['safety'] as String).startsWith('SAFE'),
      ),
      ValidationRule(
        description: 'Scenario factor should be 1.0 for standard',
        check: (output) => (output['scenarioFactor'] as num).toDouble() == 1.0,
      ),
      ValidationRule(
        description: 'Should have 4 layers',
        check: (output) => output['layerCount'] == 4,
      ),
    ],
  ),
  IntegrationTestCase(
    id: 'INT_RD_002',
    description: 'Heavy traffic corridor with conservative scenario',
    input: {
      'initialTraffic': 5000.0,
      'growthRate': 7.0,
      'designLife': 20,
      'cbr': 8.0,
      'vdf': 4.0,
      'ldf': 1.0,
      'scenario': DesignScenario.conservative,
    },
    run: () {
      final irc37 = IRC37Standard();
      
      final esal = irc37.calculateESAL(
        initialTraffic: 5000.0,
        growthRate: 7.0,
        designLife: 20,
        vdf: 4.0,
        ldf: 1.0,
      );
      final msa = irc37.msaFromTraffic(esal);
      final thickness = irc37.designThickness(8.0, msa);
      final trafficClass = irc37.classifyTraffic(msa);
      final safety = irc37.evaluateSafety(cbr: 8.0, thickness: thickness);
      final scenarioFactor = irc37.getScenarioTrafficFactor(DesignScenario.conservative);
      final adjustedThickness = thickness * scenarioFactor;
      
      return {
        'esal': esal,
        'msa': msa,
        'thickness': thickness,
        'trafficClass': trafficClass,
        'safety': safety,
        'scenarioFactor': scenarioFactor,
        'adjustedThickness': adjustedThickness,
      };
    },
    validations: [
      ValidationRule(
        description: 'MSA should be > 30 (HEAVY)',
        check: (output) => (output['msa'] as num).toDouble() > 30,
      ),
      ValidationRule(
        description: 'Traffic class should be HEAVY',
        check: (output) => output['trafficClass'] == 'HEAVY',
      ),
      ValidationRule(
        description: 'Conservative factor should be 1.2',
        check: (output) => (output['scenarioFactor'] as num).toDouble() == 1.2,
      ),
      ValidationRule(
        description: 'Adjusted thickness should be 20% higher',
        check: (output) {
          final ratio = (output['adjustedThickness'] as num) / (output['thickness'] as num);
          return (ratio - 1.2).abs() < 0.01;
        },
      ),
    ],
  ),
  IntegrationTestCase(
    id: 'INT_RD_003',
    description: 'Low volume road with optimized design',
    input: {
      'initialTraffic': 200.0,
      'growthRate': 3.0,
      'designLife': 10,
      'cbr': 5.0,
      'vdf': 3.0,
      'ldf': 1.0,
      'scenario': DesignScenario.optimized,
    },
    run: () {
      final irc37 = IRC37Standard();
      
      final esal = irc37.calculateESAL(
        initialTraffic: 200.0,
        growthRate: 3.0,
        designLife: 10,
        vdf: 3.0,
        ldf: 1.0,
      );
      final msa = irc37.msaFromTraffic(esal);
      final thickness = irc37.designThickness(5.0, msa);
      final trafficClass = irc37.classifyTraffic(msa);
      final safety = irc37.evaluateSafety(cbr: 5.0, thickness: thickness);
      final scenarioFactor = irc37.getScenarioTrafficFactor(DesignScenario.optimized);
      final adjustedThickness = thickness * scenarioFactor;
      
      return {
        'esal': esal,
        'msa': msa,
        'thickness': thickness,
        'trafficClass': trafficClass,
        'safety': safety,
        'scenarioFactor': scenarioFactor,
        'adjustedThickness': adjustedThickness,
      };
    },
    validations: [
      ValidationRule(
        description: 'MSA should be < 10 (LOW)',
        check: (output) => (output['msa'] as num).toDouble() < 10,
      ),
      ValidationRule(
        description: 'Traffic class should be LOW',
        check: (output) => output['trafficClass'] == 'LOW',
      ),
      ValidationRule(
        description: 'Optimized factor should be 0.9',
        check: (output) => (output['scenarioFactor'] as num).toDouble() == 0.9,
      ),
      ValidationRule(
        description: 'Thickness should meet minimum (300mm)',
        check: (output) => (output['adjustedThickness'] as num).toDouble() >= 300,
      ),
    ],
  ),
];

// ============================================================================
// IRRIGATION MODULE INTEGRATION TESTS
// ============================================================================

/// Irrigation module integration test cases.
/// 
/// Tests the complete pipeline:
/// Input → Climate/ET₀ → Crop Kc → Water Requirement → Soil Balance → Flow Design
final irrigationIntegrationTests = [
  IntegrationTestCase(
    id: 'INT_IR_001',
    description: 'Wheat field: climate → crop → soil → irrigation',
    input: {
      'temperature': 25.0,
      'humidity': 60.0,
      'windSpeed': 2.0,
      'sunshineHours': 8.0,
      'solarRadiation': 18.0,
      'rainfall': 100.0,
      'cropType': CropType.wheat,
      'growthStage': CropGrowthStage.midSeason,
      'area': 10.0,  // hectares
      'soilType': SoilType.loam,
      'rootDepth': 1.2,
      'mad': 0.50,
      'scenario': IrrigationScenario.standard,
    },
    run: () {
      final fao56 = FAO56Standard();
      
      // Step 1: Calculate ET₀
      final climate = ClimateData(
        temperature: 25.0,
        humidity: 60.0,
        windSpeed: 2.0,
        sunshineHours: 8.0,
        solarRadiation: 18.0,
        rainfall: 100.0,
      );
      final et0 = fao56.calculateET0(climate);
      
      // Step 2: Get crop Kc
      final kc = fao56.getCropCoefficient(CropType.wheat, CropGrowthStage.midSeason);
      
      // Step 3: Calculate ETc
      final etc = fao56.calculateETc(et0, kc);
      
      // Step 4: Calculate effective rainfall
      final effectiveRainfall = fao56.calculateEffectiveRainfall(100.0);
      
      // Step 5: Calculate net water requirement
      final netWater = etc * 10 * 1000;  // mm × ha × 1000 = liters
      
      // Step 6: Soil moisture balance
      final soil = SoilType.loam;
      final totalWater = soil.availableWater * 1.2;
      final readilyAvailable = totalWater * 0.50;
      final irrigationInterval = readilyAvailable / etc;
      
      // Step 7: Gross irrigation (flood for comparison)
      final grossFlood = fao56.calculateGrossIrrigation(
        netIrrigation: etc * 10 * 1000,
        method: IrrigationMethod.flood,
      );
      final grossDrip = fao56.calculateGrossIrrigation(
        netIrrigation: etc * 10 * 1000,
        method: IrrigationMethod.drip,
      );
      
      // Step 8: Apply scenario factor
      final scenarioFactor = fao56.getScenarioWaterFactor(IrrigationScenario.standard);
      final adjustedNet = netWater * scenarioFactor;
      
      return {
        'et0': et0,
        'kc': kc,
        'etc': etc,
        'effectiveRainfall': effectiveRainfall,
        'netWaterLiters': netWater,
        'totalAvailableWater': totalWater,
        'readilyAvailableWater': readilyAvailable,
        'irrigationIntervalDays': irrigationInterval,
        'grossFloodLiters': grossFlood,
        'grossDripLiters': grossDrip,
        'scenarioFactor': scenarioFactor,
        'adjustedNetWater': adjustedNet,
        'waterSavingsPercent': ((grossFlood - grossDrip) / grossFlood * 100),
      };
    },
    validations: [
      ValidationRule(
        description: 'ET₀ should be approximately 4.5mm/day',
        check: (output) => ((output['et0'] as num).toDouble() - 4.5).abs() < 0.5,
      ),
      ValidationRule(
        description: 'Kc for wheat mid-season should be 1.15',
        check: (output) => (output['kc'] as num).toDouble() == 1.15,
      ),
      ValidationRule(
        description: 'ETc should be ET₀ × Kc',
        check: (output) {
          final etc = output['etc'] as num;
          final et0 = output['et0'] as num;
          final kc = output['kc'] as num;
          return (etc.toDouble() - et0.toDouble() * kc.toDouble()).abs() < 0.1;
        },
      ),
      ValidationRule(
        description: 'Effective rainfall should be 60mm (60% of 100)',
        check: (output) => (output['effectiveRainfall'] as num).toDouble() == 60.0,
      ),
      ValidationRule(
        description: 'Gross drip should be less than gross flood',
        check: (output) => (output['grossDripLiters'] as num) < (output['grossFloodLiters'] as num),
      ),
      ValidationRule(
        description: 'Standard scenario factor should be 1.0',
        check: (output) => (output['scenarioFactor'] as num).toDouble() == 1.0,
      ),
      ValidationRule(
        description: 'Water savings should be approximately 44%',
        check: (output) {
          final savings = output['waterSavingsPercent'] as num;
          return savings > 40 && savings < 50;
        },
      ),
    ],
  ),
  IntegrationTestCase(
    id: 'INT_IR_002',
    description: 'Rice paddy: conservative scenario (more water)',
    input: {
      'temperature': 30.0,
      'humidity': 80.0,
      'windSpeed': 1.5,
      'sunshineHours': 7.0,
      'solarRadiation': 17.0,
      'rainfall': 50.0,
      'cropType': CropType.rice,
      'growthStage': CropGrowthStage.midSeason,
      'area': 5.0,  // hectares
      'soilType': SoilType.clay,
      'rootDepth': 0.8,
      'mad': 0.40,
      'scenario': IrrigationScenario.conservative,
    },
    run: () {
      final fao56 = FAO56Standard();
      
      final climate = ClimateData(
        temperature: 30.0,
        humidity: 80.0,
        windSpeed: 1.5,
        sunshineHours: 7.0,
        solarRadiation: 17.0,
        rainfall: 50.0,
      );
      final et0 = fao56.calculateET0(climate);
      final kc = fao56.getCropCoefficient(CropType.rice, CropGrowthStage.midSeason);
      final etc = fao56.calculateETc(et0, kc);
      final effectiveRainfall = fao56.calculateEffectiveRainfall(50.0);
      final netWater = etc * 5 * 1000;
      final scenarioFactor = fao56.getScenarioWaterFactor(IrrigationScenario.conservative);
      final adjustedNet = netWater * scenarioFactor;
      
      return {
        'et0': et0,
        'kc': kc,
        'etc': etc,
        'effectiveRainfall': effectiveRainfall,
        'netWaterLiters': netWater,
        'scenarioFactor': scenarioFactor,
        'adjustedNetWater': adjustedNet,
      };
    },
    validations: [
      ValidationRule(
        description: 'Rice mid-season Kc should be 1.20',
        check: (output) => (output['kc'] as num).toDouble() == 1.20,
      ),
      ValidationRule(
        description: 'Conservative factor should be 1.15',
        check: (output) => (output['scenarioFactor'] as num).toDouble() == 1.15,
      ),
      ValidationRule(
        description: 'Adjusted water should be 15% higher',
        check: (output) {
          final ratio = (output['adjustedNetWater'] as num) / (output['netWaterLiters'] as num);
          return (ratio - 1.15).abs() < 0.01;
        },
      ),
    ],
  ),
  IntegrationTestCase(
    id: 'INT_IR_003',
    description: 'Drip citrus: optimized scenario (less water)',
    input: {
      'temperature': 28.0,
      'humidity': 55.0,
      'windSpeed': 2.5,
      'sunshineHours': 9.0,
      'solarRadiation': 19.0,
      'rainfall': 30.0,
      'cropType': CropType.citrus,
      'growthStage': CropGrowthStage.midSeason,
      'area': 3.0,  // hectares
      'soilType': SoilType.sandyLoam,
      'rootDepth': 1.3,
      'mad': 0.55,
      'scenario': IrrigationScenario.optimized,
      'method': IrrigationMethod.drip,
    },
    run: () {
      final fao56 = FAO56Standard();
      
      final climate = ClimateData(
        temperature: 28.0,
        humidity: 55.0,
        windSpeed: 2.5,
        sunshineHours: 9.0,
        solarRadiation: 19.0,
        rainfall: 30.0,
      );
      final et0 = fao56.calculateET0(climate);
      final kc = fao56.getCropCoefficient(CropType.citrus, CropGrowthStage.midSeason);
      final etc = fao56.calculateETc(et0, kc);
      final effectiveRainfall = fao56.calculateEffectiveRainfall(30.0);
      final netWater = etc * 3 * 1000;
      final scenarioFactor = fao56.getScenarioWaterFactor(IrrigationScenario.optimized);
      final adjustedNet = netWater * scenarioFactor;
      final grossDrip = fao56.calculateGrossIrrigation(
        netIrrigation: adjustedNet,
        method: IrrigationMethod.drip,
      );
      
      // Flow network design
      final flowNode = FlowDistributionNode(
        id: 'source-1',
        name: 'Drip System Source',
        nodeType: FlowNodeType.source,
        discharge: grossDrip / 3600 / 1000,  // Convert to m³/s
        head: 30.0,
        velocity: 1.5,
        losses: 2.0,
      );
      
      return {
        'et0': et0,
        'kc': kc,
        'etc': etc,
        'effectiveRainfall': effectiveRainfall,
        'netWaterLiters': netWater,
        'scenarioFactor': scenarioFactor,
        'adjustedNetWater': adjustedNet,
        'grossDripLiters': grossDrip,
        'dischargeM3s': flowNode.discharge,
        'availableHead': flowNode.availableHead,
      };
    },
    validations: [
      ValidationRule(
        description: 'Citrus mid-season Kc should be 0.95',
        check: (output) => (output['kc'] as num).toDouble() == 0.95,
      ),
      ValidationRule(
        description: 'Optimized factor should be 0.85',
        check: (output) => (output['scenarioFactor'] as num).toDouble() == 0.85,
      ),
      ValidationRule(
        description: 'Combined savings should exceed 50%',
        check: (output) {
          final scenario = (output['scenarioFactor'] as num).toDouble();
          final method = IrrigationMethod.drip.efficiency / 100;
          final combinedSavings = 1 - (scenario * method);
          return combinedSavings > 0.5;
        },
      ),
      ValidationRule(
        description: 'Discharge should be reasonable for 3ha drip',
        check: (output) {
          final q = output['dischargeM3s'] as num;
          return q > 0.1 && q < 1.0;  // 0.1-1.0 m³/s for drip
        },
      ),
    ],
  ),
];

// ============================================================================
// RUNNER
// ============================================================================

/// Runs all road integration tests.
List<IntegrationTestResult> runRoadIntegrationTests() {
  return roadIntegrationTests.map((test) => test.execute()).toList();
}

/// Runs all irrigation integration tests.
List<IntegrationTestResult> runIrrigationIntegrationTests() {
  return irrigationIntegrationTests.map((test) => test.execute()).toList();
}

/// Converts integration results to map format for reporting.
List<Map<String, dynamic>> convertIntegrationResults(List<IntegrationTestResult> results) {
  return results.map((r) => {
    'id': r.id,
    'description': r.description,
    'passed': r.passed,
    'output': r.output,
    'validations': r.validations,
    'error': r.error,
  }).toList();
}
