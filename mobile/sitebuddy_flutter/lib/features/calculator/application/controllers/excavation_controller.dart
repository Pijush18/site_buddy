/// FILE HEADER
/// ----------------------------------------------
/// File: excavation_controller.dart
/// Feature: calculator
/// Layer: application/controllers
///
/// PURPOSE:
/// Manages state for the Excavation Volume Estimator with Save on Calculate behavior.
///
/// ----------------------------------------------
library;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/core/calculations/material_estimation_service.dart';
import 'package:site_buddy/core/errors/app_failure.dart';
import 'package:site_buddy/core/utils/validators.dart';
import 'package:site_buddy/features/calculator/application/state/excavation_state.dart';
import 'package:site_buddy/shared/application/providers/project_providers.dart';
import 'package:site_buddy/shared/application/mappers/design_report_mapper.dart';
import 'package:site_buddy/shared/application/services/history_saver.dart';
import 'package:site_buddy/shared/domain/models/excavation_result.dart';
import 'package:site_buddy/shared/domain/models/prefill_data.dart';

final excavationProvider =
    NotifierProvider<ExcavationController, ExcavationState>(
      ExcavationController.new,
    );

class ExcavationController extends Notifier<ExcavationState> {
  final _service = MaterialEstimationService();

  @override
  ExcavationState build() => ExcavationState.initial();

  void initializeWithPrefill(ExcavationPrefillData data) {
    state = state.copyWith(
      lengthInput: data.length?.toString() ?? state.lengthInput,
      widthInput: data.width?.toString() ?? state.widthInput,
      depthInput: data.depth?.toString() ?? state.depthInput,
      clearFailure: true,
      clearResult: true,
      hasSaved: false,
    );

    if (data.length != null && data.width != null && data.depth != null) {
      calculate();
    }
  }

  void updateLength(String value) =>
      state = state.copyWith(lengthInput: value, clearFailure: true, hasSaved: false);
  void updateWidth(String value) =>
      state = state.copyWith(widthInput: value, clearFailure: true, hasSaved: false);
  void updateDepth(String value) =>
      state = state.copyWith(depthInput: value, clearFailure: true, hasSaved: false);
  void updateClearance(String value) =>
      state = state.copyWith(clearanceInput: value, clearFailure: true, hasSaved: false);
  void updateSwellFactor(String value) =>
      state = state.copyWith(swellFactorInput: value, clearFailure: true, hasSaved: false);

  Future<void> calculate() async {
    final l = Validators.parsePositiveNumber(state.lengthInput, 'Length');
    final w = Validators.parsePositiveNumber(state.widthInput, 'Width');
    final d = Validators.parsePositiveNumber(state.depthInput, 'Depth');
    final c = Validators.parsePositiveNumber(state.clearanceInput, 'Clearance');
    final s = Validators.parsePositiveNumber(
      state.swellFactorInput,
      'Swell Factor',
    );

    if (l.failure != null) return _onError(l.failure!);
    if (w.failure != null) return _onError(w.failure!);
    if (d.failure != null) return _onError(d.failure!);

    state = state.copyWith(
      isLoading: true,
      clearFailure: true,
    );

    await Future.delayed(const Duration(milliseconds: 300));

    try {
      final res = _service.calculateExcavationVolume(
        length: l.value!,
        width: w.value!,
        depth: d.value!,
        clearance: c.value ?? 0.3,
        swellFactor: s.value ?? 1.25,
      );

      state = state.copyWith(
        isLoading: false, 
        result: res,
        hasSaved: false,
      );

      await _saveToHistory(res);

    } catch (e, st) {
      debugPrint("❌ Calculation failed: $e");
      debugPrintStack(stackTrace: st);
      _onError(AppFailure(e.toString()));
    }
  }

  Future<void> _saveToHistory(ExcavationResult result) async {
    if (state.hasSaved) return;

    final project = ref.read(activeProjectProvider);
    if (project == null) return;

    try {
      final inputParams = {
        'length': state.lengthInput,
        'width': state.widthInput,
        'depth': state.depthInput,
        'clearance': state.clearanceInput,
        'swell': state.swellFactorInput,
      };

      final report = DesignReportMapper.fromExcavation(
        result.toMap(),
        inputParams,
        project.id,
      );

      await HistorySaver.save(
        ref: ref,
        report: report,
      );

      state = state.copyWith(hasSaved: true);

    } catch (e) {
      debugPrint("❌ Save failed: $e");
    }
  }

  void restore(Map<String, dynamic> params) {
    state = state.copyWith(
      lengthInput: params['length']?.toString() ?? '',
      widthInput: params['width']?.toString() ?? '',
      depthInput: params['depth']?.toString() ?? '',
      clearanceInput: params['clearance']?.toString() ?? '',
      swellFactorInput: params['swell']?.toString() ?? '',
      clearResult: true,
      clearFailure: true,
      hasSaved: false,
    );
    calculate();
  }

  void _onError(AppFailure f) =>
      state = state.copyWith(isLoading: false, failure: f);
  void reset() => state = ExcavationState.initial();
}
