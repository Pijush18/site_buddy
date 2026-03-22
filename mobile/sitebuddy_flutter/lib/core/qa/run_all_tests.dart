// ignore_for_file: avoid_print, unused_local_variable, always_use_package_imports

import 'package:site_buddy/core/qa/qa_test_runner.dart';
import 'package:site_buddy/features/level_calculator/application/services/level_calculator_service.dart';
import 'package:site_buddy/features/gradient_tool/application/services/gradient_calculator_service.dart';
import 'package:site_buddy/features/unit_converter/application/services/unit_converter_service.dart';
import 'package:site_buddy/features/currency/application/services/currency_converter_service.dart';
import 'package:site_buddy/features/concrete_estimator/application/services/concrete_estimator_service.dart';
import 'package:site_buddy/features/brick_estimator/application/services/brick_estimator_service.dart';
import 'package:site_buddy/features/steel_estimator/application/services/steel_weight_service.dart';
import 'package:site_buddy/features/excavation_estimator/application/services/excavation_estimator_service.dart';
import 'package:site_buddy/features/shuttering_estimator/application/services/shuttering_estimator_service.dart';

import 'test_cases/level_calculator_test_cases.dart';
import 'test_cases/gradient_tool_test_cases.dart';
import 'test_cases/unit_converter_test_cases.dart';
import 'test_cases/currency_test_cases.dart';
import 'test_cases/concrete_estimator_test_cases.dart';
import 'test_cases/brick_estimator_test_cases.dart';
import 'test_cases/steel_estimator_test_cases.dart';
import 'test_cases/excavation_estimator_test_cases.dart';
import 'test_cases/shuttering_estimator_test_cases.dart';

void main() {
  print('=========================================');
  print('🚀 INITIALIZING ENGINEERING QA HARNESS');
  print('=========================================');

  int totalPassed = 0;
  int totalFailed = 0;

  // 1. Level Calculator
  final levelResults = const QATestRunner('Level Calculator').run(
    testCases: levelCalculatorTestCases,
    calculator: (input) => const LevelCalculatorService().calculate(input),
    extractor: (res) => {
      'riseOrFall': res.riseOrFall,
      'reducedLevel': res.reducedLevel,
      'isRise': res.isRise,
    },
  );
  _report('Level Calculator', levelResults);

  // 2. Gradient Tool
  final gradientResults = const QATestRunner('Gradient Tool').run(
    testCases: gradientToolTestCases,
    calculator: (input) => const GradientCalculatorService().calculate(input),
    extractor: (res) => {
      'slopePercent': res.slopePercent,
      'ratio': res.ratio,
      'angleDegrees': res.angleDegrees,
    },
  );
  _report('Gradient Tool', gradientResults);

  // 3. Unit Converter
  final unitResults = const QATestRunner('Unit Converter').run(
    testCases: unitConverterTestCases,
    calculator: (input) => const UnitConverterService().convert(input),
    extractor: (res) => {
      'value': res.value,
      'unit': res.unit,
    },
  );
  _report('Unit Converter', unitResults);

  // 4. Currency
  final currencyResults = const QATestRunner('Currency Converter').run(
    testCases: currencyConverterTestCases,
    calculator: (input) => const CurrencyConverterService().convert(input),
    extractor: (res) => {
      'amount': res.amount,
      'rate': res.rate,
    },
  );
  _report('Currency Converter', currencyResults);

  // 5. Concrete
  final concreteResults = const QATestRunner('Concrete Estimator').run(
    testCases: concreteEstimatorTestCases,
    calculator: (input) => const ConcreteEstimatorService().estimate(input),
    extractor: (res) => {
      'cementBags': res.cementBags,
      'sandVolume': res.sandVolume,
      'aggregateVolume': res.aggregateVolume,
      'dryVolume': res.dryVolume,
    },
  );
  _report('Concrete Estimator', concreteResults);

  // 6. Brick
  final brickResults = const QATestRunner('Brick Estimator').run(
    testCases: brickEstimatorTestCases,
    calculator: (input) => const BrickEstimatorService().estimate(input),
    extractor: (res) => {
      'numberOfBricks': res.numberOfBricks,
      'mortarVolume': res.mortarVolume,
    },
  );
  _report('Brick Estimator', brickResults);

  // 7. Steel
  final steelResults = const QATestRunner('Steel Weight').run(
    testCases: steelEstimatorTestCases,
    calculator: (input) => const SteelWeightService().calculate(input),
    extractor: (res) => {
      'weight': res.weight,
      'unitWeight': res.unitWeight,
    },
  );
  _report('Steel Weight', steelResults);

  // 8. Excavation
  final excavationResults = const QATestRunner('Excavation Estimator').run(
    testCases: excavationEstimatorTestCases,
    calculator: (input) => const ExcavationEstimatorService().calculate(input),
    extractor: (res) => {
      'volume': res.volume,
      'looseVolume': res.looseVolume,
    },
  );
  _report('Excavation Estimator', excavationResults);

  // 9. Shuttering
  final shutteringResults = const QATestRunner('Shuttering Estimator').run(
    testCases: shutteringEstimatorTestCases,
    calculator: (input) => const ShutteringEstimatorService().calculate(input),
    extractor: (res) => {
      'area': res.area,
    },
  );
  _report('Shuttering Estimator', shutteringResults);

  // SUMMARY
  final total = levelResults.length + 
                gradientResults.length + 
                unitResults.length + 
                currencyResults.length + 
                concreteResults.length + 
                brickResults.length + 
                steelResults.length + 
                excavationResults.length + 
                shutteringResults.length;

  final failedCount = _getFailedCount(levelResults) + 
                      _getFailedCount(gradientResults) +
                      _getFailedCount(unitResults) +
                      _getFailedCount(currencyResults) +
                      _getFailedCount(concreteResults) +
                      _getFailedCount(brickResults) +
                      _getFailedCount(steelResults) +
                      _getFailedCount(excavationResults) +
                      _getFailedCount(shutteringResults);

  print('\n=========================================');
  print('📊 FINAL QA SUMMARY');
  print('=========================================');
  print('Total Tests: $total');
  print('✅ PASSED  : ${total - failedCount}');
  print('❌ FAILED  : $failedCount');
  print('=========================================');

  if (failedCount > 0) {
    print('\n⚠️ ALERT: Regression detected. Fix service logic.');
  } else {
    print('\n💎 EXCELLENT: All engineering tools verified.');
  }
}

void _report(String name, List<QATestResult> results) {
  final passCount = results.where((r) => r.passed).length;
  final status = passCount == results.length ? '✅ OK' : '❌ FAIL';
  print('$status $name: $passCount/${results.length} passed');
  
  for (final res in results.where((r) => !r.passed)) {
    print('   - [${res.id}] Mismatch: ${res.message}');
  }
}

int _getFailedCount(List<QATestResult> results) {
  return results.where((r) => !r.passed).length;
}
