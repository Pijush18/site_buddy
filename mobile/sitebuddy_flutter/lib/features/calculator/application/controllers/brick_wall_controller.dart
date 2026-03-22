import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/errors/app_failure.dart';
import 'package:site_buddy/core/logging/app_logger.dart';
import 'package:site_buddy/core/utils/validators.dart';
import 'package:site_buddy/features/calculator/application/state/brick_wall_state.dart';
import 'package:site_buddy/shared/domain/models/mortar_ratio.dart';
import 'package:site_buddy/shared/domain/models/prefill_data.dart';
import 'package:site_buddy/shared/application/providers/project_providers.dart';
import 'package:site_buddy/shared/application/mappers/design_report_mapper.dart';
import 'package:site_buddy/shared/domain/models/brick_wall_result.dart';
import 'package:site_buddy/shared/application/services/history_saver.dart';
import 'package:site_buddy/core/providers/engine_providers.dart';
import 'package:site_buddy/features/design/brick/brick_models.dart';

final brickWallProvider = NotifierProvider<BrickWallController, BrickWallState>(
  BrickWallController.new,
);

class BrickWallController extends Notifier<BrickWallState> {
  @override
  BrickWallState build() => BrickWallState.initial();

  void initializeWithPrefill(BrickPrefillData data) {
    state = state.copyWith(
      lengthInput: data.length?.toString() ?? state.lengthInput,
      heightInput: data.height?.toString() ?? state.heightInput,
      thicknessInput: data.thickness?.toString() ?? state.thicknessInput,
      clearFailure: true,
      clearResult: true,
      hasSaved: false,
    );

    if (data.length != null && data.height != null && data.thickness != null) {
      calculate();
    }
  }

  void updateLength(String value) {
    state = state.copyWith(lengthInput: value, clearFailure: true, hasSaved: false);
  }

  void updateHeight(String value) {
    state = state.copyWith(heightInput: value, clearFailure: true, hasSaved: false);
  }

  void updateThickness(String value) {
    state = state.copyWith(thicknessInput: value, clearFailure: true, hasSaved: false);
  }

  void updateRatio(MortarRatio value) {
    state = state.copyWith(selectedRatio: value, clearFailure: true, hasSaved: false);
  }

  Future<void> calculate() async {
    final lParse = Validators.parsePositiveNumber(state.lengthInput, 'Wall Length');
    final hParse = Validators.parsePositiveNumber(state.heightInput, 'Wall Height');
    final tParse = Validators.parsePositiveNumber(state.thicknessInput, 'Wall Thickness');

    if (lParse.failure != null || hParse.failure != null || tParse.failure != null) {
      state = state.copyWith(
        isLoading: false, 
        failure: lParse.failure ?? hParse.failure ?? tParse.failure,
      );
      return;
    }

    state = state.copyWith(isLoading: true, clearFailure: true);

    await Future.delayed(const Duration(milliseconds: 300));

    try {
      final service = ref.read(brickDesignServiceProvider);
      final input = BrickInput(
        length: lParse.value!,
        height: hParse.value!,
        thickness: tParse.value!,
        mortarRatio: state.selectedRatio.ratioString,
      );

      final result = service.calculateMaterials(input);

      state = state.copyWith(
        isLoading: false, 
        result: result,
        hasSaved: false,
      );

      await _saveToHistory(result);

    } catch (e, st) {
      AppLogger.error('Calculation failed', error: e, stackTrace: st);
      state = state.copyWith(
        isLoading: false,
        failure: AppFailure('Calculation error: ${e.toString()}'),
      );
    }
  }

  Future<void> _saveToHistory(BrickWallResult result) async {
    if (state.hasSaved) return;

    final project = ref.read(activeProjectProvider);
    if (project == null) return;

    try {
      final inputParams = {
        'length': state.lengthInput,
        'height': state.heightInput,
        'thickness': state.thicknessInput,
        'mortarRatio': state.selectedRatio.ratioString,
      };

      final report = DesignReportMapper.fromBrickWall(
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
      AppLogger.error('Save failed', error: e);
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
      hasSaved: false,
    );
    calculate();
  }

  void reset() {
    state = BrickWallState.initial();
  }
}
