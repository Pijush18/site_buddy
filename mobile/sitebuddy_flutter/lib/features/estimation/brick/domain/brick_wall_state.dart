
import 'package:site_buddy/core/engineering/models/mortar_ratio.dart';
import 'package:site_buddy/core/errors/app_failure.dart';
import 'package:site_buddy/features/estimation/brick/domain/brick_models.dart';

/// STATE: BrickWallState
/// PURPOSE: Standardized state for brick masonry estimation.
class BrickWallState {
  final String lengthInput;
  final String heightInput;
  final String thicknessInput;
  final MortarRatio selectedRatio;
  final bool isLoading;
  final AppFailure? failure;
  final BrickWallResult? result;
  final bool hasSaved;

  BrickWallState({
    required this.lengthInput,
    required this.heightInput,
    required this.thicknessInput,
    required this.selectedRatio,
    this.isLoading = false,
    this.failure,
    this.result,
    this.hasSaved = false,
  });

  factory BrickWallState.initial() => BrickWallState(
        lengthInput: '',
        heightInput: '',
        thicknessInput: '230',
        selectedRatio: MortarRatio.oneToSix,
      );

  BrickWallState copyWith({
    String? lengthInput,
    String? heightInput,
    String? thicknessInput,
    MortarRatio? selectedRatio,
    bool? isLoading,
    AppFailure? failure,
    BrickWallResult? result,
    bool? hasSaved,
    bool clearFailure = false,
    bool clearResult = false,
  }) {
    return BrickWallState(
      lengthInput: lengthInput ?? this.lengthInput,
      heightInput: heightInput ?? this.heightInput,
      thicknessInput: thicknessInput ?? this.thicknessInput,
      selectedRatio: selectedRatio ?? this.selectedRatio,
      isLoading: isLoading ?? this.isLoading,
      failure: clearFailure ? null : (failure ?? this.failure),
      result: clearResult ? null : (result ?? this.result),
      hasSaved: hasSaved ?? this.hasSaved,
    );
  }
}
