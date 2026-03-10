/// FILE HEADER
/// ----------------------------------------------
/// File: level_controller.dart
/// Feature: calculator
/// Layer: application/controllers
///
/// PURPOSE:
/// Riverpod notifier managing state for the Level Calculator screen.
///
/// RESPONSIBILITIES:
/// - Store user inputs for start and end levels.
/// - Trigger calculation via [CalculateLevelUseCase].
/// - Manage loading state and failures.
///
/// DEPENDENCIES:
/// - Riverpod NotifierProvider
/// - Domain use case [CalculateLevelUseCase]
/// - Domain entity [LevelResult]
///
/// FUTURE IMPROVEMENTS:
/// - Persist last calculation
/// - Add input formatting/validation helpers
/// ----------------------------------------------
library;


import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/features/calculator/domain/entities/level_result.dart';
import 'package:site_buddy/features/calculator/domain/usecases/calculate_level_usecase.dart';

/// Failure model used across calculator controllers.
class Failure {
  final String message;
  const Failure(this.message);
}

/// State container for level calculations.
class LevelState {
  final double? startLevel;
  final double? endLevel;
  final LevelResult? result;
  final bool isLoading;
  final Failure? failure;

  const LevelState({
    this.startLevel,
    this.endLevel,
    this.result,
    this.isLoading = false,
    this.failure,
  });

  LevelState copyWith({
    double? startLevel,
    double? endLevel,
    LevelResult? result,
    bool? isLoading,
    Failure? failure,
    bool clearFailure = false,
    bool clearResult = false,
  }) {
    return LevelState(
      startLevel: startLevel ?? this.startLevel,
      endLevel: endLevel ?? this.endLevel,
      result: clearResult ? null : (result ?? this.result),
      isLoading: isLoading ?? this.isLoading,
      failure: clearFailure ? null : (failure ?? this.failure),
    );
  }
}

/// Riverpod provider exposing [LevelController].
final levelControllerProvider = NotifierProvider<LevelController, LevelState>(
  LevelController.new,
);

/// Controller implementing business orchestration for level computations.
class LevelController extends Notifier<LevelState> {
  final _useCase = const CalculateLevelUseCase();

  @override
  LevelState build() {
    return const LevelState();
  }

  void updateStartLevel(String value) {
    if (value.isEmpty) {
      state = state.copyWith(startLevel: null, clearResult: true);
      return;
    }
    final v = double.tryParse(value);
    if (v != null) {
      state = state.copyWith(startLevel: v, clearFailure: true);
    }
  }

  void updateEndLevel(String value) {
    if (value.isEmpty) {
      state = state.copyWith(endLevel: null, clearResult: true);
      return;
    }
    final v = double.tryParse(value);
    if (v != null) {
      state = state.copyWith(endLevel: v, clearFailure: true);
    }
  }

  Future<void> calculate() async {
    final start = state.startLevel;
    final end = state.endLevel;

    if (start == null || end == null) {
      state = state.copyWith(
        failure: const Failure('Both levels must be provided.'),
        clearResult: true,
      );
      return;
    }

    state = state.copyWith(isLoading: true, clearFailure: true);

    try {
      final res = _useCase.execute(startLevel: start, endLevel: end);
      state = state.copyWith(result: res, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        failure: Failure(e.toString().replaceAll('Exception: ', '')),
      );
    }
  }
}
