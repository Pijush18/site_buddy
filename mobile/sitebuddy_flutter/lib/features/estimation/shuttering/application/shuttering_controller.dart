import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/errors/app_failure.dart';
import 'package:site_buddy/core/logging/app_logger.dart';
import 'package:site_buddy/core/utils/validators.dart';
import 'package:site_buddy/features/estimation/shuttering/domain/shuttering_state.dart';
import 'package:site_buddy/core/models/prefill_data.dart';
import 'package:site_buddy/shared/application/providers/project_providers.dart';
import 'package:site_buddy/shared/application/mappers/design_report_mapper.dart';
import 'package:site_buddy/shared/application/services/history_saver.dart';
import 'package:site_buddy/core/providers/engine_providers.dart';
import 'package:site_buddy/features/estimation/shuttering/domain/shuttering_models.dart';

final shutteringProvider = NotifierProvider<ShutteringController, ShutteringState>(
  ShutteringController.new,
);

class ShutteringController extends Notifier<ShutteringState> {
  @override
  ShutteringState build() => ShutteringState.initial();

  void initializeWithPrefill(ShutteringPrefillData data) {
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

  void updateLength(String value) => state = state.copyWith(lengthInput: value, clearFailure: true, hasSaved: false);
  void updateWidth(String value) => state = state.copyWith(widthInput: value, clearFailure: true, hasSaved: false);
  void updateDepth(String value) => state = state.copyWith(depthInput: value, clearFailure: true, hasSaved: false);
  void updateIncludeBottom(bool value) => state = state.copyWith(includeBottom: value, clearFailure: true, hasSaved: false);

  Future<void> calculate() async {
    final l = Validators.parsePositiveNumber(state.lengthInput, 'Length');
    final w = Validators.parsePositiveNumber(state.widthInput, 'Width');
    final d = Validators.parsePositiveNumber(state.depthInput, 'Depth');

    if (l.failure != null) return _onError(l.failure!);
    if (w.failure != null) return _onError(w.failure!);
    if (d.failure != null) return _onError(d.failure!);

    state = state.copyWith(isLoading: true, clearFailure: true, clearResult: true);

    await Future.delayed(const Duration(milliseconds: 300));

    try {
      final service = ref.read(shutteringDesignServiceProvider);
      final input = ShutteringInput(
        length: l.value!,
        width: w.value!,
        depth: d.value!,
        includeBottom: state.includeBottom,
      );

      final res = service.calculateArea(input);

      state = state.copyWith(
        isLoading: false, 
        result: res,
        hasSaved: false,
      );

      await _saveToHistory(res);

    } catch (e, st) {
      AppLogger.error('Calculation failed', error: e, stackTrace: st);
      _onError(AppFailure(e.toString()));
    }
  }

  Future<void> _saveToHistory(ShutteringResult result) async {
    if (state.hasSaved) return;

    final project = ref.read(activeProjectProvider);
    if (project == null) return;

    try {
      final inputParams = {
        'length': state.lengthInput,
        'width': state.widthInput,
        'depth': state.depthInput,
        'includeBottom': state.includeBottom,
      };

      final report = DesignReportMapper.fromShuttering(
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
    state = state.copyWith(
      lengthInput: params['length']?.toString() ?? '',
      widthInput: params['width']?.toString() ?? '',
      depthInput: params['depth']?.toString() ?? '',
      includeBottom: params['includeBottom'] as bool? ?? false,
      clearResult: true,
      clearFailure: true,
      hasSaved: false,
    );
    calculate();
  }

  void _onError(AppFailure f) => state = state.copyWith(isLoading: false, failure: f);
  void reset() => state = ShutteringState.initial();
}


