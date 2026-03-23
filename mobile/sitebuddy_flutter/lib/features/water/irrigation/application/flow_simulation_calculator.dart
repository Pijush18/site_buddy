
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/providers/engine_providers.dart';
import 'package:site_buddy/core/config/engine_defaults.dart';
import 'package:site_buddy/features/water/irrigation/domain/models/flow_input.dart';
import 'package:site_buddy/features/water/irrigation/domain/models/flow_result.dart';

/// lib/features/water/irrigation/application/flow_simulation_calculator.dart
///
/// Application layer controller for Flow Simulation.
/// 
/// APPLICATION LAYER PATTERN:
/// - Calls Domain services to get complete, truthful results
/// - Applies Pro/premium gating policy HERE (not in Domain)
/// - Controls what is exposed to the Presentation layer
/// - Uses configurable defaults from providers (not hardcoded)
final flowSimulationCalculatorProvider = NotifierProvider<FlowSimulationCalculator, FlowSimulationCalculatorState>(
  FlowSimulationCalculator.new,
);

class FlowSimulationCalculatorState {
  final String velocityInput;
  final String depthInput;
  final String widthInput;
  final String slopeInput;
  final String roughnessInput;
  final String lengthInput;
  final String segmentsInput;
  
  final FlowResult? rawResult;      // Complete domain result (not exposed)
  final FlowResult? result;          // Filtered result (exposed to UI)
  final bool isLoading;
  final String? errorMessage;
  final bool isProUser;
  final bool upgradeRequired;        // Application layer policy flag

  const FlowSimulationCalculatorState({
    this.velocityInput = '',
    this.depthInput = '',
    this.widthInput = '',
    this.slopeInput = '',
    this.roughnessInput = '',
    this.lengthInput = '',
    this.segmentsInput = '',
    this.rawResult,
    this.result,
    this.isLoading = false,
    this.errorMessage,
    this.isProUser = false,
    this.upgradeRequired = false,
  });

  FlowSimulationCalculatorState copyWith({
    String? velocityInput,
    String? depthInput,
    String? widthInput,
    String? slopeInput,
    String? roughnessInput,
    String? lengthInput,
    String? segmentsInput,
    FlowResult? rawResult,
    FlowResult? result,
    bool? isLoading,
    String? errorMessage,
    bool? isProUser,
    bool? upgradeRequired,
    bool clearError = false,
  }) {
    return FlowSimulationCalculatorState(
      velocityInput: velocityInput ?? this.velocityInput,
      depthInput: depthInput ?? this.depthInput,
      widthInput: widthInput ?? this.widthInput,
      slopeInput: slopeInput ?? this.slopeInput,
      roughnessInput: roughnessInput ?? this.roughnessInput,
      lengthInput: lengthInput ?? this.lengthInput,
      segmentsInput: segmentsInput ?? this.segmentsInput,
      rawResult: rawResult ?? this.rawResult,
      result: result ?? this.result,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isProUser: isProUser ?? this.isProUser,
      upgradeRequired: upgradeRequired ?? this.upgradeRequired,
    );
  }
}

class FlowSimulationCalculator extends Notifier<FlowSimulationCalculatorState> {
  @override
  FlowSimulationCalculatorState build() {
    // Get configurable defaults from provider (instead of hardcoded values)
    final defaults = ref.watch(flowSimulationDefaultsProvider);
    final precision = ref.watch(simulationPrecisionProvider);
    
    // Get defaults based on precision setting
    final precisionDefaults = FlowSimulationDefaultsByPrecision.forPrecision(precision);
    
    return FlowSimulationCalculatorState(
      velocityInput: defaults.defaultVelocity.toString(),
      depthInput: defaults.defaultDepth.toString(),
      widthInput: defaults.defaultWidth.toString(),
      slopeInput: defaults.defaultSlope.toString(),
      roughnessInput: defaults.defaultRoughness.toString(),
      lengthInput: defaults.defaultLength.toString(),
      segmentsInput: precisionDefaults.defaultSegments.toString(),
    );
  }

  void updateVelocity(String value) => state = state.copyWith(velocityInput: value, clearError: true);
  void updateDepth(String value) => state = state.copyWith(depthInput: value, clearError: true);
  void updateWidth(String value) => state = state.copyWith(widthInput: value, clearError: true);
  void updateSlope(String value) => state = state.copyWith(slopeInput: value, clearError: true);
  void updateRoughness(String value) => state = state.copyWith(roughnessInput: value, clearError: true);
  void updateLength(String value) => state = state.copyWith(lengthInput: value, clearError: true);
  void updateSegments(String value) => state = state.copyWith(segmentsInput: value, clearError: true);

  void setProStatus(bool status) => state = state.copyWith(isProUser: status);

  /// Simulates water flow.
  /// 
  /// POLICY: Domain returns FULL results. Application layer applies gating.
  /// - For Pro users: Full velocity/depth profile shown
  /// - For Free users: Only endpoints shown (upgrade prompt)
  Future<void> simulate() async {
    final double? v0 = double.tryParse(state.velocityInput);
    final double? y0 = double.tryParse(state.depthInput);
    final double? b = double.tryParse(state.widthInput);
    final double? s = double.tryParse(state.slopeInput);
    final double? n = double.tryParse(state.roughnessInput);
    final double? l = double.tryParse(state.lengthInput);
    final int? seg = int.tryParse(state.segmentsInput);

    if (v0 == null || y0 == null || b == null || s == null || n == null || l == null || seg == null) {
      state = state.copyWith(errorMessage: 'Please enter valid numerical values.');
      return;
    }

    state = state.copyWith(isLoading: true, clearError: true);

    await Future.delayed(const Duration(milliseconds: 500));

    try {
      // 1. Call Domain service - gets FULL results (no gating)
      final service = ref.read(flowSimulationServiceProvider);
      final input = FlowInput(
        initialVelocity: v0,
        initialDepth: y0,
        bedWidth: b,
        slope: s,
        roughness: n,
        totalLength: l,
        segments: seg,
      );

      final rawResult = service.simulate(input);
      
      // 2. APPLICATION LAYER POLICY: Filter based on Pro status
      final filteredResult = _applyProGating(rawResult);
      
      // Free users should see that full profile is a Pro feature
      final upgradeRequired = !state.isProUser && filteredResult.velocityProfile.length < rawResult.velocityProfile.length;
      
      state = state.copyWith(
        isLoading: false,
        rawResult: rawResult,
        result: filteredResult,
        upgradeRequired: upgradeRequired,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'Simulation failed: ${e.toString()}');
    }
  }

  /// APPLICATION LAYER POLICY:
  /// Filters profile data based on user Pro status.
  /// Free users see only endpoints (0 and end), Pro users see full profile.
  FlowResult _applyProGating(FlowResult raw) {
    if (state.isProUser) {
      // Pro users see everything
      return raw;
    }
    
    // Free users: Show only endpoints (upgrade prompt for full profile)
    return FlowResult(
      distancePoints: [raw.distancePoints.first, raw.distancePoints.last],
      velocityProfile: [raw.velocityProfile.first, raw.velocityProfile.last],
      dischargeProfile: [raw.dischargeProfile.first, raw.dischargeProfile.last],
      depthProfile: [raw.depthProfile.first, raw.depthProfile.last],
      totalHeadLoss: raw.totalHeadLoss, // Show loss but not profile
      simulationSummary: "Full velocity profile requires Pro. Upgrade to see detailed flow analysis.",
    );
  }

  void reset() {
    // Reset to current defaults from provider
    final defaults = ref.read(flowSimulationDefaultsProvider);
    final precision = ref.read(simulationPrecisionProvider);
    final precisionDefaults = FlowSimulationDefaultsByPrecision.forPrecision(precision);
    
    state = FlowSimulationCalculatorState(
      velocityInput: defaults.defaultVelocity.toString(),
      depthInput: defaults.defaultDepth.toString(),
      widthInput: defaults.defaultWidth.toString(),
      slopeInput: defaults.defaultSlope.toString(),
      roughnessInput: defaults.defaultRoughness.toString(),
      lengthInput: defaults.defaultLength.toString(),
      segmentsInput: precisionDefaults.defaultSegments.toString(),
    );
  }
}
