import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/features/structural/shared/domain/models/safety_check_models.dart';
import 'package:site_buddy/features/structural/shared/application/services/calculation_service.dart';
import 'package:site_buddy/features/structural/shared/application/controllers/safety_check_controller.dart';

/// STATE: DeflectionCheckState
/// Holds all state for the deflection check screen.
class DeflectionCheckState {
  final String depth;  // d
  final String span;  // L
  final String pt;  // reinforcement percentage
  final String pc;  // compression steel percentage
  final String selectedSpanType;
  final DeflectionResult? result;
  final bool isLoading;
  final String? error;

  const DeflectionCheckState({
    this.depth = '',
    this.span = '',
    this.pt = '',
    this.pc = '',
    this.selectedSpanType = 'Simply Supported',
    this.result,
    this.isLoading = false,
    this.error,
  });

  DeflectionCheckState copyWith({
    String? depth,
    String? span,
    String? pt,
    String? pc,
    String? selectedSpanType,
    DeflectionResult? result,
    bool? isLoading,
    String? error,
    bool clearResult = false,
  }) {
    return DeflectionCheckState(
      depth: depth ?? this.depth,
      span: span ?? this.span,
      pt: pt ?? this.pt,
      pc: pc ?? this.pc,
      selectedSpanType: selectedSpanType ?? this.selectedSpanType,
      result: clearResult ? null : (result ?? this.result),
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  /// Returns true if form has valid numeric input
  bool get hasValidInput {
    final d = double.tryParse(depth);
    final l = double.tryParse(span);
    return d != null && d > 0 && l != null && l > 0;
  }
}

/// NOTIFIER: DeflectionCheckNotifier
/// Manages deflection check calculation state and business logic.
/// All business logic is centralized here - UI is purely declarative.
class DeflectionCheckNotifier extends Notifier<DeflectionCheckState> {
  static const List<String> spanTypes = ['Simply Supported', 'Continuous', 'Cantilever'];

  @override
  DeflectionCheckState build() {
    return const DeflectionCheckState();
  }

  /// Update depth (d) value
  void updateDepth(String value) {
    state = state.copyWith(depth: value);
  }

  /// Update span (L) value
  void updateSpan(String value) {
    state = state.copyWith(span: value);
  }

  /// Update tension steel percentage (pt)
  void updatePt(String value) {
    state = state.copyWith(pt: value);
  }

  /// Update compression steel percentage (pc)
  void updatePc(String value) {
    state = state.copyWith(pc: value);
  }

  /// Update span type
  void updateSpanType(String type) {
    state = state.copyWith(selectedSpanType: type);
  }

  /// Perform deflection check calculation
  /// Business logic is centralized here - not in UI
  Future<void> calculate() async {
    if (!state.hasValidInput) {
      state = state.copyWith(error: 'Please enter valid values for depth and span');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      // Artificial delay to simulate calculation (can be removed in production)
      await Future.delayed(const Duration(milliseconds: 500));

      final d = double.parse(state.depth);
      final span = double.parse(state.span);

      final result = CalculationService.calculateDeflection(
        span: span,
        d: d,
        isContinuous: state.selectedSpanType == 'Continuous',
      );

      // Save to history via safety check controller
      ref.read(safetyCheckControllerProvider.notifier).saveCheck({
        'type': 'Deflection',
        'date': DateTime.now().toIso8601String(),
        'isSafe': result.isSafe,
        'actual': result.actualRatio,
        'allowable': result.allowableRatio,
      });

      state = state.copyWith(result: result, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Calculation failed: ${e.toString()}',
      );
    }
  }

  /// Reset form to initial state
  void reset() {
    state = const DeflectionCheckState();
  }

  /// Share calculation result
  void shareResult() {
    if (state.result == null) return;

    ref.read(safetyCheckControllerProvider.notifier).shareResult(
      title: 'Deflection Check Report',
      inputs: {
        'Depth (d)': '${state.depth} mm',
        'Span (L)': '${state.span} mm',
        'Type': state.selectedSpanType,
        if (state.pt.isNotEmpty) 'Pt': '${state.pt} %',
        if (state.pc.isNotEmpty) 'Pc': '${state.pc} %',
      },
      results: {
        'Actual L/d': state.result!.actualRatio.toStringAsFixed(2),
        'Allowable L/d': state.result!.allowableRatio.toStringAsFixed(2),
        'Result': state.result!.isSafe ? 'SAFE' : 'UNSAFE',
      },
      isSafe: state.result!.isSafe,
    );
  }
}

/// Provider for DeflectionCheckNotifier
final deflectionCheckControllerProvider =
    NotifierProvider<DeflectionCheckNotifier, DeflectionCheckState>(
  DeflectionCheckNotifier.new,
);
