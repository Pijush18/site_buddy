import 'package:site_buddy/core/qa/golden_test_cases.dart';
import 'package:site_buddy/features/water/irrigation/domain/models/soil_models.dart';

/// Soil moisture balance test cases.
/// 
/// Tests soil irrigation logic including:
/// - Soil property calculations
/// - Available water capacity
/// - Irrigation interval estimation
/// - Moisture depletion modeling
class SoilMoistureTestInput {
  final SoilType soilType;
  final double rootZoneDepth;
  final double depletionAllowable;
  final double dailyETc;

  const SoilMoistureTestInput({
    required this.soilType,
    required this.rootZoneDepth,
    required this.depletionAllowable,
    required this.dailyETc,
  });
}

class SoilMoistureTestExpected {
  final double fieldCapacity;
  final double wiltingPoint;
  final double availableWater;
  final double totalAvailableWater;
  final double readilyAvailableWater;
  final double irrigationInterval;

  const SoilMoistureTestExpected({
    required this.fieldCapacity,
    required this.wiltingPoint,
    required this.availableWater,
    required this.totalAvailableWater,
    required this.readilyAvailableWater,
    required this.irrigationInterval,
  });
}

/// Golden test cases for soil moisture calculations.
/// 
/// Test IDs: SM_`NNN`
/// Priority: P1-High
final soilMoistureTestCases = [
  const GoldenTestCase<SoilMoistureTestInput, SoilMoistureTestExpected>(
    id: 'SM_001',
    description: 'Loam soil, 1.2m root depth, 50% MAD',
    input: SoilMoistureTestInput(
      soilType: SoilType.loam,
      rootZoneDepth: 1.2,
      depletionAllowable: 0.50,
      dailyETc: 5.0,
    ),
    expected: SoilMoistureTestExpected(
      fieldCapacity: 27.0,
      wiltingPoint: 12.0,
      availableWater: 15.0,    // 27 - 12
      totalAvailableWater: 18.0, // 15 * 1.2
      readilyAvailableWater: 9.0, // 18 * 0.50
      irrigationInterval: 1.8,    // 9 / 5
    ),
    tolerance: 5.0, // 5% for typical soil values
  ),
  const GoldenTestCase<SoilMoistureTestInput, SoilMoistureTestExpected>(
    id: 'SM_002',
    description: 'Clay soil, 0.8m root depth, 40% MAD',
    input: SoilMoistureTestInput(
      soilType: SoilType.clay,
      rootZoneDepth: 0.8,
      depletionAllowable: 0.40,
      dailyETc: 4.0,
    ),
    expected: SoilMoistureTestExpected(
      fieldCapacity: 36.0,
      wiltingPoint: 18.0,
      availableWater: 18.0,    // 36 - 18
      totalAvailableWater: 14.4, // 18 * 0.8
      readilyAvailableWater: 5.76, // 14.4 * 0.40
      irrigationInterval: 1.44,    // 5.76 / 4
    ),
    tolerance: 5.0,
  ),
  const GoldenTestCase<SoilMoistureTestInput, SoilMoistureTestExpected>(
    id: 'SM_003',
    description: 'Sandy loam, 1.3m root depth, 55% MAD',
    input: SoilMoistureTestInput(
      soilType: SoilType.sandyLoam,
      rootZoneDepth: 1.3,
      depletionAllowable: 0.55,
      dailyETc: 6.0,
    ),
    expected: SoilMoistureTestExpected(
      fieldCapacity: 18.0,
      wiltingPoint: 6.0,
      availableWater: 12.0,    // 18 - 6
      totalAvailableWater: 15.6, // 12 * 1.3
      readilyAvailableWater: 8.58, // 15.6 * 0.55
      irrigationInterval: 1.43,    // 8.58 / 6
    ),
    tolerance: 5.0,
  ),
  const GoldenTestCase<SoilMoistureTestInput, SoilMoistureTestExpected>(
    id: 'SM_004',
    description: 'Silty clay, 0.9m root depth, 45% MAD',
    input: SoilMoistureTestInput(
      soilType: SoilType.siltyClay,
      rootZoneDepth: 0.9,
      depletionAllowable: 0.45,
      dailyETc: 3.5,
    ),
    expected: SoilMoistureTestExpected(
      fieldCapacity: 34.0,
      wiltingPoint: 16.0,
      availableWater: 18.0,    // 34 - 16
      totalAvailableWater: 16.2, // 18 * 0.9
      readilyAvailableWater: 7.29, // 16.2 * 0.45
      irrigationInterval: 2.08,    // 7.29 / 3.5
    ),
    tolerance: 5.0,
  ),
];

/// Soil type property test cases.
class SoilPropertyTestInput {
  final SoilType soilType;

  const SoilPropertyTestInput({required this.soilType});
}

class SoilPropertyTestExpected {
  final String displayName;
  final double fieldCapacity;
  final double wiltingPoint;
  final double availableWater;
  final double infiltrationRate;

  const SoilPropertyTestExpected({
    required this.displayName,
    required this.fieldCapacity,
    required this.wiltingPoint,
    required this.availableWater,
    required this.infiltrationRate,
  });
}

/// Golden test cases for soil type properties.
/// 
/// Test IDs: SP_`NNN`
final soilPropertyTestCases = [
  const GoldenTestCase<SoilPropertyTestInput, SoilPropertyTestExpected>(
    id: 'SP_001',
    description: 'Clay properties',
    input: SoilPropertyTestInput(soilType: SoilType.clay),
    expected: SoilPropertyTestExpected(
      displayName: 'Clay',
      fieldCapacity: 36.0,
      wiltingPoint: 18.0,
      availableWater: 18.0,
      infiltrationRate: 5.0,
    ),
    tolerance: 0.0, // Exact values
  ),
  const GoldenTestCase<SoilPropertyTestInput, SoilPropertyTestExpected>(
    id: 'SP_002',
    description: 'Loam properties',
    input: SoilPropertyTestInput(soilType: SoilType.loam),
    expected: SoilPropertyTestExpected(
      displayName: 'Loam',
      fieldCapacity: 27.0,
      wiltingPoint: 12.0,
      availableWater: 15.0,
      infiltrationRate: 25.0,
    ),
    tolerance: 0.0,
  ),
  const GoldenTestCase<SoilPropertyTestInput, SoilPropertyTestExpected>(
    id: 'SP_003',
    description: 'Sand properties',
    input: SoilPropertyTestInput(soilType: SoilType.sand),
    expected: SoilPropertyTestExpected(
      displayName: 'Sand',
      fieldCapacity: 10.0,
      wiltingPoint: 4.0,
      availableWater: 6.0,
      infiltrationRate: 50.0,
    ),
    tolerance: 0.0,
  ),
  const GoldenTestCase<SoilPropertyTestInput, SoilPropertyTestExpected>(
    id: 'SP_004',
    description: 'Gravel properties',
    input: SoilPropertyTestInput(soilType: SoilType.gravel),
    expected: SoilPropertyTestExpected(
      displayName: 'Gravel',
      fieldCapacity: 8.0,
      wiltingPoint: 3.0,
      availableWater: 5.0,
      infiltrationRate: 75.0,
    ),
    tolerance: 0.0,
  ),
];

/// Irrigation method efficiency test cases.
class IrrigationMethodTestInput {
  final IrrigationMethod method;

  const IrrigationMethodTestInput({required this.method});
}

class IrrigationMethodTestExpected {
  final String displayName;
  final double efficiency;
  final double applicationRate;
  final double waterSavingFactor;

  const IrrigationMethodTestExpected({
    required this.displayName,
    required this.efficiency,
    required this.applicationRate,
    required this.waterSavingFactor,
  });
}

/// Golden test cases for irrigation method properties.
/// 
/// Test IDs: IM_`NNN`
final irrigationMethodTestCases = [
  const GoldenTestCase<IrrigationMethodTestInput, IrrigationMethodTestExpected>(
    id: 'IM_001',
    description: 'Flood irrigation (lowest efficiency)',
    input: IrrigationMethodTestInput(method: IrrigationMethod.flood),
    expected: IrrigationMethodTestExpected(
      displayName: 'Flood/Basin',
      efficiency: 50.0,
      applicationRate: 10.0,
      waterSavingFactor: 1.0,
    ),
    tolerance: 0.0,
  ),
  const GoldenTestCase<IrrigationMethodTestInput, IrrigationMethodTestExpected>(
    id: 'IM_002',
    description: 'Drip irrigation (highest efficiency)',
    input: IrrigationMethodTestInput(method: IrrigationMethod.drip),
    expected: IrrigationMethodTestExpected(
      displayName: 'Drip/Trickle',
      efficiency: 90.0,
      applicationRate: 2.0,
      waterSavingFactor: 0.55,
    ),
    tolerance: 0.0,
  ),
  const GoldenTestCase<IrrigationMethodTestInput, IrrigationMethodTestExpected>(
    id: 'IM_003',
    description: 'Sprinkler irrigation',
    input: IrrigationMethodTestInput(method: IrrigationMethod.sprinkler),
    expected: IrrigationMethodTestExpected(
      displayName: 'Sprinkler',
      efficiency: 75.0,
      applicationRate: 5.0,
      waterSavingFactor: 0.70,
    ),
    tolerance: 0.0,
  ),
  const GoldenTestCase<IrrigationMethodTestInput, IrrigationMethodTestExpected>(
    id: 'IM_004',
    description: 'Center pivot irrigation',
    input: IrrigationMethodTestInput(method: IrrigationMethod.centerPivot),
    expected: IrrigationMethodTestExpected(
      displayName: 'Center Pivot',
      efficiency: 80.0,
      applicationRate: 6.0,
      waterSavingFactor: 0.65,
    ),
    tolerance: 0.0,
  ),
];

/// Gross irrigation calculation test cases.
class GrossIrrigationTestInput {
  final double netIrrigation;
  final IrrigationMethod method;

  const GrossIrrigationTestInput({
    required this.netIrrigation,
    required this.method,
  });
}

class GrossIrrigationTestExpected {
  final double grossIrrigation;

  const GrossIrrigationTestExpected({required this.grossIrrigation});
}

/// Golden test cases for gross irrigation calculation.
/// 
/// Gross = Net / (Efficiency / 100)
/// 
/// Test IDs: GI_`NNN`
final grossIrrigationTestCases = [
  const GoldenTestCase<GrossIrrigationTestInput, GrossIrrigationTestExpected>(
    id: 'GI_001',
    description: '100mm net, flood (50% efficiency)',
    input: GrossIrrigationTestInput(
      netIrrigation: 100.0,
      method: IrrigationMethod.flood,
    ),
    expected: GrossIrrigationTestExpected(grossIrrigation: 200.0), // 100 / 0.50
    tolerance: 0.0,
  ),
  const GoldenTestCase<GrossIrrigationTestInput, GrossIrrigationTestExpected>(
    id: 'GI_002',
    description: '100mm net, drip (90% efficiency)',
    input: GrossIrrigationTestInput(
      netIrrigation: 100.0,
      method: IrrigationMethod.drip,
    ),
    expected: GrossIrrigationTestExpected(grossIrrigation: 111.1), // 100 / 0.90
    tolerance: 0.1,
  ),
  const GoldenTestCase<GrossIrrigationTestInput, GrossIrrigationTestExpected>(
    id: 'GI_003',
    description: '50mm net, sprinkler (75% efficiency)',
    input: GrossIrrigationTestInput(
      netIrrigation: 50.0,
      method: IrrigationMethod.sprinkler,
    ),
    expected: GrossIrrigationTestExpected(grossIrrigation: 66.67), // 50 / 0.75
    tolerance: 0.1,
  ),
  const GoldenTestCase<GrossIrrigationTestInput, GrossIrrigationTestExpected>(
    id: 'GI_004',
    description: '75mm net, furrow (60% efficiency)',
    input: GrossIrrigationTestInput(
      netIrrigation: 75.0,
      method: IrrigationMethod.furrow,
    ),
    expected: GrossIrrigationTestExpected(grossIrrigation: 125.0), // 75 / 0.60
    tolerance: 0.0,
  ),
];

/// Runs all soil moisture tests.
/// 
/// Returns list of test results for QA reporting.
List<Map<String, dynamic>> runSoilMoistureTests() {
  final results = <Map<String, dynamic>>[];

  // Run soil moisture balance tests
  for (final test in soilMoistureTestCases) {
    try {
      final soilModel = SoilIrrigationModel(
        soilType: test.input.soilType,
        effectiveRainfall: 0,
        fieldCapacity: test.input.soilType.fieldCapacity,
        wiltingPoint: test.input.soilType.wiltingPoint,
        availableWater: test.input.soilType.availableWater,
        infiltrationRate: test.input.soilType.infiltrationRate,
        rootZoneDepth: test.input.rootZoneDepth,
        depletionAllowable: test.input.depletionAllowable,
      );

      final interval = soilModel.irrigationInterval(test.input.dailyETc);

      final fcDiff = (soilModel.fieldCapacity - test.expected.fieldCapacity).abs();
      final wpDiff = (soilModel.wiltingPoint - test.expected.wiltingPoint).abs();
      final awDiff = (soilModel.availableWater - test.expected.availableWater).abs();
      final taDiff = (soilModel.totalAvailableWater - test.expected.totalAvailableWater).abs();
      final raDiff = (soilModel.readilyAvailableWater - test.expected.readilyAvailableWater).abs();
      final intDiff = (interval - test.expected.irrigationInterval).abs();

      final tolerance = test.expected.irrigationInterval * (test.tolerance / 100);

      results.add({
        'id': test.id,
        'passed': 
          fcDiff <= 0.1 &&
          wpDiff <= 0.1 &&
          awDiff <= 0.1 &&
          taDiff <= tolerance &&
          raDiff <= tolerance &&
          intDiff <= tolerance,
        'description': test.description,
        'expected': {
          'fieldCapacity': test.expected.fieldCapacity,
          'wiltingPoint': test.expected.wiltingPoint,
          'availableWater': test.expected.availableWater,
          'totalAvailableWater': test.expected.totalAvailableWater,
          'readilyAvailableWater': test.expected.readilyAvailableWater,
          'irrigationInterval': test.expected.irrigationInterval,
        },
        'actual': {
          'fieldCapacity': soilModel.fieldCapacity,
          'wiltingPoint': soilModel.wiltingPoint,
          'availableWater': soilModel.availableWater,
          'totalAvailableWater': soilModel.totalAvailableWater,
          'readilyAvailableWater': soilModel.readilyAvailableWater,
          'irrigationInterval': interval,
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

  // Run soil property tests
  for (final test in soilPropertyTestCases) {
    try {
      results.add({
        'id': test.id,
        'passed': 
          test.input.soilType.displayName == test.expected.displayName &&
          (test.input.soilType.fieldCapacity - test.expected.fieldCapacity).abs() <= test.tolerance &&
          (test.input.soilType.wiltingPoint - test.expected.wiltingPoint).abs() <= test.tolerance &&
          (test.input.soilType.availableWater - test.expected.availableWater).abs() <= test.tolerance &&
          (test.input.soilType.infiltrationRate - test.expected.infiltrationRate).abs() <= test.tolerance,
        'description': test.description,
        'expected': {
          'displayName': test.expected.displayName,
          'fieldCapacity': test.expected.fieldCapacity,
          'wiltingPoint': test.expected.wiltingPoint,
          'availableWater': test.expected.availableWater,
          'infiltrationRate': test.expected.infiltrationRate,
        },
        'actual': {
          'displayName': test.input.soilType.displayName,
          'fieldCapacity': test.input.soilType.fieldCapacity,
          'wiltingPoint': test.input.soilType.wiltingPoint,
          'availableWater': test.input.soilType.availableWater,
          'infiltrationRate': test.input.soilType.infiltrationRate,
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

  // Run irrigation method tests
  for (final test in irrigationMethodTestCases) {
    try {
      results.add({
        'id': test.id,
        'passed': 
          test.input.method.displayName == test.expected.displayName &&
          (test.input.method.efficiency - test.expected.efficiency).abs() <= test.tolerance &&
          (test.input.method.applicationRate - test.expected.applicationRate).abs() <= test.tolerance &&
          (test.input.method.waterSavingFactor - test.expected.waterSavingFactor).abs() <= test.tolerance,
        'description': test.description,
        'expected': {
          'displayName': test.expected.displayName,
          'efficiency': test.expected.efficiency,
          'applicationRate': test.expected.applicationRate,
          'waterSavingFactor': test.expected.waterSavingFactor,
        },
        'actual': {
          'displayName': test.input.method.displayName,
          'efficiency': test.input.method.efficiency,
          'applicationRate': test.input.method.applicationRate,
          'waterSavingFactor': test.input.method.waterSavingFactor,
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

  // Run gross irrigation tests
  for (final test in grossIrrigationTestCases) {
    try {
      final gross = test.input.netIrrigation / (test.input.method.efficiency / 100);
      results.add({
        'id': test.id,
        'passed': (gross - test.expected.grossIrrigation).abs() <= test.tolerance,
        'description': test.description,
        'expected': test.expected.grossIrrigation,
        'actual': gross,
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
