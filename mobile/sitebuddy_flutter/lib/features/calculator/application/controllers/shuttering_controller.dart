import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/calculations/material_estimation_service.dart';
import 'package:site_buddy/core/errors/app_failure.dart';
import 'package:site_buddy/core/utils/validators.dart';
import 'package:site_buddy/features/calculator/application/state/shuttering_state.dart';
import 'package:site_buddy/shared/domain/models/prefill_data.dart';

final shutteringProvider = NotifierProvider<ShutteringController, ShutteringState>(
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

  void updateLength(String value) => state = state.copyWith(lengthInput: value, clearFailure: true);
  void updateWidth(String value) => state = state.copyWith(widthInput: value, clearFailure: true);
  void updateDepth(String value) => state = state.copyWith(depthInput: value, clearFailure: true);
  void updateIncludeBottom(bool value) => state = state.copyWith(includeBottom: value, clearFailure: true);

  Future<void> calculate() async {
    state = state.copyWith(isLoading: true, clearFailure: true, clearResult: true);

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
    } catch (e) {
      _onError(AppFailure(e.toString()));
    }
  }

  void _onError(AppFailure f) => state = state.copyWith(isLoading: false, failure: f);
  void reset() => state = ShutteringState.initial();
}
