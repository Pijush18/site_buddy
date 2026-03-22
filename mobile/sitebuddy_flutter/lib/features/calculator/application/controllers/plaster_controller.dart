import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:site_buddy/core/calculations/material_estimation_service.dart';
import 'package:site_buddy/core/errors/app_failure.dart';
import 'package:site_buddy/core/utils/validators.dart';
import 'package:site_buddy/features/calculator/application/state/plaster_state.dart';
import 'package:site_buddy/shared/domain/models/plaster_ratio.dart';
import 'package:site_buddy/shared/domain/models/calculation_history_entry.dart';
import 'package:site_buddy/shared/application/providers/project_providers.dart';
import 'package:site_buddy/shared/application/mappers/design_report_mapper.dart';
import 'package:site_buddy/shared/presentation/providers/history_providers.dart';

final plasterProvider = NotifierProvider<PlasterController, PlasterState>(
  PlasterController.new,
);

class PlasterController extends Notifier<PlasterState> {
  final _service = MaterialEstimationService();

  @override
  PlasterState build() => PlasterState.initial();

  void updateArea(String value) {
    state = state.copyWith(areaInput: value, clearFailure: true);
  }

  void updateThickness(String value) {
    state = state.copyWith(thicknessInput: value, clearFailure: true);
  }

  void updateRatio(PlasterRatio value) {
    state = state.copyWith(selectedRatio: value, clearFailure: true);
  }

  Future<void> calculate() async {
    state = state.copyWith(
      isLoading: true,
      clearFailure: true,
      clearResult: true,
    );

    final areaParse = Validators.parsePositiveNumber(
      state.areaInput,
      'Wall Area',
    );
    if (areaParse.failure != null) {
      state = state.copyWith(isLoading: false, failure: areaParse.failure);
      return;
    }

    final thicknessParse = Validators.parsePositiveNumber(
      state.thicknessInput,
      'Plaster Thickness',
    );
    if (thicknessParse.failure != null) {
      state = state.copyWith(isLoading: false, failure: thicknessParse.failure);
      return;
    }

    final double thicknessMm = thicknessParse.value!;
    if (thicknessMm > 50.0) {
      state = state.copyWith(
        isLoading: false,
        failure: AppFailure(
          'Plaster Thickness seems high (${thicknessMm.toStringAsFixed(0)} mm). '
          'Typical range is 6–20 mm. Please verify your input.',
        ),
      );
      return;
    }

    final double thicknessM = thicknessMm / 1000.0;

    await Future.delayed(const Duration(milliseconds: 300));

    try {
      final result = _service.calculatePlasterMaterials(
        area: areaParse.value!,
        thickness: thicknessM,
        mortarRatioString: state.selectedRatio.ratioString,
      );

      state = state.copyWith(isLoading: false, result: result);

      // --- PERSISTENCE: Save to Unified Calculation Repository ---
      // Session-based architecture: Watch the project session service for reactivity
      // FAIL-FAST: getActiveProjectId() throws StateError if no project - must have active project
      final projectSession = ref.watch(projectSessionServiceProvider);
      final projectId = projectSession.getActiveProjectId();

      // DEBUG: Log history save
      debugPrint('[History] Saving for project: $projectId');

      final entry = CalculationHistoryEntry(
        id: const Uuid().v4(),
        projectId: projectId,
        calculationType: CalculationType.plaster,
        timestamp: DateTime.now(),
        inputParameters: {
          'area': areaParse.value,
          'thickness': thicknessMm,
          'mortarRatio': state.selectedRatio.ratioString,
        },
        resultSummary: '${result.cementBags.toStringAsFixed(1)} Bags Estimated',
        resultData: result.toMap(),
      );

      await ref.read(sharedHistoryRepositoryProvider).addEntry(entry);

      // --- SYNC: Save to Unified Design Report System ---
      final report = DesignReportMapper.fromPlaster(
        result.toMap(),
        entry.inputParameters,
        projectId,
      );
      await ref.read(historyRepositoryProvider).save(report);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        failure: AppFailure('Calculation error: ${e.toString()}'),
      );
    }
  }

  void restore(Map<String, dynamic> params) {
    final ratioStr = params['mortarRatio']?.toString() ?? '1:4';
    final ratio = PlasterRatio.fromString(ratioStr);

    state = state.copyWith(
      areaInput: params['area']?.toString() ?? '',
      thicknessInput: params['thickness']?.toString() ?? '',
      selectedRatio: ratio,
      clearResult: true,
    );
    calculate();
  }

  void reset() {
    state = PlasterState.initial();
  }
}
