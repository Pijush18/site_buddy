import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/providers/engine_providers.dart';
import 'package:site_buddy/features/transport/road/domain/models/pavement_input.dart';
import 'package:site_buddy/features/transport/road/domain/models/pavement_result.dart';

/// lib/features/transport/road/application/road_calculator.dart
///
/// Application layer controller for the Road Pavement Calculator.
/// Orchestrates input and design service calls.
final roadCalculatorProvider = NotifierProvider<RoadCalculator, RoadCalculatorState>(
  RoadCalculator.new,
);

class RoadCalculatorState {
  final String cbrInput;
  final String trafficInput;
  final PavementResult? result;
  final bool isLoading;
  final String? errorMessage;

  const RoadCalculatorState({
    this.cbrInput = '',
    this.trafficInput = '',
    this.result,
    this.isLoading = false,
    this.errorMessage,
  });

  RoadCalculatorState copyWith({
    String? cbrInput,
    String? trafficInput,
    PavementResult? result,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return RoadCalculatorState(
      cbrInput: cbrInput ?? this.cbrInput,
      trafficInput: trafficInput ?? this.trafficInput,
      result: result ?? this.result,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class RoadCalculator extends Notifier<RoadCalculatorState> {
  @override
  RoadCalculatorState build() => const RoadCalculatorState();

  void updateCBR(String value) => state = state.copyWith(cbrInput: value, clearError: true);
  void updateTraffic(String value) => state = state.copyWith(trafficInput: value, clearError: true);

  Future<void> calculate() async {
    final double? cbr = double.tryParse(state.cbrInput);
    final double? traffic = double.tryParse(state.trafficInput);

    if (cbr == null || traffic == null) {
      state = state.copyWith(errorMessage: 'Please enter valid numerical values.');
      return;
    }

    state = state.copyWith(isLoading: true, clearError: true);

    // Simulate async work
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      final service = ref.read(roadDesignServiceProvider);
      final input = PavementInput(
        subgradeCBR: cbr,
        trafficMSA: traffic,
      );

      final result = service.designPavement(input);
      state = state.copyWith(isLoading: false, result: result);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'Calculation failed: ${e.toString()}');
    }
  }

  void reset() => state = const RoadCalculatorState();
}
