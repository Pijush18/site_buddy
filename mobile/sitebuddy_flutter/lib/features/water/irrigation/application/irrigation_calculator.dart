import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/providers/engine_providers.dart';
import 'package:site_buddy/features/water/irrigation/domain/models/discharge_input.dart';
import 'package:site_buddy/features/water/irrigation/domain/models/discharge_result.dart';

/// lib/features/water/irrigation/application/irrigation_calculator.dart
///
/// Application layer controller for the Irrigation Calculator.
/// Orchestrates input and design service calls.
final irrigationCalculatorProvider = NotifierProvider<IrrigationCalculator, IrrigationCalculatorState>(
  IrrigationCalculator.new,
);

class IrrigationCalculatorState {
  final String areaInput;
  final String velocityInput;
  final DischargeResult? result;
  final bool isLoading;
  final String? errorMessage;

  const IrrigationCalculatorState({
    this.areaInput = '',
    this.velocityInput = '',
    this.result,
    this.isLoading = false,
    this.errorMessage,
  });

  IrrigationCalculatorState copyWith({
    String? areaInput,
    String? velocityInput,
    DischargeResult? result,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return IrrigationCalculatorState(
      areaInput: areaInput ?? this.areaInput,
      velocityInput: velocityInput ?? this.velocityInput,
      result: result ?? this.result,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class IrrigationCalculator extends Notifier<IrrigationCalculatorState> {
  @override
  IrrigationCalculatorState build() => const IrrigationCalculatorState();

  void updateArea(String value) => state = state.copyWith(areaInput: value, clearError: true);
  void updateVelocity(String value) => state = state.copyWith(velocityInput: value, clearError: true);

  Future<void> calculate() async {
    final double? area = double.tryParse(state.areaInput);
    final double? velocity = double.tryParse(state.velocityInput);

    if (area == null || velocity == null) {
      state = state.copyWith(errorMessage: 'Please enter valid numerical values.');
      return;
    }

    state = state.copyWith(isLoading: true, clearError: true);

    // Simulate async work
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      final service = ref.read(irrigationServiceProvider);
      final input = DischargeInput(
        area: area,
        velocity: velocity,
      );

      final result = service.calculateDischarge(input);
      state = state.copyWith(isLoading: false, result: result);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'Calculation failed: ${e.toString()}');
    }
  }

  void reset() => state = const IrrigationCalculatorState();
}
