import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:site_buddy/core/calculations/material_estimation_service.dart';
import 'package:site_buddy/core/errors/app_failure.dart';
import 'package:site_buddy/core/utils/validators.dart';
import 'package:site_buddy/features/calculator/application/state/brick_wall_state.dart';
import 'package:site_buddy/shared/domain/models/mortar_ratio.dart';
import 'package:site_buddy/shared/domain/models/prefill_data.dart';
import 'package:site_buddy/shared/domain/models/calculation_history_entry.dart';
import 'package:site_buddy/shared/presentation/providers/history_providers.dart';
import 'package:site_buddy/features/project/application/controllers/project_controller.dart';

final brickWallProvider = NotifierProvider<BrickWallController, BrickWallState>(
  BrickWallController.new,
);

class BrickWallController extends Notifier<BrickWallState> {
  final _service = MaterialEstimationService();

  @override
  BrickWallState build() => BrickWallState.initial();

  void initializeWithPrefill(BrickPrefillData data) {
    state = state.copyWith(
      lengthInput: data.length?.toString() ?? state.lengthInput,
      heightInput: data.height?.toString() ?? state.heightInput,
      thicknessInput: data.thickness?.toString() ?? state.thicknessInput,
      clearFailure: true,
      clearResult: true,
    );
    
    if (data.length != null && data.height != null && data.thickness != null) {
      calculate();
    }
  }

  void updateLength(String value) {
    state = state.copyWith(lengthInput: value, clearFailure: true);
  }

  void updateHeight(String value) {
    state = state.copyWith(heightInput: value, clearFailure: true);
  }

  void updateThickness(String value) {
    state = state.copyWith(thicknessInput: value, clearFailure: true);
  }

  void updateRatio(MortarRatio value) {
    state = state.copyWith(selectedRatio: value, clearFailure: true);
  }

  Future<void> calculate() async {
    state = state.copyWith(
      isLoading: true,
      clearFailure: true,
      clearResult: true,
    );

    final lParse = Validators.parsePositiveNumber(
      state.lengthInput,
      'Wall Length',
    );
    if (lParse.failure != null) {
      state = state.copyWith(isLoading: false, failure: lParse.failure);
      return;
    }

    final hParse = Validators.parsePositiveNumber(
      state.heightInput,
      'Wall Height',
    );
    if (hParse.failure != null) {
      state = state.copyWith(isLoading: false, failure: hParse.failure);
      return;
    }

    final tParse = Validators.parsePositiveNumber(
      state.thicknessInput,
      'Wall Thickness',
    );
    if (tParse.failure != null) {
      state = state.copyWith(isLoading: false, failure: tParse.failure);
      return;
    }

    await Future.delayed(const Duration(milliseconds: 300));

    try {
      final result = _service.calculateBrickWallMaterials(
        length: lParse.value!,
        height: hParse.value!,
        thickness: tParse.value!,
        mortarRatioString: state.selectedRatio.ratioString,
      );

      state = state.copyWith(isLoading: false, result: result);

      // --- PERSISTENCE: Save to Unified Calculation Repository ---
      final selectedProject = ref.read(projectControllerProvider).selectedProject;
      if (selectedProject != null) {
        final entry = CalculationHistoryEntry(
          id: const Uuid().v4(),
          projectId: selectedProject.id,
          calculationType: CalculationType.brick,
          timestamp: DateTime.now(),
          inputParameters: {
            'length': lParse.value,
            'height': hParse.value,
            'thickness': tParse.value,
            'mortarRatio': state.selectedRatio.ratioString,
          },
          resultSummary: '${result.numberOfBricks} Bricks Estimated',
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
    final ratioStr = params['mortarRatio']?.toString() ?? '1:6';
    final ratio = MortarRatio.fromString(ratioStr);

    state = state.copyWith(
      lengthInput: params['length']?.toString() ?? '',
      heightInput: params['height']?.toString() ?? '',
      thicknessInput: params['thickness']?.toString() ?? '',
      selectedRatio: ratio,
      clearResult: true,
    );
    calculate();
  }

  void reset() {
    state = BrickWallState.initial();
  }
}



