import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/providers/engine_providers.dart';
import 'package:site_buddy/features/water/irrigation/domain/models/canal_input.dart';
import 'package:site_buddy/features/water/irrigation/domain/models/canal_result.dart';

/// lib/features/water/irrigation/application/canal_calculator.dart
///
/// Application layer controller for the Canal Design Calculator.
final canalCalculatorProvider = NotifierProvider<CanalCalculator, CanalCalculatorState>(
  CanalCalculator.new,
);

class CanalCalculatorState {
  final CanalShape shape;
  final String bedWidthInput;
  final String sideSlopeInput;
  final String flowDepthInput;
  final String longitudinalSlopeInput;
  final String material;
  final CanalResult? result;
  final bool isLoading;
  final String? errorMessage;
  final bool isProUser;

  const CanalCalculatorState({
    this.shape = CanalShape.trapezoidal,
    this.bedWidthInput = '',
    this.sideSlopeInput = '1.5', // Typical 1.5:1
    this.flowDepthInput = '',
    this.longitudinalSlopeInput = '0.001',
    this.material = 'Concrete',
    this.result,
    this.isLoading = false,
    this.errorMessage,
    this.isProUser = true, // Defaulting to true for demo
  });

  CanalCalculatorState copyWith({
    CanalShape? shape,
    String? bedWidthInput,
    String? sideSlopeInput,
    String? flowDepthInput,
    String? longitudinalSlopeInput,
    String? material,
    CanalResult? result,
    bool? isLoading,
    String? errorMessage,
    bool? isProUser,
    bool clearError = false,
  }) {
    return CanalCalculatorState(
      shape: shape ?? this.shape,
      bedWidthInput: bedWidthInput ?? this.bedWidthInput,
      sideSlopeInput: sideSlopeInput ?? this.sideSlopeInput,
      flowDepthInput: flowDepthInput ?? this.flowDepthInput,
      longitudinalSlopeInput: longitudinalSlopeInput ?? this.longitudinalSlopeInput,
      material: material ?? this.material,
      result: result ?? this.result,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isProUser: isProUser ?? this.isProUser,
    );
  }
}

class CanalCalculator extends Notifier<CanalCalculatorState> {
  @override
  CanalCalculatorState build() => const CanalCalculatorState();

  void updateShape(CanalShape shape) => state = state.copyWith(shape: shape, clearError: true);
  void updateBedWidth(String value) => state = state.copyWith(bedWidthInput: value, clearError: true);
  void updateSideSlope(String value) => state = state.copyWith(sideSlopeInput: value, clearError: true);
  void updateFlowDepth(String value) => state = state.copyWith(flowDepthInput: value, clearError: true);
  void updateSlope(String value) => state = state.copyWith(longitudinalSlopeInput: value, clearError: true);
  void updateMaterial(String value) => state = state.copyWith(material: value, clearError: true);

  Future<void> calculate() async {
    final double? b = double.tryParse(state.bedWidthInput);
    final double? z = double.tryParse(state.sideSlopeInput);
    final double? y = double.tryParse(state.flowDepthInput);
    final double? S = double.tryParse(state.longitudinalSlopeInput);

    if (b == null || y == null || S == null || (state.shape == CanalShape.trapezoidal && z == null)) {
      state = state.copyWith(errorMessage: 'Please enter valid numerical values.');
      return;
    }

    state = state.copyWith(isLoading: true, clearError: true);

    await Future.delayed(const Duration(milliseconds: 300));

    try {
      final service = ref.read(canalDesignServiceProvider);
      
      final input = CanalInput(
        shape: state.shape,
        bedWidth: b,
        sideSlope: z ?? 0.0,
        flowDepth: y,
        longitudinalSlope: S,
        material: state.material,
        isProUser: state.isProUser,
      );

      final result = service.designCanal(input);
      state = state.copyWith(isLoading: false, result: result);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'Calculation failed: ${e.toString()}');
    }
  }

  void reset() => state = const CanalCalculatorState();
}
