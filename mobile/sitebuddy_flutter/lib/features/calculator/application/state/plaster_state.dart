import 'package:site_buddy/shared/domain/models/plaster_material_result.dart';
import 'package:site_buddy/core/errors/app_failure.dart';
import 'package:site_buddy/shared/domain/models/plaster_ratio.dart';

class PlasterState {
  final String areaInput;
  final String thicknessInput;
  final PlasterRatio selectedRatio;
  final PlasterMaterialResult? result;
  final AppFailure? failure;
  final bool isLoading;

  const PlasterState({
    required this.areaInput,
    required this.thicknessInput,
    required this.selectedRatio,
    this.result,
    this.failure,
    this.isLoading = false,
  });

  factory PlasterState.initial() {
    return const PlasterState(
      areaInput: '',
      thicknessInput: '',
      selectedRatio: PlasterRatio.oneToFour,
      isLoading: false,
    );
  }

  PlasterState copyWith({
    String? areaInput,
    String? thicknessInput,
    PlasterRatio? selectedRatio,
    PlasterMaterialResult? result,
    AppFailure? failure,
    bool? isLoading,
    bool clearFailure = false,
    bool clearResult = false,
  }) {
    return PlasterState(
      areaInput: areaInput ?? this.areaInput,
      thicknessInput: thicknessInput ?? this.thicknessInput,
      selectedRatio: selectedRatio ?? this.selectedRatio,
      result: clearResult ? null : (result ?? this.result),
      failure: clearFailure ? null : (failure ?? this.failure),
      isLoading: isLoading ?? this.isLoading,
    );
  }
}



