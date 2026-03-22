import 'dart:math';
import 'package:site_buddy/core/qa/golden_test_cases.dart';

/// RESULT: QATestResult
class QATestResult {
  final String id;
  final bool passed;
  final String message;

  const QATestResult({
    required this.id,
    required this.passed,
    required this.message,
  });
}

/// RUNNER: QATestRunner
/// PURPOSE: Executes engineering tests and verifies tolerances.
class QATestRunner<TInput, TOutput> {
  final String toolName;

  const QATestRunner(this.toolName);

  List<QATestResult> run({
    required List<GoldenTestCase<TInput, TOutput>> testCases,
    required TOutput Function(TInput) calculator,
    required Map<String, dynamic> Function(TOutput) extractor,
  }) {
    final List<QATestResult> results = [];

    for (final test in testCases) {
      try {
        final actual = calculator(test.input);
        final actualMap = extractor(actual);
        final expectedMap = extractor(test.expected);

        bool testPassed = true;
        final List<String> mismatches = [];

        expectedMap.forEach((key, expectedValue) {
          final actualValue = actualMap[key];

          if (expectedValue is num && actualValue is num) {
            final diff = (actualValue - expectedValue).abs();
            final threshold = (expectedValue.abs() * (test.tolerance / 100.0)).clamp(0.0001, double.infinity);

            if (diff > threshold) {
              testPassed = false;
              mismatches.add('$key mismatch: Expected $expectedValue, Got $actualValue (diff: $diff, tolerance: $threshold)');
            }
          } else if (expectedValue != actualValue) {
            testPassed = false;
            mismatches.add('$key mismatch: Expected $expectedValue, Got $actualValue');
          }
        });

        results.add(QATestResult(
          id: test.id,
          passed: testPassed,
          message: testPassed ? 'Success' : mismatches.join(' | '),
        ));
      } catch (e) {
        results.add(QATestResult(
          id: test.id,
          passed: false,
          message: 'Error during execution: $e',
        ));
      }
    }

    return results;
  }
}
