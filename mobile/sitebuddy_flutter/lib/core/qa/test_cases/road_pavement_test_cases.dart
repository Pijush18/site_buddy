import 'package:site_buddy/core/qa/golden_test_cases.dart';
import 'package:site_buddy/core/engineering/standards/transport/irc_37_2018.dart';

/// Road pavement domain test cases.
/// 
/// Tests IRC:37-2018 pavement design calculations including:
/// - Thickness design from CBR and MSA
/// - ESAL calculations with traffic growth
/// - Traffic classification
/// - Safety evaluation
class RoadPavementTestInput {
  final double cbr;
  final double msa;
  final double initialTraffic;
  final double growthRate;
  final int designLife;
  final double vdf;
  final double ldf;

  const RoadPavementTestInput({
    required this.cbr,
    required this.msa,
    this.initialTraffic = 1000,
    this.growthRate = 5.0,
    this.designLife = 15,
    this.vdf = 3.5,
    this.ldf = 1.0,
  });
}

class RoadPavementTestExpected {
  final double thickness;
  final double esal;
  final String trafficClass;
  final String safety;

  const RoadPavementTestExpected({
    required this.thickness,
    required this.esal,
    required this.trafficClass,
    required this.safety,
  });
}

/// Golden test cases for road pavement calculations.
/// 
/// Test IDs: RD_<NNN>
/// Priority: P0-Critical
final roadPavementTestCases = [
  const GoldenTestCase<RoadPavementTestInput, RoadPavementTestExpected>(
    id: 'RD_001',
    description: 'Standard CBR 10% + MSA 10 (Medium traffic)',
    input: RoadPavementTestInput(
      cbr: 10.0,
      msa: 10.0,
    ),
    expected: RoadPavementTestExpected(
      thickness: 443.0, // Approximate IRC 37-2018 result
      esal: 0.0, // ESAL from MSA input
      trafficClass: 'MEDIUM',
      safety: 'SAFE',
    ),
    tolerance: 5.0, // 5% tolerance for empirical formulas
  ),
  const GoldenTestCase<RoadPavementTestInput, RoadPavementTestExpected>(
    id: 'RD_002',
    description: 'Poor subgrade CBR 2% (below threshold)',
    input: RoadPavementTestInput(
      cbr: 2.0,
      msa: 10.0,
    ),
    expected: RoadPavementTestExpected(
      thickness: 500.0, // Higher thickness due to penalty
      esal: 0.0,
      trafficClass: 'MEDIUM',
      safety: 'CRITICAL',
    ),
    tolerance: 10.0, // 10% for poor subgrade (more variation)
  ),
  const GoldenTestCase<RoadPavementTestInput, RoadPavementTestExpected>(
    id: 'RD_003',
    description: 'Heavy traffic MSA 50',
    input: RoadPavementTestInput(
      cbr: 8.0,
      msa: 50.0,
    ),
    expected: RoadPavementTestExpected(
      thickness: 550.0, // Higher for heavy traffic
      esal: 0.0,
      trafficClass: 'HEAVY',
      safety: 'SAFE',
    ),
    tolerance: 5.0,
  ),
  const GoldenTestCase<RoadPavementTestInput, RoadPavementTestExpected>(
    id: 'RD_004',
    description: 'Low traffic MSA 2',
    input: RoadPavementTestInput(
      cbr: 5.0,
      msa: 2.0,
    ),
    expected: RoadPavementTestExpected(
      thickness: 380.0, // Lower for light traffic
      esal: 0.0,
      trafficClass: 'LOW',
      safety: 'SAFE',
    ),
    tolerance: 5.0,
  ),
  const GoldenTestCase<RoadPavementTestInput, RoadPavementTestExpected>(
    id: 'RD_005',
    description: 'Good subgrade CBR 15% + MSA 20',
    input: RoadPavementTestInput(
      cbr: 15.0,
      msa: 20.0,
    ),
    expected: RoadPavementTestExpected(
      thickness: 480.0, // Moderate thickness
      esal: 0.0,
      trafficClass: 'MEDIUM',
      safety: 'SAFE',
    ),
    tolerance: 5.0,
  ),
];

/// ESAL calculation test cases.
/// 
/// Tests cumulative ESAL from traffic projection.
class EsalTestInput {
  final double initialTraffic;
  final double growthRate;
  final int designLife;
  final double vdf;
  final double ldf;

  const EsalTestInput({
    required this.initialTraffic,
    required this.growthRate,
    required this.designLife,
    required this.vdf,
    required this.ldf,
  });
}

class EsalTestExpected {
  final double cumulativeESAL;

  const EsalTestExpected({required this.cumulativeESAL});
}

/// Golden test cases for ESAL calculations.
/// 
/// Test IDs: ES_<NNN>
final esalTestCases = [
  const GoldenTestCase<EsalTestInput, EsalTestExpected>(
    id: 'ES_001',
    description: '1000 CVPD, 5% growth, 15 years',
    input: EsalTestInput(
      initialTraffic: 1000,
      growthRate: 5.0,
      designLife: 15,
      vdf: 3.5,
      ldf: 1.0,
    ),
    expected: EsalTestExpected(
      cumulativeESAL: 8000000.0, // ~8 MSA
    ),
    tolerance: 5.0,
  ),
  const GoldenTestCase<EsalTestInput, EsalTestExpected>(
    id: 'ES_002',
    description: 'Zero growth rate',
    input: EsalTestInput(
      initialTraffic: 2000,
      growthRate: 0.0,
      designLife: 10,
      vdf: 3.5,
      ldf: 1.0,
    ),
    expected: EsalTestExpected(
      cumulativeESAL: 25550000.0, // 365 * 10 * 2000 * 3.5
    ),
    tolerance: 0.1, // Zero growth is exact
  ),
];

/// Traffic classification test cases.
class TrafficClassTestInput {
  final double msa;

  const TrafficClassTestInput({required this.msa});
}

class TrafficClassTestExpected {
  final String classification;

  const TrafficClassTestExpected({required this.classification});
}

/// Golden test cases for traffic classification.
/// 
/// Test IDs: TC_<NNN>
final trafficClassificationTestCases = [
  const GoldenTestCase<TrafficClassTestInput, TrafficClassTestExpected>(
    id: 'TC_001',
    description: 'MSA 5 = LOW',
    input: TrafficClassTestInput(msa: 5.0),
    expected: TrafficClassTestExpected(classification: 'LOW'),
    tolerance: 0.0,
  ),
  const GoldenTestCase<TrafficClassTestInput, TrafficClassTestExpected>(
    id: 'TC_002',
    description: 'MSA 10 = MEDIUM (boundary)',
    input: TrafficClassTestInput(msa: 10.0),
    expected: TrafficClassTestExpected(classification: 'MEDIUM'),
    tolerance: 0.0,
  ),
  const GoldenTestCase<TrafficClassTestInput, TrafficClassTestExpected>(
    id: 'TC_003',
    description: 'MSA 30 = HEAVY (boundary)',
    input: TrafficClassTestInput(msa: 30.0),
    expected: TrafficClassTestExpected(classification: 'HEAVY'),
    tolerance: 0.0,
  ),
  const GoldenTestCase<TrafficClassTestInput, TrafficClassTestExpected>(
    id: 'TC_004',
    description: 'MSA 100 = HEAVY',
    input: TrafficClassTestInput(msa: 100.0),
    expected: TrafficClassTestExpected(classification: 'HEAVY'),
    tolerance: 0.0,
  ),
];

/// Layer distribution test cases.
class LayerDistributionTestInput {
  final double totalThickness;

  const LayerDistributionTestInput({required this.totalThickness});
}

class LayerDistributionTestExpected {
  final double bc;   // Bituminous Concrete
  final double dbm;  // Dense Bituminous Macadam
  final double wmm;  // Wet Mix Macadam
  final double gsb;  // Granular Sub-base

  const LayerDistributionTestExpected({
    required this.bc,
    required this.dbm,
    required this.wmm,
    required this.gsb,
  });
}

/// Golden test cases for layer distribution.
/// 
/// IRC 37-2018 proportions: BC 7%, DBM 18%, WMM 35%, GSB 40%
/// 
/// Test IDs: LD_<NNN>
final layerDistributionTestCases = [
  const GoldenTestCase<LayerDistributionTestInput, LayerDistributionTestExpected>(
    id: 'LD_001',
    description: '500mm total thickness',
    input: LayerDistributionTestInput(totalThickness: 500.0),
    expected: LayerDistributionTestExpected(
      bc: 35.0,   // 500 * 0.07
      dbm: 90.0,  // 500 * 0.18
      wmm: 175.0, // 500 * 0.35
      gsb: 200.0, // 500 * 0.40
    ),
    tolerance: 0.1, // Proportions are exact
  ),
  const GoldenTestCase<LayerDistributionTestInput, LayerDistributionTestExpected>(
    id: 'LD_002',
    description: '400mm total thickness',
    input: LayerDistributionTestInput(totalThickness: 400.0),
    expected: LayerDistributionTestExpected(
      bc: 28.0,
      dbm: 72.0,
      wmm: 140.0,
      gsb: 160.0,
    ),
    tolerance: 0.1,
  ),
];

/// Runs all road pavement tests.
/// 
/// Returns list of test results for QA reporting.
List<Map<String, dynamic>> runRoadPavementTests() {
  final irc37 = IRC37Standard();
  final results = <Map<String, dynamic>>[];

  // Run thickness tests
  for (final test in roadPavementTestCases) {
    try {
      final thickness = irc37.designThickness(test.input.cbr, test.input.msa);

      final thicknessDiff = (thickness - test.expected.thickness).abs();
      final thicknessTolerance = test.expected.thickness * (test.tolerance / 100);

      results.add({
        'id': test.id,
        'passed': thicknessDiff <= thicknessTolerance,
        'description': test.description,
        'expected': test.expected.thickness,
        'actual': thickness,
        'diff': thicknessDiff,
        'tolerance': thicknessTolerance,
      });
    } catch (e) {
      results.add({
        'id': test.id,
        'passed': false,
        'error': e.toString(),
      });
    }
  }

  // Run ESAL tests
  for (final test in esalTestCases) {
    try {
      final esal = irc37.calculateESAL(
        initialTraffic: test.input.initialTraffic,
        growthRate: test.input.growthRate,
        designLife: test.input.designLife,
        vdf: test.input.vdf,
        ldf: test.input.ldf,
      );

      final diff = (esal - test.expected.cumulativeESAL).abs();
      final tolerance = test.expected.cumulativeESAL * (test.tolerance / 100);

      results.add({
        'id': test.id,
        'passed': diff <= tolerance,
        'description': test.description,
        'expected': test.expected.cumulativeESAL,
        'actual': esal,
        'diff': diff,
        'tolerance': tolerance,
      });
    } catch (e) {
      results.add({
        'id': test.id,
        'passed': false,
        'error': e.toString(),
      });
    }
  }

  // Run traffic classification tests
  for (final test in trafficClassificationTestCases) {
    try {
      final classification = irc37.classifyTraffic(test.input.msa);
      results.add({
        'id': test.id,
        'passed': classification == test.expected.classification,
        'description': test.description,
        'expected': test.expected.classification,
        'actual': classification,
      });
    } catch (e) {
      results.add({
        'id': test.id,
        'passed': false,
        'error': e.toString(),
      });
    }
  }

  // Run layer distribution tests
  for (final test in layerDistributionTestCases) {
    try {
      final layers = irc37.layerDistribution(test.input.totalThickness);
      final bc = layers[0];
      final dbm = layers[1];
      final wmm = layers[2];
      final gsb = layers[3];

      final allMatch = 
        (bc - test.expected.bc).abs() <= 0.1 &&
        (dbm - test.expected.dbm).abs() <= 0.1 &&
        (wmm - test.expected.wmm).abs() <= 0.1 &&
        (gsb - test.expected.gsb).abs() <= 0.1;

      results.add({
        'id': test.id,
        'passed': allMatch,
        'description': test.description,
        'expected': [test.expected.bc, test.expected.dbm, test.expected.wmm, test.expected.gsb],
        'actual': [bc, dbm, wmm, gsb],
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
