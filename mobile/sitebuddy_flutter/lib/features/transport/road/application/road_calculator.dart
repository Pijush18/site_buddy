import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/providers/engine_providers.dart';
import 'package:site_buddy/core/config/engine_defaults.dart';
import 'package:site_buddy/features/transport/road/domain/models/pavement_design_result.dart';
import 'package:site_buddy/features/transport/road/domain/models/pavement_layer.dart';
import 'package:site_buddy/features/transport/road/domain/models/traffic_input.dart';
import 'package:site_buddy/features/transport/road/domain/models/traffic_result.dart';

/// lib/features/transport/road/application/road_calculator.dart
///
/// Application layer controller for the Road Pavement Calculator.
/// 
/// APPLICATION LAYER PATTERN:
/// - Calls Domain services to get complete, truthful results
/// - Applies Pro/premium gating policy HERE (not in Domain)
/// - Controls what is exposed to the Presentation layer
/// - Uses configurable defaults from providers (not hardcoded)
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

  final PavementDesignResult? rawResult;     // Complete domain result (not exposed)
  final PavementDesignResult? result;        // Filtered result (exposed to UI)
  final TrafficResult? trafficResult;
  final bool isLoading;
  final String? errorMessage;
  final bool isProUser;
  final bool upgradeRequired;       // Application layer policy flag
  final List<String> lockedFeatures; // List of locked feature names
  final String standardCode;         // Current standard being used

  const RoadCalculatorState({
    this.cbrInput = '',
    this.msaInput = '',
    this.initialTrafficInput = '',
    this.growthRateInput = '',
    this.designLifeInput = '',
    this.vdfInput = '',
    this.ldfInput = '',
    this.rawResult,
    this.result,
    this.trafficResult,
    this.isLoading = false,
    this.errorMessage,
    this.isProUser = false,
    this.upgradeRequired = false,
    this.lockedFeatures = const [],
    this.standardCode = 'IRC:37-2018',
  });

  RoadCalculatorState copyWith({
    String? cbrInput,
    String? msaInput,
    String? initialTrafficInput,
    String? growthRateInput,
    String? designLifeInput,
    String? vdfInput,
    String? ldfInput,
    PavementDesignResult? rawResult,
    PavementDesignResult? result,
    TrafficResult? trafficResult,
    bool? isLoading,
    String? errorMessage,
    bool? isProUser,
    bool? upgradeRequired,
    List<String>? lockedFeatures,
    String? standardCode,
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
      rawResult: rawResult ?? this.rawResult,
      result: result ?? this.result,
      trafficResult: trafficResult ?? this.trafficResult,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isProUser: isProUser ?? this.isProUser,
      upgradeRequired: upgradeRequired ?? this.upgradeRequired,
      lockedFeatures: lockedFeatures ?? this.lockedFeatures,
      standardCode: standardCode ?? this.standardCode,
    );
  }
}

class RoadCalculator extends Notifier<RoadCalculatorState> {
  @override
  RoadCalculatorState build() {
    // Get configurable defaults from provider (instead of hardcoded values)
    final defaults = ref.watch(roadDefaultsProvider);
    
    return RoadCalculatorState(
      initialTrafficInput: defaults.defaultInitialTraffic.toString(),
      growthRateInput: defaults.defaultGrowthRate.toString(),
      designLifeInput: defaults.defaultDesignLife.toString(),
      vdfInput: defaults.defaultVDF.toString(),
      ldfInput: defaults.defaultLDF.toString(),
      standardCode: defaults.standardCode,
    );
  }

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

  /// Calculates pavement design.
  /// 
  /// POLICY: Domain returns FULL results. Application layer applies gating.
  /// - For Pro users: Full layer details shown
  /// - For Free users: Only GSB layer details shown, others marked as locked
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
      // 1. Call Domain service - always gets FULL results (no gating)
      final service = ref.read(pavementDesignServiceProvider);
      final rawResult = service.designPavement(
        cbr: cbr,
        msa: msa,
      );

      // 2. APPLICATION LAYER POLICY: Apply Pro gating here
      final filteredResult = _applyProGating(rawResult);
      
      state = state.copyWith(
        isLoading: false,
        rawResult: rawResult,
        result: filteredResult,
        upgradeRequired: !state.isProUser && filteredResult.layers.length < rawResult.layers.length,
        lockedFeatures: _getLockedFeatureNames(rawResult, filteredResult),
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'Calculation failed: ${e.toString()}');
    }
  }

  /// APPLICATION LAYER POLICY:
  /// Filters layer details based on user Pro status.
  PavementDesignResult _applyProGating(PavementDesignResult raw) {
    if (state.isProUser) {
      // Pro users see everything
      return raw;
    }
    
    // Free users: Only show GSB layer details, lock others
    final filteredLayers = raw.layers.map((layer) {
      if (layer.name.contains('GSB')) {
        return layer;
      }
      // Replace non-GSB layers with locked versions
      return PavementLayer(
        name: layer.name,
        thickness: layer.thickness,
        materialType: layer.materialType,
        specification: layer.specification,
        isLocked: true, // UI flag - set here in Application layer
      );
    }).toList();

    return PavementDesignResult(
      totalThickness: raw.totalThickness,
      layers: filteredLayers,
      safetyClassification: raw.safetyClassification,
      cbrProvided: raw.cbrProvided,
      msaDesign: raw.msaDesign,
      suggestedOptimization: null, // Pro feature - not shown to free users
    );
  }

  List<String> _getLockedFeatureNames(PavementDesignResult raw, PavementDesignResult filtered) {
    final locked = <String>[];
    for (int i = 0; i < raw.layers.length; i++) {
      if (i < filtered.layers.length && filtered.layers[i].isLocked) {
        locked.add(raw.layers[i].name);
      }
    }
    return locked;
  }

  void reset() {
    // Reset to current defaults from provider
    final defaults = ref.read(roadDefaultsProvider);
    state = RoadCalculatorState(
      initialTrafficInput: defaults.defaultInitialTraffic.toString(),
      growthRateInput: defaults.defaultGrowthRate.toString(),
      designLifeInput: defaults.defaultDesignLife.toString(),
      vdfInput: defaults.defaultVDF.toString(),
      ldfInput: defaults.defaultLDF.toString(),
      standardCode: defaults.standardCode,
    );
  }
}
