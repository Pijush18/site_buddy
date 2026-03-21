import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:site_buddy/core/calculations/material_estimation_service.dart';
import 'package:site_buddy/core/errors/app_failure.dart';
import 'package:site_buddy/core/utils/validators.dart';
import 'package:site_buddy/features/calculator/application/state/plaster_state.dart';
import 'package:site_buddy/shared/domain/models/plaster_ratio.dart';
import 'package:site_buddy/shared/domain/models/calculation_history_entry.dart';
import 'package:site_buddy/shared/presentation/providers/history_providers.dart';
import 'package:site_buddy/features/project/application/controllers/project_controller.dart';

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
      final selectedProject = ref.read(projectControllerProvider).selectedProject;
      if (selectedProject != null) {
        final entry = CalculationHistoryEntry(
          id: const Uuid().v4(),
          projectId: selectedProject.id,
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

        ref.read(sharedHistoryRepositoryProvider).addEntry(entry);
      }
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



