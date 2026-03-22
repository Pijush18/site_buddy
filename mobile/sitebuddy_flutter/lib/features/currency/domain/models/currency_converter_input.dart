/// CLASS: CurrencyConverterInput
class CurrencyConverterInput {
  final double amount;
  final String fromCurrency;
  final String toCurrency;

  const CurrencyConverterInput({
    required this.amount,
    required this.fromCurrency,
    required this.toCurrency,
  });
}
