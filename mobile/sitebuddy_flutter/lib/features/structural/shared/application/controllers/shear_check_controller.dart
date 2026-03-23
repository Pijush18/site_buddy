import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/features/structural/shared/domain/models/safety_check_models.dart';
import 'package:site_buddy/features/structural/shared/application/services/calculation_service.dart';
import 'package:site_buddy/features/structural/shared/application/controllers/safety_check_controller.dart';

/// STATE: ShearCheckState
/// Holds all state for the shear check screen.
class ShearCheckState {
  final String depth;  // d
  final String width;  // b
  final String shearForce;  // Vu
  final String steelPercentage;  // pt
  final String selectedConcrete;
  final String selectedSteel;
  final ShearResult? result;
  final bool isLoading;
  final String? error;

  const ShearCheckState({
    this.depth = '',
    this.width = '',
    this.shearForce = '',
    this.steelPercentage = '',
    this.selectedConcrete = 'M25',
    this.selectedSteel = 'Fe500',
    this.result,
    this.isLoading = false,
    this.error,
  });

  ShearCheckState copyWith({
    String? depth,
    String? width,
    String? shearForce,
    String? steelPercentage,
    String? selectedConcrete,
    String? selectedSteel,
    ShearResult? result,
    bool? isLoading,
    String? error,
    bool clearResult = false,
  }) {
    return ShearCheckState(
      depth: depth ?? this.depth,
      width: width ?? this.width,
      shearForce: shearForce ?? this.shearForce,
      steelPercentage: steelPercentage ?? this.steelPercentage,
      selectedConcrete: selectedConcrete ?? this.selectedConcrete,
      selectedSteel: selectedSteel ?? this.selectedSteel,
      result: clearResult ? null : (result ?? this.result),
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  /// Returns true if form has valid numeric input
  bool get hasValidInput {
    final d = double.tryParse(depth);
    final b = double.tryParse(width);
    final vu = double.tryParse(shearForce);
    final pt = double.tryParse(steelPercentage);
    return d != null && d > 0 &&
           b != null && b > 0 &&
           vu != null && vu > 0 &&
           pt != null && pt > 0;
  }
}

/// NOTIFIER: ShearCheckNotifier
/// Manages shear check calculation state and business logic.
/// All business logic is centralized here - UI is purely declarative.
class ShearCheckNotifier extends Notifier<ShearCheckState> {
  static const List<String> concreteGrades = ['M20', 'M25', 'M30', 'M35', 'M40'];
  static const List<String> steelGrades = ['Fe415', 'Fe500'];

  @override
  ShearCheckState build() {
    return const ShearCheckState();
  }

  /// Update depth (d) value
  void updateDepth(String value) {
    state = state.copyWith(depth: value);
  }

  /// Update width (b) value
  void updateWidth(String value) {
    state = state.copyWith(width: value);
  }

  /// Update shear force (Vu) value
  void updateShearForce(String value) {
    state = state.copyWith(shearForce: value);
  }

  /// Update steel percentage (pt) value
  void updateSteelPercentage(String value) {
    state = state.copyWith(steelPercentage: value);
  }

  /// Update selected concrete grade
  void updateConcreteGrade(String grade) {
    state = state.copyWith(selectedConcrete: grade);
  }

  /// Update selected steel grade
  void updateSteelGrade(String grade) {
    state = state.copyWith(selectedSteel: grade);
  }

  /// Perform shear check calculation
  /// Business logic is centralized here - not in UI
  Future<void> calculate() async {
    if (!state.hasValidInput) {
      state = state.copyWith(error: 'Please enter valid numeric values for all fields');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      // Artificial delay to simulate calculation (can be removed in production)
      await Future.delayed(const Duration(milliseconds: 500));

      final d = double.parse(state.depth);
      final b = double.parse(state.width);
      final vu = double.parse(state.shearForce);
      final pt = double.parse(state.steelPercentage);

      final result = CalculationService.calculateShear(
        vu: vu,
        b: b,
        d: d,
        pt: pt,
        concreteGrade: state.selectedConcrete,
      );

      // Save to history via safety check controller
      ref.read(safetyCheckControllerProvider.notifier).saveCheck({
        'type': 'Shear',
        'date': DateTime.now().toIso8601String(),
        'isSafe': result.isSafe,
        'tv': result.tv,
        'tc': result.tc,
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
    state = const ShearCheckState();
  }

  /// Share calculation result
  void shareResult() {
    if (state.result == null) return;

    ref.read(safetyCheckControllerProvider.notifier).shareResult(
      title: 'Shear Check Report',
      inputs: {
        'Depth (d)': '${state.depth} mm',
        'Width (b)': '${state.width} mm',
        'Vu': '${state.shearForce} kN',
        'Steel (pt)': '${state.steelPercentage} %',
        'Concrete': state.selectedConcrete,
        'Steel': state.selectedSteel,
      },
      results: {
        'τv': '${state.result!.tv.toStringAsFixed(3)} N/mm²',
        'τc': '${state.result!.tc.toStringAsFixed(3)} N/mm²',
        'Result': state.result!.isSafe ? 'SAFE' : 'UNSAFE',
      },
      isSafe: state.result!.isSafe,
    );
  }
}

/// Provider for ShearCheckNotifier
final shearCheckControllerProvider =
    NotifierProvider<ShearCheckNotifier, ShearCheckState>(
  ShearCheckNotifier.new,
);
