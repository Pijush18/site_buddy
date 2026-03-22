import 'package:site_buddy/core/qa/golden_test_cases.dart';
import 'package:site_buddy/features/unit_converter/domain/models/unit_converter_input.dart';
import 'package:site_buddy/features/unit_converter/domain/models/unit_converter_result.dart';

final unitConverterTestCases = [
  const GoldenTestCase<UnitConverterInput, UnitConverterResult>(
    id: 'UNT_001',
    description: 'Length: 1m to feet',
    input: UnitConverterInput(value: 1.0, fromUnit: 'm', toUnit: 'ft', type: ConversionType.length),
    expected: UnitConverterResult(value: 3.28084, unit: 'ft'),
    tolerance: 0.1,
  ),
  const GoldenTestCase<UnitConverterInput, UnitConverterResult>(
    id: 'UNT_002',
    description: 'Area: 10 sqm to sqft',
    input: UnitConverterInput(value: 10.0, fromUnit: 'sqm', toUnit: 'sqft', type: ConversionType.area),
    expected: UnitConverterResult(value: 107.6391, unit: 'sqft'),
  ),
  const GoldenTestCase<UnitConverterInput, UnitConverterResult>(
    id: 'UNT_003',
    description: 'Volume: 1 cum to cuft',
    input: UnitConverterInput(value: 1.0, fromUnit: 'cum', toUnit: 'cuft', type: ConversionType.volume),
    expected: UnitConverterResult(value: 35.3147, unit: 'cuft'),
  ),
];
