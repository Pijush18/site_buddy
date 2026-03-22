import 'package:site_buddy/shared/domain/models/brick_wall_result.dart';
import 'package:site_buddy/core/errors/app_failure.dart';
import 'package:site_buddy/shared/domain/models/mortar_ratio.dart';

class BrickWallState {
  final String lengthInput;
  final String heightInput;
  final String thicknessInput;
  final MortarRatio selectedRatio;
  final BrickWallResult? result;
  final AppFailure? failure;
  final bool isLoading;
  final bool hasSaved;

  const BrickWallState({
    required this.lengthInput,
    required this.heightInput,
    required this.thicknessInput,
    required this.selectedRatio,
    this.result,
    this.failure,
    this.isLoading = false,
    this.hasSaved = false,
  });

  factory BrickWallState.initial() {
    return const BrickWallState(
      lengthInput: '',
      heightInput: '',
      thicknessInput: '',
      selectedRatio: MortarRatio.oneToSix,
      isLoading: false,
      hasSaved: false,
    );
  }

  BrickWallState copyWith({
    String? lengthInput,
    String? heightInput,
    String? thicknessInput,
    MortarRatio? selectedRatio,
    BrickWallResult? result,
    AppFailure? failure,
    bool? isLoading,
    bool? hasSaved,
    bool clearFailure = false,
    bool clearResult = false,
  }) {
    return BrickWallState(
      lengthInput: lengthInput ?? this.lengthInput,
      heightInput: heightInput ?? this.heightInput,
      thicknessInput: thicknessInput ?? this.thicknessInput,
      selectedRatio: selectedRatio ?? this.selectedRatio,
      result: clearResult ? null : (result ?? this.result),
      failure: clearFailure ? null : (failure ?? this.failure),
      isLoading: isLoading ?? this.isLoading,
      hasSaved: hasSaved ?? this.hasSaved,
    );
  }
}



