import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/providers/engine_providers.dart';
import 'package:site_buddy/core/config/engine_defaults.dart';
import 'package:site_buddy/features/water/irrigation/domain/models/canal_input.dart';
import 'package:site_buddy/features/water/irrigation/domain/models/canal_result.dart';

/// lib/features/water/irrigation/application/canal_calculator.dart
///
/// Application layer controller for the Canal Design Calculator.
/// 
/// APPLICATION LAYER PATTERN:
/// - Calls Domain services to get complete, truthful results
/// - Applies Pro/premium gating policy HERE (not in Domain)
/// - Controls what is exposed to the Presentation layer
/// - Uses configurable defaults from providers (not hardcoded)
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
  final CanalResult? rawResult;    // Complete domain result (not exposed)
  final CanalResult? result;        // Filtered result (exposed to UI)
  final bool isLoading;
  final String? errorMessage;
  final bool isProUser;
  final bool upgradeRequired;        // Application layer policy flag

  const CanalCalculatorState({
    this.shape = CanalShape.trapezoidal,
    this.bedWidthInput = '',
    this.sideSlopeInput = '',
    this.flowDepthInput = '',
    this.longitudinalSlopeInput = '',
    this.material = 'Concrete',
    this.rawResult,
    this.result,
    this.isLoading = false,
    this.errorMessage,
    this.isProUser = false,
    this.upgradeRequired = false,
  });

  CanalCalculatorState copyWith({
    CanalShape? shape,
    String? bedWidthInput,
    String? sideSlopeInput,
    String? flowDepthInput,
    String? longitudinalSlopeInput,
    String? material,
    CanalResult? rawResult,
    CanalResult? result,
    bool? isLoading,
    String? errorMessage,
    bool? isProUser,
    bool? upgradeRequired,
    bool clearError = false,
  }) {
    return CanalCalculatorState(
      shape: shape ?? this.shape,
      bedWidthInput: bedWidthInput ?? this.bedWidthInput,
      sideSlopeInput: sideSlopeInput ?? this.sideSlopeInput,
      flowDepthInput: flowDepthInput ?? this.flowDepthInput,
      longitudinalSlopeInput: longitudinalSlopeInput ?? this.longitudinalSlopeInput,
      material: material ?? this.material,
      rawResult: rawResult ?? this.rawResult,
      result: result ?? this.result,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isProUser: isProUser ?? this.isProUser,
      upgradeRequired: upgradeRequired ?? this.upgradeRequired,
    );
  }
}

class CanalCalculator extends Notifier<CanalCalculatorState> {
  @override
  CanalCalculatorState build() {
    // Get configurable defaults from provider (instead of hardcoded values)
    final defaults = ref.watch(canalDefaultsProvider);
    
    return CanalCalculatorState(
      sideSlopeInput: defaults.defaultSideSlope.toString(),
      longitudinalSlopeInput: defaults.defaultSlope.toString(),
      material: defaults.defaultMaterial,
    );
  }

  void updateShape(CanalShape shape) => state = state.copyWith(shape: shape, clearError: true);
  void updateBedWidth(String value) => state = state.copyWith(bedWidthInput: value, clearError: true);
  void updateSideSlope(String value) => state = state.copyWith(sideSlopeInput: value, clearError: true);
  void updateFlowDepth(String value) => state = state.copyWith(flowDepthInput: value, clearError: true);
  void updateSlope(String value) => state = state.copyWith(longitudinalSlopeInput: value, clearError: true);
  void updateMaterial(String value) => state = state.copyWith(material: value, clearError: true);

  /// Calculates canal design.
  /// 
  /// POLICY: Domain returns FULL results. Application layer applies gating.
  /// - For Pro users: Optimization tips shown
  /// - For Free users: Optimization tips hidden
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
      
      // 1. Call Domain service - gets FULL results (no gating)
      final input = CanalInput(
        shape: state.shape,
        bedWidth: b,
        sideSlope: z ?? 0.0,
        flowDepth: y,
        longitudinalSlope: S,
        material: state.material,
      );

      final rawResult = service.designCanal(input);
      
      // 2. APPLICATION LAYER POLICY: Filter based on Pro status
      final filteredResult = _applyProGating(rawResult);
      
      state = state.copyWith(
        isLoading: false,
        rawResult: rawResult,
        result: filteredResult,
        upgradeRequired: !state.isProUser && rawResult.optimizationSuggestion != null,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'Calculation failed: ${e.toString()}');
    }
  }

  /// APPLICATION LAYER POLICY:
  /// Filters optimization suggestions based on user Pro status.
  CanalResult _applyProGating(CanalResult raw) {
    if (state.isProUser) {
      // Pro users see everything
      return raw;
    }
    
    // Free users: Hide optimization suggestions
    return CanalResult(
      discharge: raw.discharge,
      velocity: raw.velocity,
      crossArea: raw.crossArea,
      wettedPerimeter: raw.wettedPerimeter,
      hydraulicRadius: raw.hydraulicRadius,
      efficiency: raw.efficiency,
      safetyNote: raw.safetyNote,
      optimizationSuggestion: null, // Pro feature - not shown to free users
    );
  }

  void reset() {
    // Reset to current defaults from provider
    final defaults = ref.read(canalDefaultsProvider);
    state = CanalCalculatorState(
      sideSlopeInput: defaults.defaultSideSlope.toString(),
      longitudinalSlopeInput: defaults.defaultSlope.toString(),
      material: defaults.defaultMaterial,
    );
  }
}
