import 'package:site_buddy/core/qa/golden_test_cases.dart';
import 'package:site_buddy/features/currency/domain/models/currency_converter_input.dart';
import 'package:site_buddy/features/currency/domain/models/currency_converter_result.dart';

final currencyConverterTestCases = [
  const GoldenTestCase<CurrencyConverterInput, CurrencyConverterResult>(
    id: 'CUR_001',
    description: '100 USD to EUR (Rate 0.92)',
    input: CurrencyConverterInput(amount: 100.0, fromCurrency: 'USD', toCurrency: 'EUR'),
    expected: CurrencyConverterResult(amount: 92.0, currency: 'EUR', rate: 0.92),
  ),
  const GoldenTestCase<CurrencyConverterInput, CurrencyConverterResult>(
    id: 'CUR_002',
    description: '100 EUR to USD (Rate 1/0.92)',
    input: CurrencyConverterInput(amount: 100.0, fromCurrency: 'EUR', toCurrency: 'USD'),
    expected: CurrencyConverterResult(amount: 108.70, currency: 'USD', rate: 1.087),
    tolerance: 0.1,
  ),
  const GoldenTestCase<CurrencyConverterInput, CurrencyConverterResult>(
    id: 'CUR_003',
    description: 'Same currency conversion',
    input: CurrencyConverterInput(amount: 250.0, fromCurrency: 'GBP', toCurrency: 'GBP'),
    expected: CurrencyConverterResult(amount: 250.0, currency: 'GBP', rate: 1.0),
  ),
];
