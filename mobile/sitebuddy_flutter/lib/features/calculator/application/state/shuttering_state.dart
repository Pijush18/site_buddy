import 'package:site_buddy/shared/domain/models/shuttering_result.dart';
import 'package:site_buddy/core/errors/app_failure.dart';

class ShutteringState {
  final String lengthInput;
  final String widthInput;
  final String depthInput;
  final bool includeBottom;
  final ShutteringResult? result;
  final AppFailure? failure;
  final bool isLoading;

  const ShutteringState({
    this.lengthInput = '',
    this.widthInput = '',
    this.depthInput = '',
    this.includeBottom = false,
    this.result,
    this.failure,
    this.isLoading = false,
  });

  ShutteringState copyWith({
    String? lengthInput,
    String? widthInput,
    String? depthInput,
    bool? includeBottom,
    ShutteringResult? result,
    AppFailure? failure,
    bool? isLoading,
    bool clearResult = false,
    bool clearFailure = false,
  }) {
    return ShutteringState(
      lengthInput: lengthInput ?? this.lengthInput,
      widthInput: widthInput ?? this.widthInput,
      depthInput: depthInput ?? this.depthInput,
      includeBottom: includeBottom ?? this.includeBottom,
      result: clearResult ? null : (result ?? this.result),
      failure: clearFailure ? null : (failure ?? this.failure),
      isLoading: isLoading ?? this.isLoading,
    );
  }

  factory ShutteringState.initial() => const ShutteringState();
}



