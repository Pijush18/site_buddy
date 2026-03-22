import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/providers/engine_providers.dart';
import 'package:site_buddy/features/transport/road/domain/models/pavement_design_result.dart';
import 'package:site_buddy/features/transport/road/domain/models/traffic_input.dart';
import 'package:site_buddy/features/transport/road/domain/models/traffic_result.dart';

/// lib/features/transport/road/application/road_calculator.dart
///
/// Application layer controller for the Road Pavement Calculator.
final roadCalculatorProvider = NotifierProvider<RoadCalculator, RoadCalculatorState>(
  RoadCalculator.new,
);

class RoadCalculatorState {
  final String cbrInput;
  final String msaInput;
  
  // Traffic Analysis Inputs
  final String initialTrafficInput; // CVPD
  final String growthRateInput;    // %
  final String designLifeInput;    // years
  final String vdfInput;           // Vehicle Damage Factor
  final String ldfInput;           // Lane Distribution Factor

  final PavementDesignResult? result;
  final TrafficResult? trafficResult;
  final bool isLoading;
  final String? errorMessage;
  final bool isProUser;

  const RoadCalculatorState({
    this.cbrInput = '',
    this.msaInput = '',
    this.initialTrafficInput = '1500',
    this.growthRateInput = '5.0',
    this.designLifeInput = '15',
    this.vdfInput = '3.5',
    this.ldfInput = '0.75',
    this.result,
    this.trafficResult,
    this.isLoading = false,
    this.errorMessage,
    this.isProUser = true,
  });

  RoadCalculatorState copyWith({
    String? cbrInput,
    String? msaInput,
    String? initialTrafficInput,
    String? growthRateInput,
    String? designLifeInput,
    String? vdfInput,
    String? ldfInput,
    PavementDesignResult? result,
    TrafficResult? trafficResult,
    bool? isLoading,
    String? errorMessage,
    bool? isProUser,
    bool clearError = false,
  }) {
    return RoadCalculatorState(
      cbrInput: cbrInput ?? this.cbrInput,
      msaInput: msaInput ?? this.msaInput,
      initialTrafficInput: initialTrafficInput ?? this.initialTrafficInput,
      growthRateInput: growthRateInput ?? this.growthRateInput,
      designLifeInput: designLifeInput ?? this.designLifeInput,
      vdfInput: vdfInput ?? this.vdfInput,
      ldfInput: ldfInput ?? this.ldfInput,
      result: result ?? this.result,
      trafficResult: trafficResult ?? this.trafficResult,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isProUser: isProUser ?? this.isProUser,
    );
  }
}

class RoadCalculator extends Notifier<RoadCalculatorState> {
  @override
  RoadCalculatorState build() => const RoadCalculatorState();

  void updateCBR(String value) => state = state.copyWith(cbrInput: value, clearError: true);
  void updateMSA(String value) => state = state.copyWith(msaInput: value, clearError: true);
  
  void updateInitialTraffic(String value) => state = state.copyWith(initialTrafficInput: value, clearError: true);
  void updateGrowthRate(String value) => state = state.copyWith(growthRateInput: value, clearError: true);
  void updateDesignLife(String value) => state = state.copyWith(designLifeInput: value, clearError: true);
  void updateVDF(String value) => state = state.copyWith(vdfInput: value, clearError: true);
  void updateLDF(String value) => state = state.copyWith(ldfInput: value, clearError: true);

  void setProStatus(bool status) => state = state.copyWith(isProUser: status);

  /// Analyzes traffic to compute MSA
  void calculateTraffic() {
    final double? a = double.tryParse(state.initialTrafficInput);
    final double? r = double.tryParse(state.growthRateInput);
    final int? n = int.tryParse(state.designLifeInput);
    final double? vdf = double.tryParse(state.vdfInput);
    final double? ldf = double.tryParse(state.ldfInput);

    if (a == null || r == null || n == null || vdf == null || ldf == null) {
      state = state.copyWith(errorMessage: 'Invalid traffic inputs.');
      return;
    }

    final service = ref.read(trafficAnalysisServiceProvider);
    final input = TrafficInput(
      initialTraffic: a,
      growthRate: r,
      designLife: n,
      vdf: vdf,
      ldf: ldf,
    );

    final result = service.analyzeTraffic(input);
    state = state.copyWith(
      trafficResult: result,
      msaInput: result.msa.toStringAsFixed(2),
      clearError: true,
    );
  }

  Future<void> calculatePavement() async {
    final double? cbr = double.tryParse(state.cbrInput);
    final double? msa = double.tryParse(state.msaInput);

    if (cbr == null || msa == null) {
      state = state.copyWith(errorMessage: 'Please enter valid numerical values for CBR and MSA.');
      return;
    }

    state = state.copyWith(isLoading: true, clearError: true);

    await Future.delayed(const Duration(milliseconds: 300));

    try {
      final service = ref.read(pavementDesignServiceProvider);
      
      final result = service.designPavement(
        cbr: cbr,
        msa: msa,
        isProUser: state.isProUser,
      );

      state = state.copyWith(isLoading: false, result: result);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'Calculation failed: ${e.toString()}');
    }
  }

  void reset() => state = const RoadCalculatorState();
}
