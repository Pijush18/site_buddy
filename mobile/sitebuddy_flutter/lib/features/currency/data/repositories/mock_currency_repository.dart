

import 'package:site_buddy/features/currency/domain/entities/currency_rate.dart';
import 'package:site_buddy/features/currency/domain/repositories/currency_repository.dart';

class MockCurrencyRepository implements CurrencyRepository {
  const MockCurrencyRepository();

  static const _rates = {
    'USD': {'INR': 82.0, 'EUR': 0.92, 'USD': 1.0},
    'EUR': {'USD': 1.09, 'INR': 89.5, 'EUR': 1.0},
    'INR': {'USD': 0.0122, 'EUR': 0.0112, 'INR': 1.0},
  };

  @override
  Future<CurrencyRate> getRate(String from, String to) async {
    final fromMap = _rates[from.toUpperCase()];
    final now = DateTime.now();
    if (fromMap == null) {
      // fallback to 1.0
      return CurrencyRate(from: from, to: to, rate: 1.0, timestamp: now);
    }
    final rate = fromMap[to.toUpperCase()] ?? 1.0;
    return CurrencyRate(
      from: from.toUpperCase(),
      to: to.toUpperCase(),
      rate: rate.toDouble(),
      timestamp: now,
    );
  }
}



