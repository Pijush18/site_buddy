/// FILE HEADER
/// ----------------------------------------------
/// File: gradient_controller.dart
/// Feature: calculator
/// Layer: application/controllers
///
/// PURPOSE:
/// Manages state for the Gradient Tool UI using Riverpod.
///
/// RESPONSIBILITIES:
/// - Store user inputs for rise and run.
/// - Invoke [CalculateGradientUseCase] to compute metrics.
/// - Manage loading/failure state.
///
/// DEPENDENCIES:
/// - Riverpod NotifierProvider
/// - Domain use case [CalculateGradientUseCase]
/// - Domain entity [GradientResult]
///
/// FUTURE IMPROVEMENTS:
/// - Add input unit conversion (e.g., percent or ratio clear).
/// ----------------------------------------------
library;


import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/features/surveying/gradient/domain/gradient_result.dart';
import 'package:site_buddy/features/surveying/gradient/domain/calculate_gradient_usecase.dart';

/// Failure model, shared with level_controller for simplicity.
class Failure {
  final String message;
  const Failure(this.message);
}

/// State container for gradient calculations.
class GradientState {
  final double? rise;
  final double? run;
  final GradientResult? result;
  final bool isLoading;
  final Failure? failure;

  const GradientState({
    this.rise,
    this.run,
    this.result,
    this.isLoading = false,
    this.failure,
  });

  GradientState copyWith({
    double? rise,
    double? run,
    GradientResult? result,
    bool? isLoading,
    Failure? failure,
    bool clearFailure = false,
    bool clearResult = false,
  }) {
    return GradientState(
      rise: rise ?? this.rise,
      run: run ?? this.run,
      result: clearResult ? null : (result ?? this.result),
      isLoading: isLoading ?? this.isLoading,
      failure: clearFailure ? null : (failure ?? this.failure),
    );
  }
}

/// Riverpod provider for the gradient controller.
final gradientControllerProvider =
    NotifierProvider<GradientController, GradientState>(GradientController.new);

class GradientController extends Notifier<GradientState> {
  final _useCase = const CalculateGradientUseCase();

  @override
  GradientState build() {
    return const GradientState();
  }

  void updateRise(String value) {
    if (value.isEmpty) {
      state = state.copyWith(rise: null, clearResult: true);
      return;
    }
    final v = double.tryParse(value);
    if (v != null) {
      state = state.copyWith(rise: v, clearFailure: true);
    }
  }

  void updateRun(String value) {
    if (value.isEmpty) {
      state = state.copyWith(run: null, clearResult: true);
      return;
    }
    final v = double.tryParse(value);
    if (v != null) {
      state = state.copyWith(run: v, clearFailure: true);
    }
  }

  Future<void> calculate() async {
    final riseVal = state.rise;
    final runVal = state.run;

    if (riseVal == null || runVal == null) {
      state = state.copyWith(
        failure: const Failure('Both rise and run must be provided.'),
        clearResult: true,
      );
      return;
    }

    state = state.copyWith(isLoading: true, clearFailure: true);

    try {
      final res = _useCase.execute(rise: riseVal, run: runVal);
      state = state.copyWith(result: res, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        failure: Failure(e.toString().replaceAll('Exception: ', '')),
      );
    }
  }

  void reset() => state = const GradientState();
}




