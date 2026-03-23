import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/features/structural/shared/domain/models/safety_check_models.dart';
import 'package:site_buddy/features/structural/shared/application/services/calculation_service.dart';
import 'package:site_buddy/features/structural/shared/application/controllers/safety_check_controller.dart';

/// STATE: CrackingCheckState
/// Holds all state for the cracking check screen.
class CrackingCheckState {
  final String spacing;
  final String cover;
  final String fs;
  final String selectedConcrete;
  final String selectedSteel;
  final CrackingResult? result;
  final bool isLoading;
  final String? error;

  const CrackingCheckState({
    this.spacing = '',
    this.cover = '',
    this.fs = '',
    this.selectedConcrete = 'M25',
    this.selectedSteel = 'Fe500',
    this.result,
    this.isLoading = false,
    this.error,
  });

  CrackingCheckState copyWith({
    String? spacing,
    String? cover,
    String? fs,
    String? selectedConcrete,
    String? selectedSteel,
    CrackingResult? result,
    bool? isLoading,
    String? error,
    bool clearResult = false,
  }) {
    return CrackingCheckState(
      spacing: spacing ?? this.spacing,
      cover: cover ?? this.cover,
      fs: fs ?? this.fs,
      selectedConcrete: selectedConcrete ?? this.selectedConcrete,
      selectedSteel: selectedSteel ?? this.selectedSteel,
      result: clearResult ? null : (result ?? this.result),
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  /// Returns true if form has valid numeric input
  bool get hasValidInput {
    final spacingVal = double.tryParse(spacing);
    final coverVal = double.tryParse(cover);
    final fsVal = double.tryParse(fs);
    return spacingVal != null && spacingVal > 0 &&
           coverVal != null && coverVal > 0 &&
           fsVal != null && fsVal > 0;
  }
}

/// NOTIFIER: CrackingCheckNotifier
/// Manages cracking check calculation state and business logic.
/// All business logic is centralized here - UI is purely declarative.
class CrackingCheckNotifier extends Notifier<CrackingCheckState> {
  static const List<String> concreteGrades = ['M20', 'M25', 'M30', 'M35', 'M40'];
  static const List<String> steelGrades = ['Fe415', 'Fe500'];

  @override
  CrackingCheckState build() {
    return const CrackingCheckState();
  }

  /// Update spacing value
  void updateSpacing(String value) {
    state = state.copyWith(spacing: value);
  }

  /// Update cover value
  void updateCover(String value) {
    state = state.copyWith(cover: value);
  }

  /// Update stress (fs) value
  void updateFs(String value) {
    state = state.copyWith(fs: value);
  }

  /// Update selected concrete grade
  void updateConcreteGrade(String grade) {
    state = state.copyWith(selectedConcrete: grade);
  }

  /// Update selected steel grade
  void updateSteelGrade(String grade) {
    state = state.copyWith(selectedSteel: grade);
  }

  /// Perform cracking check calculation
  /// Business logic is centralized here - not in UI
  Future<void> calculate() async {
    if (!state.hasValidInput) {
      state = state.copyWith(error: 'Please enter valid numeric values');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      // Artificial delay to simulate calculation (can be removed in production)
      await Future.delayed(const Duration(milliseconds: 500));

      final spacing = double.parse(state.spacing);
      final cover = double.parse(state.cover);
      final fs = double.parse(state.fs);

      final result = CalculationService.calculateCracking(
        spacing: spacing,
        fs: fs,
        cover: cover,
      );

      // Save to history via safety check controller
      ref.read(safetyCheckControllerProvider.notifier).saveCheck({
        'type': 'Cracking',
        'date': DateTime.now().toIso8601String(),
        'isSafe': result.isSafe,
        'crackWidth': result.crackWidth,
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
    state = const CrackingCheckState();
  }

  /// Share calculation result
  void shareResult() {
    if (state.result == null) return;

    ref.read(safetyCheckControllerProvider.notifier).shareResult(
      title: 'Cracking Check Report',
      inputs: {
        'Spacing': '${state.spacing} mm',
        'Cover': '${state.cover} mm',
        'Stress (fs)': '${state.fs} MPa',
        'Concrete': state.selectedConcrete,
        'Steel': state.selectedSteel,
      },
      results: {
        'Crack Width': '${state.result!.crackWidth.toStringAsFixed(3)} mm',
        'Limit': '0.3 mm',
        'Result': state.result!.isSafe ? 'SAFE' : 'UNSAFE',
      },
      isSafe: state.result!.isSafe,
    );
  }
}

/// Provider for CrackingCheckNotifier
final crackingCheckControllerProvider =
    NotifierProvider<CrackingCheckNotifier, CrackingCheckState>(
  CrackingCheckNotifier.new,
);
