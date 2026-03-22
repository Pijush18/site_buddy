import 'package:site_buddy/features/currency/domain/models/currency_converter_input.dart';
import 'package:site_buddy/features/currency/domain/models/currency_converter_result.dart';

/// SERVICE: CurrencyConverterService
/// PURPOSE: Pure logic for currency conversions with mock rates.
class CurrencyConverterService {
  const CurrencyConverterService();

  /// Mock exchange rates (Base: USD)
  static const Map<String, double> _rates = {
    'USD': 1.0,
    'EUR': 0.92,
    'GBP': 0.79,
    'INR': 83.0,
    'AED': 3.67,
    'CAD': 1.35,
    'AUD': 1.52,
  };

  /// CONVERT: Performs currency exchange using a base-USD cross-rate logic.
  /// 
  /// FORMULA: 
  /// 1. USD Amount = Source Amount / Source Rate (to USD)
  /// 2. Target Amount = USD Amount * Target Rate (from USD)
  /// 
  /// UNITS: Relative rates to 1.0 USD.
  CurrencyConverterResult convert(CurrencyConverterInput input) {
    _validate(input);

    final fromRate = _rates[input.fromCurrency];
    final toRate = _rates[input.toCurrency];

    if (fromRate == null || toRate == null) {
      throw ArgumentError('Unsupported currency: ${fromRate == null ? input.fromCurrency : input.toCurrency}');
    }

    // Convert to USD, then to target currency
    final usdAmount = input.amount / fromRate;
    final targetAmount = usdAmount * toRate;
    final effectiveRate = toRate / fromRate;

    return CurrencyConverterResult(
      amount: double.parse(targetAmount.toStringAsFixed(2)),
      currency: input.toCurrency,
      rate: double.parse(effectiveRate.toStringAsFixed(4)),
    );
  }

  void _validate(CurrencyConverterInput input) {
    if (input.amount < 0) {
      throw ArgumentError('Amount to convert cannot be negative');
    }
  }
}
