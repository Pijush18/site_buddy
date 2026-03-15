import 'package:site_buddy/shared/domain/models/excavation_result.dart';
import 'package:site_buddy/core/errors/app_failure.dart';

class ExcavationState {
  final String lengthInput;
  final String widthInput;
  final String depthInput;
  final String clearanceInput;
  final String swellFactorInput;
  final ExcavationResult? result;
  final AppFailure? failure;
  final bool isLoading;

  const ExcavationState({
    this.lengthInput = '',
    this.widthInput = '',
    this.depthInput = '',
    this.clearanceInput = '0.3',
    this.swellFactorInput = '1.25',
    this.result,
    this.failure,
    this.isLoading = false,
  });

  ExcavationState copyWith({
    String? lengthInput,
    String? widthInput,
    String? depthInput,
    String? clearanceInput,
    String? swellFactorInput,
    ExcavationResult? result,
    AppFailure? failure,
    bool? isLoading,
    bool clearResult = false,
    bool clearFailure = false,
  }) {
    return ExcavationState(
      lengthInput: lengthInput ?? this.lengthInput,
      widthInput: widthInput ?? this.widthInput,
      depthInput: depthInput ?? this.depthInput,
      clearanceInput: clearanceInput ?? this.clearanceInput,
      swellFactorInput: swellFactorInput ?? this.swellFactorInput,
      result: clearResult ? null : (result ?? this.result),
      failure: clearFailure ? null : (failure ?? this.failure),
      isLoading: isLoading ?? this.isLoading,
    );
  }

  factory ExcavationState.initial() => const ExcavationState();
}
