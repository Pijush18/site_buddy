import 'package:site_buddy/core/qa/golden_test_cases.dart';
import 'package:site_buddy/core/engineering/standards/irrigation/fao_56_standard.dart';
import 'package:site_buddy/core/engineering/standards/transport/irc_37_2018.dart';
import 'package:site_buddy/features/water/irrigation/domain/models/scenario_models.dart';
import 'package:site_buddy/features/transport/road/domain/models/traffic_growth.dart';

/// Scenario consistency test cases.
/// 
/// Critical validation: Ensures scenario factors follow the expected ordering:
/// - Conservative ≥ Standard ≥ Optimized (for safety factors)
/// - Conservative ≥ Standard ≥ Optimized (for traffic factors)
/// - Conservative ≥ Standard ≥ Optimized (for water factors)
/// 
/// This is P0-Critical for engineering reliability.
class ScenarioConsistencyTestInput {
  final String scenarioGroup; // 'road' or 'irrigation'

  const ScenarioConsistencyTestInput({required this.scenarioGroup});
}

class ScenarioConsistencyTestExpected {
  final double conservativeFactor;
  final double standardFactor;
  final double optimizedFactor;
  final bool consistent;

  const ScenarioConsistencyTestExpected({
    required this.conservativeFactor,
    required this.standardFactor,
    required this.optimizedFactor,
    required this.consistent,
  });
}

/// Golden test cases for scenario factor consistency.
/// 
/// Test IDs: SC_<NNN>
/// Priority: P0-Critical
/// 
/// CRITICAL CONSTRAINT:
/// - conservativeFactor >= standardFactor >= optimizedFactor
/// - For water/traffic buffers: conservative > 1.0, optimized < 1.0
final scenarioConsistencyTestCases = [
  const GoldenTestCase<ScenarioConsistencyTestInput, ScenarioConsistencyTestExpected>(
    id: 'SC_001',
    description: 'Road traffic factors: conservative=1.2, standard=1.0, optimized=0.9',
    input: ScenarioConsistencyTestInput(scenarioGroup: 'road'),
    expected: ScenarioConsistencyTestExpected(
      conservativeFactor: 1.2,
      standardFactor: 1.0,
      optimizedFactor: 0.9,
      consistent: true, // 1.2 >= 1.0 >= 0.9 ✓
    ),
    tolerance: 0.0,
  ),
  const GoldenTestCase<ScenarioConsistencyTestInput, ScenarioConsistencyTestExpected>(
    id: 'SC_002',
    description: 'Irrigation water factors: conservative=1.15, standard=1.0, optimized=0.85',
    input: ScenarioConsistencyTestInput(scenarioGroup: 'irrigation'),
    expected: ScenarioConsistencyTestExpected(
      conservativeFactor: 1.15,
      standardFactor: 1.0,
      optimizedFactor: 0.85,
      consistent: true, // 1.15 >= 1.0 >= 0.85 ✓
    ),
    tolerance: 0.0,
  ),
];

/// Road scenario factor consistency validation.
class RoadScenarioFactor {
  final DesignScenario scenario;
  final double factor;

  const RoadScenarioFactor({required this.scenario, required this.factor});
}

/// Irrigation scenario factor validation.
class IrrigationScenarioFactor {
  final IrrigationScenario scenario;
  final double factor;

  const IrrigationScenarioFactor({required this.scenario, required this.factor});
}

/// Edge case scenario tests.
class EdgeCaseScenarioInput {
  final String type; // 'road' or 'irrigation'
  final int scenarioIndex; // 0=conservative, 1=standard, 2=optimized

  const EdgeCaseScenarioInput({
    required this.type,
    required this.scenarioIndex,
  });
}

class EdgeCaseScenarioExpected {
  final bool valid;
  final String description;

  const EdgeCaseScenarioExpected({
    required this.valid,
    required this.description,
  });
}

/// Golden test cases for scenario edge cases.
/// 
/// Test IDs: EC_<NNN>
final scenarioEdgeCaseTestCases = [
  const GoldenTestCase<EdgeCaseScenarioInput, EdgeCaseScenarioExpected>(
    id: 'EC_001',
    description: 'Road conservative scenario has factor > 1.0',
    input: EdgeCaseScenarioInput(type: 'road', scenarioIndex: 0),
    expected: EdgeCaseScenarioExpected(
      valid: true,
      description: 'Conservative adds +20% buffer',
    ),
    tolerance: 0.0,
  ),
  const GoldenTestCase<EdgeCaseScenarioInput, EdgeCaseScenarioExpected>(
    id: 'EC_002',
    description: 'Road standard scenario has factor = 1.0',
    input: EdgeCaseScenarioInput(type: 'road', scenarioIndex: 1),
    expected: EdgeCaseScenarioExpected(
      valid: true,
      description: 'Standard is base IRC 37 requirements',
    ),
    tolerance: 0.0,
  ),
  const GoldenTestCase<EdgeCaseScenarioInput, EdgeCaseScenarioExpected>(
    id: 'EC_003',
    description: 'Road optimized scenario has factor < 1.0',
    input: EdgeCaseScenarioInput(type: 'road', scenarioIndex: 2),
    expected: EdgeCaseScenarioExpected(
      valid: true,
      description: 'Optimized allows -10% traffic',
    ),
    tolerance: 0.0,
  ),
  const GoldenTestCase<EdgeCaseScenarioInput, EdgeCaseScenarioExpected>(
    id: 'EC_004',
    description: 'Irrigation conservative scenario has factor > 1.0',
    input: EdgeCaseScenarioInput(type: 'irrigation', scenarioIndex: 0),
    expected: EdgeCaseScenarioExpected(
      valid: true,
      description: 'Conservative adds +15% water',
    ),
    tolerance: 0.0,
  ),
  const GoldenTestCase<EdgeCaseScenarioInput, EdgeCaseScenarioExpected>(
    id: 'EC_005',
    description: 'Irrigation standard scenario has factor = 1.0',
    input: EdgeCaseScenarioInput(type: 'irrigation', scenarioIndex: 1),
    expected: EdgeCaseScenarioExpected(
      valid: true,
      description: 'Standard is base FAO-56',
    ),
    tolerance: 0.0,
  ),
  const GoldenTestCase<EdgeCaseScenarioInput, EdgeCaseScenarioExpected>(
    id: 'EC_006',
    description: 'Irrigation optimized scenario has factor < 1.0',
    input: EdgeCaseScenarioInput(type: 'irrigation', scenarioIndex: 2),
    expected: EdgeCaseScenarioExpected(
      valid: true,
      description: 'Optimized allows -15% water',
    ),
    tolerance: 0.0,
  ),
];

/// Water adequacy assessment test cases.
class WaterAdequacyTestInput {
  final double waterAvailable;
  final double waterRequired;

  const WaterAdequacyTestInput({
    required this.waterAvailable,
    required this.waterRequired,
  });
}

class WaterAdequacyTestExpected {
  final String assessment;
  final String category;

  const WaterAdequacyTestExpected({
    required this.assessment,
    required this.category,
  });
}

/// Golden test cases for water adequacy assessment.
/// 
/// Assessment thresholds:
/// - ratio >= 1.2: EXCELLENT
/// - ratio >= 1.0: ADEQUATE
/// - ratio >= 0.8: MARGINAL
/// - ratio >= 0.6: INADEQUATE
/// - ratio < 0.6: CRITICAL
/// 
/// Test IDs: WA_<NNN>
final waterAdequacyTestCases = [
  const GoldenTestCase<WaterAdequacyTestInput, WaterAdequacyTestExpected>(
    id: 'WA_001',
    description: 'Water available 120% of requirement = EXCELLENT',
    input: WaterAdequacyTestInput(
      waterAvailable: 120.0,
      waterRequired: 100.0,
    ),
    expected: WaterAdequacyTestExpected(
      assessment: 'EXCELLENT',
      category: 'SURPLUS',
    ),
    tolerance: 0.0,
  ),
  const GoldenTestCase<WaterAdequacyTestInput, WaterAdequacyTestExpected>(
    id: 'WA_002',
    description: 'Water available 100% of requirement = ADEQUATE',
    input: WaterAdequacyTestInput(
      waterAvailable: 100.0,
      waterRequired: 100.0,
    ),
    expected: WaterAdequacyTestExpected(
      assessment: 'ADEQUATE',
      category: 'BALANCED',
    ),
    tolerance: 0.0,
  ),
  const GoldenTestCase<WaterAdequacyTestInput, WaterAdequacyTestExpected>(
    id: 'WA_003',
    description: 'Water available 90% of requirement = MARGINAL',
    input: WaterAdequacyTestInput(
      waterAvailable: 90.0,
      waterRequired: 100.0,
    ),
    expected: WaterAdequacyTestExpected(
      assessment: 'MARGINAL',
      category: 'DEFICIT',
    ),
    tolerance: 0.0,
  ),
  const GoldenTestCase<WaterAdequacyTestInput, WaterAdequacyTestExpected>(
    id: 'WA_004',
    description: 'Water available 50% of requirement = CRITICAL',
    input: WaterAdequacyTestInput(
      waterAvailable: 50.0,
      waterRequired: 100.0,
    ),
    expected: WaterAdequacyTestExpected(
      assessment: 'CRITICAL',
      category: 'SEVERE_DEFICIT',
    ),
    tolerance: 0.0,
  ),
];

/// Runs all scenario consistency tests.
/// 
/// Returns list of test results for QA reporting.
List<Map<String, dynamic>> runScenarioConsistencyTests() {
  final irc37 = IRC37Standard();
  final fao56 = FAO56Standard();
  final results = <Map<String, dynamic>>[];

  // Run scenario consistency tests
  for (final test in scenarioConsistencyTestCases) {
    try {
      if (test.input.scenarioGroup == 'road') {
        final conservative = irc37.getScenarioTrafficFactor(DesignScenario.conservative);
        final standard = irc37.getScenarioTrafficFactor(DesignScenario.standard);
        final optimized = irc37.getScenarioTrafficFactor(DesignScenario.optimized);
        
        final consistent = 
          conservative >= standard && 
          standard >= optimized &&
          conservative > 1.0 &&
          standard == 1.0 &&
          optimized < 1.0;

        results.add({
          'id': test.id,
          'passed': consistent && 
            (conservative - test.expected.conservativeFactor).abs() <= 0.01 &&
            (standard - test.expected.standardFactor).abs() <= 0.01 &&
            (optimized - test.expected.optimizedFactor).abs() <= 0.01,
          'description': test.description,
          'expected': {
            'conservativeFactor': test.expected.conservativeFactor,
            'standardFactor': test.expected.standardFactor,
            'optimizedFactor': test.expected.optimizedFactor,
            'consistent': test.expected.consistent,
          },
          'actual': {
            'conservativeFactor': conservative,
            'standardFactor': standard,
            'optimizedFactor': optimized,
            'consistent': consistent,
          },
        });
      } else {
        final conservative = fao56.getScenarioWaterFactor(IrrigationScenario.conservative);
        final standard = fao56.getScenarioWaterFactor(IrrigationScenario.standard);
        final optimized = fao56.getScenarioWaterFactor(IrrigationScenario.optimized);
        
        final consistent = 
          conservative >= standard && 
          standard >= optimized &&
          conservative > 1.0 &&
          standard == 1.0 &&
          optimized < 1.0;

        results.add({
          'id': test.id,
          'passed': consistent && 
            (conservative - test.expected.conservativeFactor).abs() <= 0.01 &&
            (standard - test.expected.standardFactor).abs() <= 0.01 &&
            (optimized - test.expected.optimizedFactor).abs() <= 0.01,
          'description': test.description,
          'expected': {
            'conservativeFactor': test.expected.conservativeFactor,
            'standardFactor': test.expected.standardFactor,
            'optimizedFactor': test.expected.optimizedFactor,
            'consistent': test.expected.consistent,
          },
          'actual': {
            'conservativeFactor': conservative,
            'standardFactor': standard,
            'optimizedFactor': optimized,
            'consistent': consistent,
          },
        });
      }
    } catch (e) {
      results.add({
        'id': test.id,
        'passed': false,
        'error': e.toString(),
      });
    }
  }

  // Run edge case tests
  for (final test in scenarioEdgeCaseTestCases) {
    try {
      bool valid = false;
      if (test.input.type == 'road') {
        final scenarios = [
          DesignScenario.conservative,
          DesignScenario.standard,
          DesignScenario.optimized,
        ];
        final scenario = scenarios[test.input.scenarioIndex];
        final factor = irc37.getScenarioTrafficFactor(scenario);
        
        if (scenario == DesignScenario.conservative) {
          valid = factor > 1.0;
        } else if (scenario == DesignScenario.standard) {
          valid = factor == 1.0;
        } else {
          valid = factor < 1.0;
        }
      } else {
        final scenarios = [
          IrrigationScenario.conservative,
          IrrigationScenario.standard,
          IrrigationScenario.optimized,
        ];
        final scenario = scenarios[test.input.scenarioIndex];
        final factor = fao56.getScenarioWaterFactor(scenario);
        
        if (scenario == IrrigationScenario.conservative) {
          valid = factor > 1.0;
        } else if (scenario == IrrigationScenario.standard) {
          valid = factor == 1.0;
        } else {
          valid = factor < 1.0;
        }
      }

      results.add({
        'id': test.id,
        'passed': valid == test.expected.valid,
        'description': test.description,
        'expected': test.expected.description,
        'actual': valid ? 'Valid' : 'Invalid',
      });
    } catch (e) {
      results.add({
        'id': test.id,
        'passed': false,
        'error': e.toString(),
      });
    }
  }

  // Run water adequacy tests
  for (final test in waterAdequacyTestCases) {
    try {
      final assessment = fao56.evaluateWaterAdequacy(
        test.input.waterAvailable,
        test.input.waterRequired,
      );
      
      String category = 'UNKNOWN';
      if (assessment.startsWith('EXCELLENT')) {
        category = 'SURPLUS';
      } else if (assessment.startsWith('ADEQUATE')) {
        category = 'BALANCED';
      } else if (assessment.startsWith('MARGINAL')) {
        category = 'DEFICIT';
      } else if (assessment.startsWith('INADEQUATE')) {
        category = 'SEVERE_DEFICIT';
      } else if (assessment.startsWith('CRITICAL')) {
        category = 'SEVERE_DEFICIT';
      }

      results.add({
        'id': test.id,
        'passed': 
          assessment.startsWith(test.expected.assessment) &&
          category == test.expected.category,
        'description': test.description,
        'expected': {
          'assessment': test.expected.assessment,
          'category': test.expected.category,
        },
        'actual': {
          'assessment': assessment.split(':').first,
          'category': category,
        },
      });
    } catch (e) {
      results.add({
        'id': test.id,
        'passed': false,
        'error': e.toString(),
      });
    }
  }

  return results;
}

/// Validates cross-module scenario isolation.
/// 
/// Ensures that road and irrigation scenarios are independent
/// and don't share state or factors.
List<Map<String, dynamic>> runCrossModuleIsolationTests() {
  final irc37 = IRC37Standard();
  final fao56 = FAO56Standard();
  final results = <Map<String, dynamic>>[];

  // Test: Road and irrigation scenario factors are independent
  try {
    final roadConservative = irc37.getScenarioTrafficFactor(DesignScenario.conservative);
    final irrigationConservative = fao56.getScenarioWaterFactor(IrrigationScenario.conservative);
    
    // These should be different values (1.2 vs 1.15)
    final independent = roadConservative != irrigationConservative;
    
    results.add({
      'id': 'ISO_001',
      'passed': independent,
      'description': 'Road and irrigation conservative factors are independent',
      'expected': 'Different values (1.2 vs 1.15)',
      'actual': 'Road=$roadConservative, Irrigation=$irrigationConservative',
    });
  } catch (e) {
    results.add({
      'id': 'ISO_001',
      'passed': false,
      'error': e.toString(),
    });
  }

  // Test: Same scenario type gives same factor regardless of module
  try {
    final roadStandard = irc37.getScenarioTrafficFactor(DesignScenario.standard);
    final irrigationStandard = fao56.getScenarioWaterFactor(IrrigationScenario.standard);
    
    // Both should be 1.0 (base standard)
    final bothStandard = roadStandard == 1.0 && irrigationStandard == 1.0;
    
    results.add({
      'id': 'ISO_002',
      'passed': bothStandard,
      'description': 'Standard scenario is base for both modules',
      'expected': 'Both = 1.0',
      'actual': 'Road=$roadStandard, Irrigation=$irrigationStandard',
    });
  } catch (e) {
    results.add({
      'id': 'ISO_002',
      'passed': false,
      'error': e.toString(),
    });
  }

  return results;
}
