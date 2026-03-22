
import 'package:site_buddy/core/engineering/models/plaster_ratio.dart';
import 'package:site_buddy/core/errors/app_failure.dart';
import 'package:site_buddy/features/estimation/plaster/domain/plaster_models.dart';

/// STATE: PlasterState
/// PURPOSE: Standardized state for plaster material estimation.
class PlasterState {
  final String areaInput;
  final String thicknessInput;
  final PlasterRatio selectedRatio;
  final bool isLoading;
  final AppFailure? failure;
  final PlasterMaterialResult? result;
  final bool hasSaved;

  PlasterState({
    required this.areaInput,
    required this.thicknessInput,
    required this.selectedRatio,
    this.isLoading = false,
    this.failure,
    this.result,
    this.hasSaved = false,
  });

  factory PlasterState.initial() => PlasterState(
        areaInput: '',
        thicknessInput: '',
        selectedRatio: PlasterRatio.oneToFour,
      );

  PlasterState copyWith({
    String? areaInput,
    String? thicknessInput,
    PlasterRatio? selectedRatio,
    bool? isLoading,
    AppFailure? failure,
    PlasterMaterialResult? result,
    bool? hasSaved,
    bool clearFailure = false,
    bool clearResult = false,
  }) {
    return PlasterState(
      areaInput: areaInput ?? this.areaInput,
      thicknessInput: thicknessInput ?? this.thicknessInput,
      selectedRatio: selectedRatio ?? this.selectedRatio,
      isLoading: isLoading ?? this.isLoading,
      failure: clearFailure ? null : (failure ?? this.failure),
      result: clearResult ? null : (result ?? this.result),
      hasSaved: hasSaved ?? this.hasSaved,
    );
  }
}
