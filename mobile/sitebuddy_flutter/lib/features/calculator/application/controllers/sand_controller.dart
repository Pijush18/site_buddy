import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'package:site_buddy/features/calculator/domain/entities/sand_result.dart';
import 'package:site_buddy/features/calculator/domain/usecases/calculate_sand_usecase.dart';
import 'package:site_buddy/shared/domain/models/calculation_history_entry.dart';
import 'package:site_buddy/shared/presentation/providers/history_providers.dart';
import 'package:site_buddy/features/project/application/controllers/project_controller.dart';

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

  const SandState({
    this.length,
    this.width,
    this.depth,
    this.ratePerCubicMeter,
    this.result,
    this.error,
    this.isLoading = false,
  });

  SandState copyWith({
    double? length,
    double? width,
    double? depth,
    double? ratePerCubicMeter,
    SandResult? result,
    String? error,
    bool? isLoading,
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
      state = state.copyWith(length: v, clearError: true);
    }
  }

  void updateWidth(String value) {
    if (value.isEmpty) {
      state = state.copyWith(width: null, clearResult: true);
      return;
    }
    final v = double.tryParse(value);
    if (v != null) {
      state = state.copyWith(width: v, clearError: true);
    }
  }

  void updateDepth(String value) {
    if (value.isEmpty) {
      state = state.copyWith(depth: null, clearResult: true);
      return;
    }
    final v = double.tryParse(value);
    if (v != null) {
      state = state.copyWith(depth: v, clearError: true);
    }
  }

  void updateRate(String value) {
    if (value.isEmpty) {
      state = state.copyWith(ratePerCubicMeter: null, clearResult: true);
      return;
    }
    final v = double.tryParse(value);
    if (v != null) {
      state = state.copyWith(ratePerCubicMeter: v, clearError: true);
    }
  }

  void reset() {
    state = const SandState();
  }

  Future<void> calculate() async {
    state = state.copyWith(isLoading: true, clearError: true);

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
      );

      // --- PERSISTENCE: Save to Unified Calculation Repository ---
      final selectedProject = ref.read(projectControllerProvider).selectedProject;
      if (selectedProject != null) {
        final entry = CalculationHistoryEntry(
          id: const Uuid().v4(),
          projectId: selectedProject.id,
          calculationType: CalculationType.sand,
          timestamp: DateTime.now(),
          inputParameters: {
            'length': length,
            'width': width,
            'depth': depth,
            'rate': state.ratePerCubicMeter,
          },
          resultSummary: '${result.dryVolume.toStringAsFixed(1)} m³ Sand Estimated',
          resultData: result.toMap(),
        );
        ref.read(sharedHistoryRepositoryProvider).addEntry(entry);
      }
    } on ArgumentError catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.message ?? 'Invalid input',
        clearResult: true,
      );
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        error: 'An unexpected error occurred',
        clearResult: true,
      );
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
    );
    calculate();
  }
}



