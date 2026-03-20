

import 'package:site_buddy/features/currency/domain/entities/currency_rate.dart';
import 'package:site_buddy/features/currency/domain/repositories/currency_repository.dart';

class ConvertCurrencyUseCase {
  final CurrencyRepository repository;

  const ConvertCurrencyUseCase({required this.repository});

  /// Fetches rate from repository and returns converted value.
  Future<double> call({
    required String from,
    required String to,
    required double amount,
  }) async {
    final rate = await repository.getRate(from, to);
    return amount * rate.rate;
  }

  /// Exposes full rate info when caller needs timestamp and rate details.
  Future<CurrencyRate> getRateInfo(String from, String to) async {
    return repository.getRate(from, to);
  }
}



