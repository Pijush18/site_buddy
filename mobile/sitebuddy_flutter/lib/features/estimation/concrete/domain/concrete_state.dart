
import 'package:site_buddy/core/engineering/models/concrete_grade.dart';
import 'package:site_buddy/core/errors/app_failure.dart';
import 'package:site_buddy/features/estimation/concrete/domain/concrete_models.dart';

/// STATE: CalculatorState
/// PURPOSE: Standardized state for concrete material estimation.
class CalculatorState {
  final String lengthInput;
  final String widthInput;
  final String depthInput;
  final ConcreteGrade grade;
  final String steelRatioInput;
  final String wasteFactorInput;
  final bool isLoading;
  final AppFailure? failure;
  final ConcreteMaterialResult? concreteResult;

  CalculatorState({
    required this.lengthInput,
    required this.widthInput,
    required this.depthInput,
    required this.grade,
    required this.steelRatioInput,
    required this.wasteFactorInput,
    this.isLoading = false,
    this.failure,
    this.concreteResult,
  });

  factory CalculatorState.initial() => CalculatorState(
        lengthInput: '',
        widthInput: '',
        depthInput: '',
        grade: ConcreteGrade.m20,
        steelRatioInput: '0',
        wasteFactorInput: '0',
      );

  CalculatorState copyWith({
    String? lengthInput,
    String? widthInput,
    String? depthInput,
    ConcreteGrade? grade,
    String? steelRatioInput,
    String? wasteFactorInput,
    bool? isLoading,
    AppFailure? failure,
    ConcreteMaterialResult? concreteResult,
    bool clearFailure = false,
    bool clearResult = false,
  }) {
    return CalculatorState(
      lengthInput: lengthInput ?? this.lengthInput,
      widthInput: widthInput ?? this.widthInput,
      depthInput: depthInput ?? this.depthInput,
      grade: grade ?? this.grade,
      steelRatioInput: steelRatioInput ?? this.steelRatioInput,
      wasteFactorInput: wasteFactorInput ?? this.wasteFactorInput,
      isLoading: isLoading ?? this.isLoading,
      failure: clearFailure ? null : (failure ?? this.failure),
      concreteResult: clearResult ? null : (concreteResult ?? this.concreteResult),
    );
  }
}
