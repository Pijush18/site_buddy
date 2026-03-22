/// FILE HEADER
/// ----------------------------------------------
/// File: cement_controller.dart
/// Feature: calculator
/// Layer: application/controllers
///
/// PURPOSE:
/// Manages state for the Cement Bag Estimator.
///
/// RESPONSIBILITIES:
/// - Store dimension inputs, mix ratio, waste, price
/// - Invoke CalculateCementUseCase
/// - Handle validation and errors
///
/// ----------------------------------------------
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'package:site_buddy/features/calculator/domain/entities/cement_result.dart';
import 'package:site_buddy/features/calculator/domain/usecases/calculate_cement_usecase.dart';
import 'package:site_buddy/shared/domain/models/calculation_history_entry.dart';
import 'package:site_buddy/shared/application/providers/project_providers.dart';
import 'package:site_buddy/shared/application/mappers/design_report_mapper.dart';
import 'package:site_buddy/shared/presentation/providers/history_providers.dart';
import 'package:site_buddy/core/logging/app_logger.dart';

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
      state = state.copyWith(length: null, clearResult: true);
      return;
    }
    final v = double.tryParse(value);
    if (v != null) {
      state = state.copyWith(length: v, clearFailure: true);
    }
  }

  void updateWidth(String value) {
    if (value.isEmpty) {
      state = state.copyWith(width: null, clearResult: true);
      return;
    }
    final v = double.tryParse(value);
    if (v != null) {
      state = state.copyWith(width: v, clearFailure: true);
    }
  }

  void updateDepth(String value) {
    if (value.isEmpty) {
      state = state.copyWith(depth: null, clearResult: true);
      return;
    }
    final v = double.tryParse(value);
    if (v != null) {
      state = state.copyWith(depth: v, clearFailure: true);
    }
  }

  void updateMixCement(String value) {
    final v = int.tryParse(value);
    if (v != null) {
      state = state.copyWith(mixCement: v, clearFailure: true);
    }
  }

  void updateMixSand(String value) {
    final v = int.tryParse(value);
    if (v != null) {
      state = state.copyWith(mixSand: v, clearFailure: true);
    }
  }

  void updateMixAggregate(String value) {
    final v = int.tryParse(value);
    if (v != null) {
      state = state.copyWith(mixAggregate: v, clearFailure: true);
    }
  }

  void updateWaste(String value) {
    final v = double.tryParse(value);
    if (v != null) {
      state = state.copyWith(wastePercent: v, clearFailure: true);
    }
  }

  void updatePrice(String value) {
    final v = double.tryParse(value);
    state = state.copyWith(pricePerBag: v);
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
      state = state.copyWith(result: res, isLoading: false);

      // --- PERSISTENCE: Save to Unified Calculation Repository ---
      final projectId = ref
          .read(projectSessionServiceProvider)
          .getActiveProjectId();

      // Validate projectId before saving - skip if no active project
      if (projectId.isEmpty) {
        AppLogger.warning(
          'No active project selected, skipping cement calculation save',
          tag: 'CementController',
        );
      } else {
        final entry = CalculationHistoryEntry(
          id: const Uuid().v4(),
          projectId: projectId,
          calculationType: CalculationType.cement,
          timestamp: DateTime.now(),
          inputParameters: {
            'length': length,
            'width': width,
            'depth': depth,
            'mix': '$mixCement:$mixSand:$mixAggregate',
            'waste': waste,
          },
          resultSummary:
              '${res.numberOfBags.toStringAsFixed(1)} Bags Estimated',
          resultData: res.toMap(),
        );

        await ref.read(sharedHistoryRepositoryProvider).addEntry(entry);

        // --- SYNC: Save to Unified Design Report System ---
        final report = DesignReportMapper.fromCement(
          res.toMap(),
          entry.inputParameters,
          projectId,
        );
        await ref.read(historyRepositoryProvider).save(report);
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        failure: Failure(e.toString().replaceAll('Exception: ', '')),
      );
    }
  }
}
