

class CurrencyRate {
  final String from;
  final String to;
  final double rate;
  final DateTime timestamp;

  const CurrencyRate({
    required this.from,
    required this.to,
    required this.rate,
    required this.timestamp,
  });
}
