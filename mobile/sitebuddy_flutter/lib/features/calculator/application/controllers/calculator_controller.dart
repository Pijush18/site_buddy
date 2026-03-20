/// FILE HEADER
/// ----------------------------------------------
/// File: calculator_controller.dart
/// Feature: calculator
/// Layer: application
///
/// PURPOSE:
/// Notifier to manage the Material Calculator's state in reaction to user inputs.
///
/// RESPONSIBILITIES:
/// - Intercepts user actions (dimensions, grade, steel ratio, waste factor).
/// - Calls [MaterialEstimationService] to compute a rich [ConcreteMaterialResult].
/// - Emits new [CalculatorState] which Riverpod consumers react to.
///
/// DEPENDENCIES:
/// - Riverpod, CalculatorState, MaterialEstimationService, ConcreteMixConstants.
///
/// DESIGN NOTES:
/// - The old [CalculateMaterialUseCase] is deliberately NOT removed.
///   Its import is left in a commented block so existing git-bisect and other
///   tools still locate the historical reference.
/// - All arithmetic lives in [MaterialEstimationService]; this controller
///   only validates inputs, constructs the service call, and emits state.
///
/// FUTURE IMPROVEMENTS:
/// - Debounce rapid input events.
/// - Persist the last result to Hive via a repository layer.
///
/// ----------------------------------------------
library;

import 'dart:developer' as dev;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/core/calculations/material_estimation_service.dart';
import 'package:site_buddy/core/constants/concrete_mix_constants.dart';
import 'package:site_buddy/core/constants/error_strings.dart';
import 'package:site_buddy/core/constants/validation_strings.dart';
import 'package:site_buddy/core/constants/engineering_terms.dart';
import 'package:site_buddy/core/errors/app_failure.dart';
import 'package:site_buddy/core/utils/validators.dart';
import 'package:site_buddy/features/calculator/application/state/calculator_state.dart';
import 'package:site_buddy/shared/domain/models/concrete_grade.dart';
import 'package:site_buddy/shared/domain/models/prefill_data.dart';

/// Provider exposing the [CalculatorController] — the main touchpoint for
/// the Material Calculator UI.
final calculatorProvider =
    NotifierProvider<CalculatorController, CalculatorState>(
      CalculatorController.new,
    );

/// CLASS: CalculatorController
/// PURPOSE: Riverpod state controller that binds [MaterialEstimationService]
///          to the UI.  The UI never performs arithmetic.
class CalculatorController extends Notifier<CalculatorState> {
  // Stateless service — safe to construct exactly once per controller instance.
  final _service = MaterialEstimationService();

  @override
  CalculatorState build() => CalculatorState.initial();

  // ──────────────────────────────────────────────────────────────────────────
  // Input mutators
  // ──────────────────────────────────────────────────────────────────────────

  /// Prefills the controller state with values extracted from an AI query.
  void initializeWithPrefill(ConcretePrefillData data) {
    state = state.copyWith(
      lengthInput: data.length?.toString() ?? state.lengthInput,
      widthInput: data.width?.toString() ?? state.widthInput,
      depthInput: data.thickness?.toString() ?? state.depthInput,
      clearFailure: true,
    );

    // Auto-calculate if we have all core dimensions
    if (data.length != null && data.width != null && data.thickness != null) {
      calculate();
    }
  }

  /// Updates the length text input and clears any current validation failure.
  void updateLength(String value) {
    state = state.copyWith(lengthInput: value, clearFailure: true);
  }

  /// Updates the width text input and clears any current validation failure.
  void updateWidth(String value) {
    state = state.copyWith(widthInput: value, clearFailure: true);
  }

  /// Updates the depth text input and clears any current validation failure.
  void updateDepth(String value) {
    state = state.copyWith(depthInput: value, clearFailure: true);
  }

  /// Updates the selected concrete grade (enum value from the dropdown).
  void updateGrade(ConcreteGrade grade) {
    state = state.copyWith(grade: grade, clearFailure: true);
  }

  /// Updates the steel reinforcement ratio text (entered as a percentage,
  /// e.g. "1" means 1 %).
  void updateSteelRatio(String value) {
    state = state.copyWith(steelRatioInput: value, clearFailure: true);
  }

  /// Updates the material waste percentage text (e.g. "5" means 5 %).
  void updateWasteFactor(String value) {
    state = state.copyWith(wasteFactorInput: value, clearFailure: true);
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Calculation
  // ──────────────────────────────────────────────────────────────────────────

  /// Validates all inputs, calls [MaterialEstimationService], and emits a new
  /// [CalculatorState] containing the rich [ConcreteMaterialResult].
  ///
  /// LOGIC:
  ///  1. Validate Length, Width, Depth (must be strictly positive).
  ///  2. Parse Steel Ratio % (may be 0; defaults to 0 if empty).
  ///  3. Parse Waste Factor % (may be 0; defaults to 0 if empty).
  ///  4. Map selected [ConcreteGrade] enum to a [ConcreteMix] from
  ///     [ConcreteMixConstants] using the grade label.
  ///  5. Apply waste factor to each dimension's effective volume via a
  ///     multiplier: effectiveDepth = depth * (1 + wastePct/100).
  ///     (Applying to depth keeps L × W semantics clean and avoids multiplying
  ///     all three dimensions which would cube the waste.)
  ///  6. Call [MaterialEstimationService.calculateConcreteMaterials].
  ///  7. Emit the result.
  Future<void> calculate() async {
    state = state.copyWith(isLoading: true, clearFailure: true);

    // ── Validate core dimensions ────────────────────────────────────────────
    final lParse = Validators.parsePositiveNumber(
      state.lengthInput,
      EngineeringTerms.length,
    );
    if (lParse.failure != null) {
      state = state.copyWith(isLoading: false, failure: lParse.failure);
      return;
    }

    final wParse = Validators.parsePositiveNumber(
      state.widthInput,
      EngineeringTerms.width,
    );
    if (wParse.failure != null) {
      state = state.copyWith(isLoading: false, failure: wParse.failure);
      return;
    }

    final dParse = Validators.parsePositiveNumber(
      state.depthInput,
      EngineeringTerms.depth,
    );
    if (dParse.failure != null) {
      state = state.copyWith(isLoading: false, failure: dParse.failure);
      return;
    }

    // ── Parse optional percentage fields ────────────────────────────────────
    // Steel ratio: empty string or blank → 0 (plain concrete).
    final double steelPct =
        _parseSafePercent(
          state.steelRatioInput,
          EngineeringTerms.steelRatio,
        ).pct ??
        0.0;
    if (_parseSafePercent(
          state.steelRatioInput,
          EngineeringTerms.steelRatio,
        ).failure !=
        null) {
      state = state.copyWith(
        isLoading: false,
        failure: _parseSafePercent(
          state.steelRatioInput,
          EngineeringTerms.steelRatio,
        ).failure,
      );
      return;
    }

    // Waste factor: empty string or blank → 0 %.
    final double wastePct =
        _parseSafePercent(
          state.wasteFactorInput,
          EngineeringTerms.wasteFactor,
        ).pct ??
        0.0;
    if (_parseSafePercent(
          state.wasteFactorInput,
          EngineeringTerms.wasteFactor,
        ).failure !=
        null) {
      state = state.copyWith(
        isLoading: false,
        failure: _parseSafePercent(
          state.wasteFactorInput,
          EngineeringTerms.wasteFactor,
        ).failure,
      );
      return;
    }

    // ── Map ConcreteGrade enum → ConcreteMix ────────────────────────────────
    // ConcreteMixConstants.byGrade falls back to M20 when grade is unknown.
    final mix =
        ConcreteMixConstants.byGrade(state.grade.label) ??
        ConcreteMixConstants.m20;

    // ── Apply waste factor ───────────────────────────────────────────────────
    // We inflate the depth dimension by (1 + waste/100) so that the resulting
    // volume already accounts for on-site material wastage.
    final double effectiveDepth = dParse.value! * (1.0 + wastePct / 100.0);

    // ── UX delay (keeps feedback rhythm consistent with heavier calculations) ─
    await Future.delayed(const Duration(milliseconds: 300));

    // ── Call the service ─────────────────────────────────────────────────────
    try {
      final concreteResult = _service.calculateConcreteMaterials(
        length: lParse.value!,
        width: wParse.value!,
        depth: effectiveDepth,
        grade: mix,
        steelPercentage: steelPct / 100.0, // convert % → fraction
      );

      dev.log(
        '[CalculatorController] Result: $concreteResult',
        name: 'MaterialCalculator',
      );

      state = state.copyWith(
        isLoading: false,
        concreteResult: concreteResult,
        clearFailure: true,
      );
    } catch (e, st) {
      dev.log(
        '[CalculatorController] Service threw: $e',
        name: 'MaterialCalculator',
        stackTrace: st,
      );
      state = state.copyWith(
        isLoading: false,
        failure: AppFailure(
          '${ErrorStrings.calculationError}: ${e.toString()}',
        ),
      );
    }
  }

  void reset() => state = CalculatorState.initial();

  // ──────────────────────────────────────────────────────────────────────────
  // Private helpers
  // ──────────────────────────────────────────────────────────────────────────

  /// Attempts to parse [raw] as a non-negative percentage.
  ///
  /// Returns `(pct: value, failure: null)` on success, or
  /// `(pct: null, failure: AppFailure(...))` on invalid input.
  /// An empty / blank string returns `(pct: 0, failure: null)`.
  ({double? pct, AppFailure? failure}) _parseSafePercent(
    String raw,
    String fieldName,
  ) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return (pct: 0.0, failure: null);

    final parsed = double.tryParse(trimmed);
    if (parsed == null) {
      return (
        pct: null,
        failure: AppFailure(
          '$fieldName ${ValidationStrings.mustBeValidNumber}',
        ),
      );
    }
    if (parsed < 0) {
      return (
        pct: null,
        failure: AppFailure('$fieldName ${ValidationStrings.cannotBeNegative}'),
      );
    }
    return (pct: parsed, failure: null);
  }
}



