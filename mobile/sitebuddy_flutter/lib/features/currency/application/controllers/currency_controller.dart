

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/features/currency/domain/usecases/convert_currency_usecase.dart';
import 'package:site_buddy/features/currency/data/repositories/mock_currency_repository.dart';

final currencyControllerProvider =
    NotifierProvider<CurrencyController, CurrencyState>(CurrencyController.new);

class CurrencyState {
  final String fromCurrency;
  final String toCurrency;
  final double? amount;
  final double? convertedAmount;
  final double? rate;
  final DateTime? lastUpdated;
  final bool isLoading;
  final String? error;

  const CurrencyState({
    this.fromCurrency = 'USD',
    this.toCurrency = 'INR',
    this.amount,
    this.convertedAmount,
    this.rate,
    this.lastUpdated,
    this.isLoading = false,
    this.error,
  });

  CurrencyState copyWith({
    String? fromCurrency,
    String? toCurrency,
    double? amount,
    double? convertedAmount,
    double? rate,
    DateTime? lastUpdated,
    bool? isLoading,
    String? error,
    bool clearResult = false,
  }) {
    return CurrencyState(
      fromCurrency: fromCurrency ?? this.fromCurrency,
      toCurrency: toCurrency ?? this.toCurrency,
      amount: amount ?? this.amount,
      convertedAmount: clearResult
          ? null
          : (convertedAmount ?? this.convertedAmount),
      rate: clearResult ? null : (rate ?? this.rate),
      lastUpdated: clearResult ? null : (lastUpdated ?? this.lastUpdated),
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class CurrencyController extends Notifier<CurrencyState> {
  late final ConvertCurrencyUseCase _useCase;

  CurrencyController() {
    _useCase = const ConvertCurrencyUseCase(
      repository: MockCurrencyRepository(),
    );
  }

  @override
  CurrencyState build() => const CurrencyState();

  void updateAmount(String value) {
    if (value.isEmpty) {
      state = state.copyWith(amount: null, convertedAmount: null, error: null);
      return;
    }
    final v = double.tryParse(value);
    if (v != null) {
      state = state.copyWith(amount: v, error: null, clearResult: true);
    }
  }

  void updateFromCurrency(String value) {
    state = state.copyWith(fromCurrency: value, clearResult: true);
  }

  void updateToCurrency(String value) {
    state = state.copyWith(toCurrency: value, clearResult: true);
  }

  void swapCurrencies() {
    state = state.copyWith(
      fromCurrency: state.toCurrency,
      toCurrency: state.fromCurrency,
      clearResult: true,
    );
  }

  Future<void> convert() async {
    state = state.copyWith(isLoading: true, error: null);

    final amount = state.amount;
    final from = state.fromCurrency;
    final to = state.toCurrency;

    if (amount == null || amount <= 0) {
      state = state.copyWith(
        isLoading: false,
        error: 'Please enter an amount greater than 0.',
      );
      return;
    }

    try {
      final converted = await _useCase.call(from: from, to: to, amount: amount);
      final rateInfo = await _useCase.getRateInfo(from, to);

      state = state.copyWith(
        convertedAmount: converted,
        rate: rateInfo.rate,
        lastUpdated: rateInfo.timestamp,
        isLoading: false,
        error: null,
      );
    } on ArgumentError catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.message ?? 'Invalid input',
      );
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        error: 'An unexpected error occurred',
      );
    }
  }
}



