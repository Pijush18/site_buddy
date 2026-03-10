/// FILE HEADER
/// ----------------------------------------------
/// File: rebar_controller.dart
/// Feature: calculator
/// Layer: application/controllers
///
/// PURPOSE:
/// Manages state for the Rebar Length Estimator screen using Riverpod.
///
/// RESPONSIBILITIES:
/// - Store input fields (memberLength, spacing, diameter, wastePercent).
/// - Invoke [CalculateRebarUseCase] on calculate requests.
/// - Handle validation errors and update state.
///
/// DEPENDENCIES:
/// - Riverpod NotifierProvider
/// - Domain use case [CalculateRebarUseCase]
/// - Domain entity [RebarResult]
///
/// FUTURE IMPROVEMENTS:
/// - Persist previous estimations
/// ----------------------------------------------
library;


import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/features/calculator/domain/entities/rebar_result.dart';
import 'package:site_buddy/features/calculator/domain/usecases/calculate_rebar_usecase.dart';

/// Failure wrapper used by calculator controllers.
class Failure {
  final String message;
  const Failure(this.message);
}

/// State for the rebar estimator.
class RebarState {
  final double? memberLength;
  final double? spacing;
  final double? diameter;
  final double wastePercent;
  final RebarResult? result;
  final Failure? failure;
  final bool isLoading;

  const RebarState({
    this.memberLength,
    this.spacing,
    this.diameter,
    this.wastePercent = 5,
    this.result,
    this.failure,
    this.isLoading = false,
  });

  RebarState copyWith({
    double? memberLength,
    double? spacing,
    double? diameter,
    double? wastePercent,
    RebarResult? result,
    Failure? failure,
    bool? isLoading,
    bool clearResult = false,
    bool clearFailure = false,
  }) {
    return RebarState(
      memberLength: memberLength ?? this.memberLength,
      spacing: spacing ?? this.spacing,
      diameter: diameter ?? this.diameter,
      wastePercent: wastePercent ?? this.wastePercent,
      result: clearResult ? null : (result ?? this.result),
      failure: clearFailure ? null : (failure ?? this.failure),
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Provider for rebar controller.
final rebarControllerProvider = NotifierProvider<RebarController, RebarState>(
  RebarController.new,
);

class RebarController extends Notifier<RebarState> {
  final _useCase = const CalculateRebarUseCase();

  @override
  RebarState build() {
    return const RebarState();
  }

  void updateMemberLength(String value) {
    if (value.isEmpty) {
      state = state.copyWith(memberLength: null, clearResult: true);
      return;
    }
    final v = double.tryParse(value);
    if (v != null) {
      state = state.copyWith(memberLength: v, clearFailure: true);
    }
  }

  void updateSpacing(String value) {
    if (value.isEmpty) {
      state = state.copyWith(spacing: null, clearResult: true);
      return;
    }
    final v = double.tryParse(value);
    if (v != null) {
      state = state.copyWith(spacing: v, clearFailure: true);
    }
  }

  void updateDiameter(String value) {
    if (value.isEmpty) {
      state = state.copyWith(diameter: null, clearResult: true);
      return;
    }
    final v = double.tryParse(value);
    if (v != null) {
      state = state.copyWith(diameter: v, clearFailure: true);
    }
  }

  void updateWaste(String value) {
    final v = double.tryParse(value);
    if (v != null) {
      state = state.copyWith(wastePercent: v, clearFailure: true);
    }
  }

  Future<void> calculate() async {
    final memberLength = state.memberLength;
    final spacing = state.spacing;
    final diameter = state.diameter;
    final waste = state.wastePercent;

    if (memberLength == null || spacing == null || diameter == null) {
      state = state.copyWith(
        failure: const Failure('All fields except waste must be filled.'),
        clearResult: true,
      );
      return;
    }

    state = state.copyWith(isLoading: true, clearFailure: true);

    try {
      final res = _useCase.execute(
        memberLength: memberLength,
        spacing: spacing,
        diameter: diameter,
        wastePercent: waste,
      );
      state = state.copyWith(result: res, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        failure: Failure(e.toString().replaceAll('Exception: ', '')),
      );
    }
  }
}
