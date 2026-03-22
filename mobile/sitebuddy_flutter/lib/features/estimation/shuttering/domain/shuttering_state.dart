
import 'package:site_buddy/core/errors/app_failure.dart';
import 'package:site_buddy/features/estimation/shuttering/domain/shuttering_models.dart';

/// STATE: ShutteringState
/// PURPOSE: Standardized state for shuttering estimation.
class ShutteringState {
  final String lengthInput;
  final String widthInput;
  final String depthInput;
  final bool includeBottom;
  final bool isLoading;
  final AppFailure? failure;
  final ShutteringResult? result;
  final bool hasSaved;

  ShutteringState({
    required this.lengthInput,
    required this.widthInput,
    required this.depthInput,
    this.includeBottom = false,
    this.isLoading = false,
    this.failure,
    this.result,
    this.hasSaved = false,
  });

  factory ShutteringState.initial() => ShutteringState(
        lengthInput: '',
        widthInput: '',
        depthInput: '',
      );

  ShutteringState copyWith({
    String? lengthInput,
    String? widthInput,
    String? depthInput,
    bool? includeBottom,
    bool? isLoading,
    AppFailure? failure,
    ShutteringResult? result,
    bool? hasSaved,
    bool clearFailure = false,
    bool clearResult = false,
  }) {
    return ShutteringState(
      lengthInput: lengthInput ?? this.lengthInput,
      widthInput: widthInput ?? this.widthInput,
      depthInput: depthInput ?? this.depthInput,
      includeBottom: includeBottom ?? this.includeBottom,
      isLoading: isLoading ?? this.isLoading,
      failure: clearFailure ? null : (failure ?? this.failure),
      result: clearResult ? null : (result ?? this.result),
      hasSaved: hasSaved ?? this.hasSaved,
    );
  }
}
