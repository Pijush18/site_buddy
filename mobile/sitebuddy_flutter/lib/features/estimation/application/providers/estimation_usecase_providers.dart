import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/features/estimation/concrete/domain/calculate_material_usecase.dart';
import 'package:site_buddy/features/estimation/cement/domain/calculate_cement_usecase.dart';
import 'package:site_buddy/features/surveying/gradient/domain/calculate_gradient_usecase.dart';
import 'package:site_buddy/features/surveying/level/domain/calculate_level_usecase.dart';
import 'package:site_buddy/features/estimation/rebar/domain/calculate_rebar_usecase.dart';
import 'package:site_buddy/features/estimation/sand/domain/calculate_sand_usecase.dart';

final calculateMaterialUseCaseProvider = Provider<CalculateMaterialUseCase>((
  ref,
) {
  return CalculateMaterialUseCase();
});

final calculateCementUseCaseProvider = Provider<CalculateCementUseCase>((ref) {
  return const CalculateCementUseCase();
});

final calculateGradientUseCaseProvider = Provider<CalculateGradientUseCase>((
  ref,
) {
  return const CalculateGradientUseCase();
});

final calculateLevelUseCaseProvider = Provider<CalculateLevelUseCase>((ref) {
  return const CalculateLevelUseCase();
});

final calculateRebarUseCaseProvider = Provider<CalculateRebarUseCase>((ref) {
  return const CalculateRebarUseCase();
});

final calculateSandUseCaseProvider = Provider<CalculateSandUseCase>((ref) {
  return const CalculateSandUseCase();
});
