
import 'package:site_buddy/core/errors/app_failure.dart';
import 'package:site_buddy/features/estimation/excavation/domain/excavation_models.dart';

/// STATE: ExcavationState
/// PURPOSE: Standardized state for excavation volume estimation.
class ExcavationState {
  final String lengthInput;
  final String widthInput;
  final String depthInput;
  final String clearanceInput;
  final String swellFactorInput;
  final bool isLoading;
  final AppFailure? failure;
  final ExcavationResult? result;
  final bool hasSaved;

  ExcavationState({
    required this.lengthInput,
    required this.widthInput,
    required this.depthInput,
    required this.clearanceInput,
    required this.swellFactorInput,
    this.isLoading = false,
    this.failure,
    this.result,
    this.hasSaved = false,
  });

  factory ExcavationState.initial() => ExcavationState(
        lengthInput: '',
        widthInput: '',
        depthInput: '',
        clearanceInput: '0.3',
        swellFactorInput: '1.25',
      );

  ExcavationState copyWith({
    String? lengthInput,
    String? widthInput,
    String? depthInput,
    String? clearanceInput,
    String? swellFactorInput,
    bool? isLoading,
    AppFailure? failure,
    ExcavationResult? result,
    bool? hasSaved,
    bool clearFailure = false,
    bool clearResult = false,
  }) {
    return ExcavationState(
      lengthInput: lengthInput ?? this.lengthInput,
      widthInput: widthInput ?? this.widthInput,
      depthInput: depthInput ?? this.depthInput,
      clearanceInput: clearanceInput ?? this.clearanceInput,
      swellFactorInput: swellFactorInput ?? this.swellFactorInput,
      isLoading: isLoading ?? this.isLoading,
      failure: clearFailure ? null : (failure ?? this.failure),
      result: clearResult ? null : (result ?? this.result),
      hasSaved: hasSaved ?? this.hasSaved,
    );
  }
}
