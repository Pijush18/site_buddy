import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/logging/app_logger.dart';

import 'package:site_buddy/features/calculator/domain/entities/sand_result.dart';
import 'package:site_buddy/features/calculator/domain/usecases/calculate_sand_usecase.dart';
import 'package:site_buddy/shared/application/providers/project_providers.dart';
import 'package:site_buddy/shared/application/mappers/design_report_mapper.dart';
import 'package:site_buddy/shared/application/services/history_saver.dart';

final sandControllerProvider = NotifierProvider<SandController, SandState>(
  SandController.new,
);

class SandState {
  final double? length;
  final double? width;
  final double? depth;
  final double? ratePerCubicMeter;
  final SandResult? result;
  final String? error;
  final bool isLoading;
  final bool hasSaved;

  const SandState({
    this.length,
    this.width,
    this.depth,
    this.ratePerCubicMeter,
    this.result,
    this.error,
    this.isLoading = false,
    this.hasSaved = false,
  });

  SandState copyWith({
    double? length,
    double? width,
    double? depth,
    double? ratePerCubicMeter,
    SandResult? result,
    String? error,
    bool? isLoading,
    bool? hasSaved,
    bool clearResult = false,
    bool clearError = false,
  }) {
    return SandState(
      length: length ?? this.length,
      width: width ?? this.width,
      depth: depth ?? this.depth,
      ratePerCubicMeter: ratePerCubicMeter ?? this.ratePerCubicMeter,
      result: clearResult ? null : (result ?? this.result),
      error: clearError ? null : error,
      isLoading: isLoading ?? this.isLoading,
      hasSaved: hasSaved ?? this.hasSaved,
    );
  }
}

class SandController extends Notifier<SandState> {
  final _useCase = const CalculateSandUseCase();

  @override
  SandState build() => const SandState();

  void updateLength(String value) {
    if (value.isEmpty) {
      state = state.copyWith(length: null, clearResult: true);
      return;
    }
    final v = double.tryParse(value);
    if (v != null) {
      state = state.copyWith(length: v, clearError: true, hasSaved: false);
    }
  }

  void updateWidth(String value) {
    if (value.isEmpty) {
      state = state.copyWith(width: null, clearResult: true);
      return;
    }
    final v = double.tryParse(value);
    if (v != null) {
      state = state.copyWith(width: v, clearError: true, hasSaved: false);
    }
  }

  void updateDepth(String value) {
    if (value.isEmpty) {
      state = state.copyWith(depth: null, clearResult: true);
      return;
    }
    final v = double.tryParse(value);
    if (v != null) {
      state = state.copyWith(depth: v, clearError: true, hasSaved: false);
    }
  }

  void updateRate(String value) {
    if (value.isEmpty) {
      state = state.copyWith(ratePerCubicMeter: null, clearResult: true);
      return;
    }
    final v = double.tryParse(value);
    if (v != null) {
      state = state.copyWith(ratePerCubicMeter: v, clearError: true, hasSaved: false);
    }
  }

  void reset() {
    state = const SandState();
  }

  Future<void> calculate() async {
    final length = state.length;
    final width = state.width;
    final depth = state.depth;

    if (length == null || width == null || depth == null) {
      state = state.copyWith(
        isLoading: false,
        error: 'Please provide length, width and depth.',
        clearResult: true,
      );
      return;
    }

    state = state.copyWith(isLoading: true, clearError: true);

    // Small delay for UX consistency
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      final result = _useCase.execute(
        length: length,
        width: width,
        depth: depth,
        ratePerCubicMeter: state.ratePerCubicMeter,
      );

      state = state.copyWith(
        result: result,
        isLoading: false,
        clearError: true,
        hasSaved: false,
      );

      await _saveToHistory(result);

    } catch (e, st) {
      AppLogger.error('Calculation failed', error: e, stackTrace: st);
      state = state.copyWith(
        isLoading: false,
        error: 'An unexpected error occurred',
        clearResult: true,
      );
    }
  }

  Future<void> _saveToHistory(SandResult result) async {
    if (state.hasSaved) return;

    final project = ref.read(activeProjectProvider);
    if (project == null) return;

    try {
      final inputParams = {
        'length': state.length,
        'width': state.width,
        'depth': state.depth,
        'rate': state.ratePerCubicMeter,
      };

      final report = DesignReportMapper.fromSand(
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
    state = state.copyWith(
      length: (params['length'] as num?)?.toDouble(),
      width: (params['width'] as num?)?.toDouble(),
      depth: (params['depth'] as num?)?.toDouble(),
      ratePerCubicMeter: (params['rate'] as num?)?.toDouble(),
      clearResult: true,
      clearError: true,
      hasSaved: false,
    );
    calculate();
  }
}
