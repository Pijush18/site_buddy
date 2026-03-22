import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/errors/app_failure.dart';
import 'package:site_buddy/core/logging/app_logger.dart';
import 'package:site_buddy/core/utils/validators.dart';
import 'package:site_buddy/features/estimation/plaster/domain/plaster_state.dart';
import 'package:site_buddy/core/engineering/models/plaster_ratio.dart';
import 'package:site_buddy/shared/application/providers/project_providers.dart';
import 'package:site_buddy/shared/application/mappers/design_report_mapper.dart';
import 'package:site_buddy/shared/application/services/history_saver.dart';
import 'package:site_buddy/core/providers/engine_providers.dart';
import 'package:site_buddy/features/estimation/plaster/domain/plaster_models.dart';

final plasterProvider = NotifierProvider<PlasterController, PlasterState>(
  PlasterController.new,
);

class PlasterController extends Notifier<PlasterState> {
  @override
  PlasterState build() => PlasterState.initial();

  void updateArea(String value) {
    state = state.copyWith(areaInput: value, clearFailure: true, hasSaved: false);
  }

  void updateThickness(String value) {
    state = state.copyWith(thicknessInput: value, clearFailure: true, hasSaved: false);
  }

  void updateRatio(PlasterRatio value) {
    state = state.copyWith(selectedRatio: value, clearFailure: true, hasSaved: false);
  }

  Future<void> calculate() async {
    final areaParse = Validators.parsePositiveNumber(state.areaInput, 'Wall Area');
    final thicknessParse = Validators.parsePositiveNumber(state.thicknessInput, 'Plaster Thickness');

    if (areaParse.failure != null) {
      state = state.copyWith(isLoading: false, failure: areaParse.failure);
      return;
    }
    if (thicknessParse.failure != null) {
      state = state.copyWith(isLoading: false, failure: thicknessParse.failure);
      return;
    }

    final double thicknessMm = thicknessParse.value!;
    if (thicknessMm > 50.0) {
      state = state.copyWith(
        isLoading: false,
        failure: AppFailure('Plaster Thickness seems high (${thicknessMm.toStringAsFixed(0)} mm). Typical range is 6–20 mm.'),
      );
      return;
    }

    state = state.copyWith(isLoading: true, clearFailure: true, clearResult: true);

    final double thicknessM = thicknessMm / 1000.0;

    await Future.delayed(const Duration(milliseconds: 300));

    try {
      final service = ref.read(plasterDesignServiceProvider);
      final input = PlasterInput(
        area: areaParse.value!,
        thickness: thicknessM,
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

  Future<void> _saveToHistory(PlasterMaterialResult result) async {
    if (state.hasSaved) return;

    final project = ref.read(activeProjectProvider);
    if (project == null) return;

    try {
      final inputParams = {
        'area': state.areaInput,
        'thickness': state.thicknessInput,
        'mortarRatio': state.selectedRatio.ratioString,
      };

      final report = DesignReportMapper.fromPlaster(
        result.toMap(),
        inputParams,
        project.id,
      );

      await HistorySaver.save(ref: ref, report: report);

      state = state.copyWith(hasSaved: true);

    } catch (e) {
      AppLogger.error('Save failed', error: e);
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
      hasSaved: false,
    );
    calculate();
  }

  void reset() {
    state = PlasterState.initial();
  }
}


