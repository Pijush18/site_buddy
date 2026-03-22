import 'dart:developer' as dev;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/constants/concrete_mix_constants.dart';
import 'package:site_buddy/core/constants/error_strings.dart';
import 'package:site_buddy/core/constants/validation_strings.dart';
import 'package:site_buddy/core/constants/engineering_terms.dart';
import 'package:site_buddy/core/errors/app_failure.dart';
import 'package:site_buddy/core/utils/validators.dart';
import 'package:site_buddy/features/estimation/concrete/domain/concrete_state.dart';
import 'package:site_buddy/core/engineering/models/concrete_grade.dart';
import 'package:site_buddy/core/models/prefill_data.dart';
import 'package:site_buddy/core/providers/engine_providers.dart';
import 'package:site_buddy/features/estimation/concrete/domain/concrete_models.dart';

final calculatorProvider = NotifierProvider<CalculatorController, CalculatorState>(
  CalculatorController.new,
);

class CalculatorController extends Notifier<CalculatorState> {
  @override
  CalculatorState build() => CalculatorState.initial();

  void initializeWithPrefill(ConcretePrefillData data) {
    state = state.copyWith(
      lengthInput: data.length?.toString() ?? state.lengthInput,
      widthInput: data.width?.toString() ?? state.widthInput,
      depthInput: data.thickness?.toString() ?? state.depthInput,
      clearFailure: true,
    );

    if (data.length != null && data.width != null && data.thickness != null) {
      calculate();
    }
  }

  void updateLength(String value) {
    state = state.copyWith(lengthInput: value, clearFailure: true);
  }

  void updateWidth(String value) {
    state = state.copyWith(widthInput: value, clearFailure: true);
  }

  void updateDepth(String value) {
    state = state.copyWith(depthInput: value, clearFailure: true);
  }

  void updateGrade(ConcreteGrade grade) {
    state = state.copyWith(grade: grade, clearFailure: true);
  }

  void updateSteelRatio(String value) {
    state = state.copyWith(steelRatioInput: value, clearFailure: true);
  }

  void updateWasteFactor(String value) {
    state = state.copyWith(wasteFactorInput: value, clearFailure: true);
  }

  Future<void> calculate() async {
    state = state.copyWith(isLoading: true, clearFailure: true);

    final lParse = Validators.parsePositiveNumber(state.lengthInput, EngineeringTerms.length);
    final wParse = Validators.parsePositiveNumber(state.widthInput, EngineeringTerms.width);
    final dParse = Validators.parsePositiveNumber(state.depthInput, EngineeringTerms.depth);

    if (lParse.failure != null || wParse.failure != null || dParse.failure != null) {
      state = state.copyWith(
        isLoading: false, 
        failure: lParse.failure ?? wParse.failure ?? dParse.failure,
      );
      return;
    }

    final double steelPct = _parseSafePercent(state.steelRatioInput, EngineeringTerms.steelRatio).pct ?? 0.0;
    final double wastePct = _parseSafePercent(state.wasteFactorInput, EngineeringTerms.wasteFactor).pct ?? 0.0;

    final mix = ConcreteMixConstants.byGrade(state.grade.label) ?? ConcreteMixConstants.m20;

    // Apply waste factor to depth
    final double effectiveDepth = dParse.value! * (1.0 + wastePct / 100.0);

    await Future.delayed(const Duration(milliseconds: 300));

    try {
      final service = ref.read(concreteDesignServiceProvider);
      final input = ConcreteInput(
        length: lParse.value!,
        width: wParse.value!,
        depth: effectiveDepth,
        grade: mix,
        steelPercentage: steelPct / 100.0,
      );

      final concreteResult = service.calculateMaterials(input);

      state = state.copyWith(
        isLoading: false,
        concreteResult: concreteResult,
        clearFailure: true,
      );
    } catch (e, st) {
      dev.log('[CalculatorController] Service threw: $e', name: 'MaterialCalculator', stackTrace: st);
      state = state.copyWith(
        isLoading: false,
        failure: AppFailure('${ErrorStrings.calculationError}: ${e.toString()}'),
      );
    }
  }

  void reset() => state = CalculatorState.initial();

  ({double? pct, AppFailure? failure}) _parseSafePercent(String raw, String fieldName) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return (pct: 0.0, failure: null);
    final parsed = double.tryParse(trimmed);
    if (parsed == null) {
      return (pct: null, failure: AppFailure('$fieldName ${ValidationStrings.mustBeValidNumber}'));
    }
    if (parsed < 0) {
      return (pct: null, failure: AppFailure('$fieldName ${ValidationStrings.cannotBeNegative}'));
    }
    return (pct: parsed, failure: null);
  }
}


