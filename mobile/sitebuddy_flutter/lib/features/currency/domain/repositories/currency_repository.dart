

import 'package:site_buddy/features/currency/domain/entities/currency_rate.dart';

abstract class CurrencyRepository {
  Future<CurrencyRate> getRate(String from, String to);
}



