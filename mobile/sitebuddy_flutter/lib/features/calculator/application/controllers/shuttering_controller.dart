import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:site_buddy/core/calculations/material_estimation_service.dart';
import 'package:site_buddy/core/errors/app_failure.dart';
import 'package:site_buddy/core/utils/validators.dart';
import 'package:site_buddy/features/calculator/application/state/shuttering_state.dart';
import 'package:site_buddy/shared/domain/models/prefill_data.dart';
import 'package:site_buddy/shared/domain/models/calculation_history_entry.dart';
import 'package:site_buddy/shared/application/providers/project_providers.dart';
import 'package:site_buddy/shared/application/mappers/design_report_mapper.dart';
import 'package:site_buddy/shared/presentation/providers/history_providers.dart';

final shutteringProvider =
    NotifierProvider<ShutteringController, ShutteringState>(
      ShutteringController.new,
    );

class ShutteringController extends Notifier<ShutteringState> {
  final _service = MaterialEstimationService();

  @override
  ShutteringState build() => ShutteringState.initial();

  void initializeWithPrefill(ShutteringPrefillData data) {
    state = state.copyWith(
      lengthInput: data.length?.toString() ?? state.lengthInput,
      widthInput: data.width?.toString() ?? state.widthInput,
      depthInput: data.depth?.toString() ?? state.depthInput,
      clearFailure: true,
      clearResult: true,
    );

    if (data.length != null && data.width != null && data.depth != null) {
      calculate();
    }
  }

  void updateLength(String value) =>
      state = state.copyWith(lengthInput: value, clearFailure: true);
  void updateWidth(String value) =>
      state = state.copyWith(widthInput: value, clearFailure: true);
  void updateDepth(String value) =>
      state = state.copyWith(depthInput: value, clearFailure: true);
  void updateIncludeBottom(bool value) =>
      state = state.copyWith(includeBottom: value, clearFailure: true);

  Future<void> calculate() async {
    state = state.copyWith(
      isLoading: true,
      clearFailure: true,
      clearResult: true,
    );

    final l = Validators.parsePositiveNumber(state.lengthInput, 'Length');
    final w = Validators.parsePositiveNumber(state.widthInput, 'Width');
    final d = Validators.parsePositiveNumber(state.depthInput, 'Depth');

    if (l.failure != null) return _onError(l.failure!);
    if (w.failure != null) return _onError(w.failure!);
    if (d.failure != null) return _onError(d.failure!);

    await Future.delayed(const Duration(milliseconds: 300));

    try {
      final res = _service.calculateShutteringArea(
        length: l.value!,
        width: w.value!,
        depth: d.value!,
        includeBottom: state.includeBottom,
      );
      state = state.copyWith(isLoading: false, result: res);

      // --- PERSISTENCE: Save to Unified Calculation Repository ---
      // Session-based architecture: Watch the project session service for reactivity
      // FAIL-FAST: getActiveProjectId() throws StateError if no project - must have active project
      final projectSession = ref.watch(projectSessionServiceProvider);
      final projectId = projectSession.getActiveProjectId();

      // DEBUG: Log data usage and save
      debugPrint('[Usage] Using project: $projectId');
      debugPrint('[History] Saving for project: $projectId');

      final entry = CalculationHistoryEntry(
        id: const Uuid().v4(),
        projectId: projectId,
        calculationType: CalculationType.shuttering,
        timestamp: DateTime.now(),
        inputParameters: {
          'length': l.value,
          'width': w.value,
          'depth': d.value,
          'includeBottom': state.includeBottom,
        },
        resultSummary:
            '${res.areaM2.toStringAsFixed(1)} m² Shuttering Estimated',
        resultData: res.toMap(),
      );

      await ref.read(sharedHistoryRepositoryProvider).addEntry(entry);

      // --- SYNC: Save to Unified Design Report System ---
      final report = DesignReportMapper.fromShuttering(
        res.toMap(),
        entry.inputParameters,
        projectId,
      );
      await ref.read(historyRepositoryProvider).save(report);
    } catch (e) {
      _onError(AppFailure(e.toString()));
    }
  }

  void restore(Map<String, dynamic> params) {
    state = state.copyWith(
      lengthInput: params['length']?.toString() ?? '',
      widthInput: params['width']?.toString() ?? '',
      depthInput: params['depth']?.toString() ?? '',
      includeBottom: params['includeBottom'] as bool? ?? false,
      clearResult: true,
      clearFailure: true,
    );
    calculate();
  }

  void _onError(AppFailure f) =>
      state = state.copyWith(isLoading: false, failure: f);
  void reset() => state = ShutteringState.initial();
}
