/// CLASS: CurrencyConverterResult
class CurrencyConverterResult {
  final double amount;
  final String currency;
  final double rate;

  const CurrencyConverterResult({
    required this.amount,
    required this.currency,
    required this.rate,
  });

  Map<String, dynamic> toMap() {
    return {
      'converted_amount': amount,
      'currency': currency,
      'exchange_rate': rate,
    };
  }
}
