/// FILE HEADER
/// ----------------------------------------------
/// File: cement_controller.dart
/// Feature: calculator
/// Layer: application/controllers
///
/// PURPOSE:
/// Manages state for the Cement Bag Estimator with Save on Calculate behavior.
///
/// ----------------------------------------------
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/logging/app_logger.dart';

import 'package:site_buddy/features/calculator/domain/entities/cement_result.dart';
import 'package:site_buddy/features/calculator/domain/usecases/calculate_cement_usecase.dart';
import 'package:site_buddy/shared/application/providers/project_providers.dart';
import 'package:site_buddy/shared/application/mappers/design_report_mapper.dart';
import 'package:site_buddy/shared/application/services/history_saver.dart';

class Failure {
  final String message;
  const Failure(this.message);
}

class CementState {
  final double? length;
  final double? width;
  final double? depth;
  final int? mixCement;
  final int? mixSand;
  final int? mixAggregate;
  final double wastePercent;
  final double? pricePerBag;
  final CementResult? result;
  final Failure? failure;
  final bool isLoading;
  final bool hasSaved;

  const CementState({
    this.length,
    this.width,
    this.depth,
    this.mixCement,
    this.mixSand,
    this.mixAggregate,
    this.wastePercent = 5,
    this.pricePerBag,
    this.result,
    this.failure,
    this.isLoading = false,
    this.hasSaved = false,
  });

  CementState copyWith({
    double? length,
    double? width,
    double? depth,
    int? mixCement,
    int? mixSand,
    int? mixAggregate,
    double? wastePercent,
    double? pricePerBag,
    CementResult? result,
    Failure? failure,
    bool? isLoading,
    bool? hasSaved,
    bool clearResult = false,
    bool clearFailure = false,
  }) {
    return CementState(
      length: length ?? this.length,
      width: width ?? this.width,
      depth: depth ?? this.depth,
      mixCement: mixCement ?? this.mixCement,
      mixSand: mixSand ?? this.mixSand,
      mixAggregate: mixAggregate ?? this.mixAggregate,
      wastePercent: wastePercent ?? this.wastePercent,
      pricePerBag: pricePerBag ?? this.pricePerBag,
      result: clearResult ? null : (result ?? this.result),
      failure: clearFailure ? null : (failure ?? this.failure),
      isLoading: isLoading ?? this.isLoading,
      hasSaved: hasSaved ?? this.hasSaved,
    );
  }
}

final cementControllerProvider =
    NotifierProvider<CementController, CementState>(CementController.new);

class CementController extends Notifier<CementState> {
  final _useCase = const CalculateCementUseCase();

  @override
  CementState build() {
    return const CementState();
  }

  void updateLength(String value) {
    if (value.isEmpty) {
      state = state.copyWith(length: null, clearResult: true, hasSaved: false);
      return;
    }
    final v = double.tryParse(value);
    if (v != null) {
      state = state.copyWith(length: v, clearFailure: true, hasSaved: false);
    }
  }

  void updateWidth(String value) {
    if (value.isEmpty) {
      state = state.copyWith(width: null, clearResult: true, hasSaved: false);
      return;
    }
    final v = double.tryParse(value);
    if (v != null) {
      state = state.copyWith(width: v, clearFailure: true, hasSaved: false);
    }
  }

  void updateDepth(String value) {
    if (value.isEmpty) {
      state = state.copyWith(depth: null, clearResult: true, hasSaved: false);
      return;
    }
    final v = double.tryParse(value);
    if (v != null) {
      state = state.copyWith(depth: v, clearFailure: true, hasSaved: false);
    }
  }

  void updateMixCement(String value) {
    final v = int.tryParse(value);
    if (v != null) {
      state = state.copyWith(mixCement: v, clearFailure: true, hasSaved: false);
    }
  }

  void updateMixSand(String value) {
    final v = int.tryParse(value);
    if (v != null) {
      state = state.copyWith(mixSand: v, clearFailure: true, hasSaved: false);
    }
  }

  void updateMixAggregate(String value) {
    final v = int.tryParse(value);
    if (v != null) {
      state = state.copyWith(mixAggregate: v, clearFailure: true, hasSaved: false);
    }
  }

  void updateWaste(String value) {
    final v = double.tryParse(value);
    if (v != null) {
      state = state.copyWith(wastePercent: v, clearFailure: true, hasSaved: false);
    }
  }

  void updatePrice(String value) {
    final v = double.tryParse(value);
    state = state.copyWith(pricePerBag: v, hasSaved: false);
  }

  void reset() {
    state = const CementState();
  }

  void restore(Map<String, dynamic> params) {
    state = state.copyWith(
      length: params['length'] as double?,
      width: params['width'] as double?,
      depth: params['depth'] as double?,
      wastePercent: params['waste'] as double?,
      clearResult: true,
      clearFailure: true,
      hasSaved: false,
    );

    final mixString = params['mix'] as String?;
    if (mixString != null) {
      final parts = mixString.split(':');
      if (parts.length == 3) {
        state = state.copyWith(
          mixCement: int.tryParse(parts[0]),
          mixSand: int.tryParse(parts[1]),
          mixAggregate: int.tryParse(parts[2]),
        );
      }
    }
    calculate();
  }

  Future<void> calculate() async {
    final length = state.length;
    final width = state.width;
    final depth = state.depth;
    final mixCement = state.mixCement ?? 1;
    final mixSand = state.mixSand ?? 0;
    final mixAggregate = state.mixAggregate ?? 0;
    final waste = state.wastePercent;
    final price = state.pricePerBag;

    if (length == null || width == null || depth == null) {
      state = state.copyWith(
        failure: const Failure('Length, width and depth are required.'),
        clearResult: true,
      );
      return;
    }

    state = state.copyWith(isLoading: true, clearFailure: true);

    try {
      final res = _useCase.execute(
        length: length,
        width: width,
        depth: depth,
        mixCement: mixCement,
        mixSand: mixSand,
        mixAggregate: mixAggregate,
        wastePercent: waste,
        pricePerBag: price ?? 0,
      );

      state = state.copyWith(
        result: res, 
        isLoading: false,
        hasSaved: false,
      );

      await _saveToHistory(res);

    } catch (e, st) {
      AppLogger.error('Calculation failed', error: e, stackTrace: st);
      state = state.copyWith(
        isLoading: false,
        failure: Failure(e.toString().replaceAll('Exception: ', '')),
      );
    }
  }

  Future<void> _saveToHistory(CementResult result) async {
    if (state.hasSaved) return;

    final project = ref.read(activeProjectProvider);
    if (project == null) return;

    try {
      final inputParams = {
        'length': state.length,
        'width': state.width,
        'depth': state.depth,
        'mix': '${state.mixCement}:${state.mixSand}:${state.mixAggregate}',
        'waste': state.wastePercent,
      };

      final report = DesignReportMapper.fromCement(
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
}
