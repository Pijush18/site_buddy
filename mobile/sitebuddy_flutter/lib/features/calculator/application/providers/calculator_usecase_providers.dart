import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/features/calculator/domain/usecases/calculate_material_usecase.dart';
import 'package:site_buddy/features/calculator/domain/usecases/calculate_cement_usecase.dart';
import 'package:site_buddy/features/calculator/domain/usecases/calculate_gradient_usecase.dart';
import 'package:site_buddy/features/calculator/domain/usecases/calculate_level_usecase.dart';
import 'package:site_buddy/features/calculator/domain/usecases/calculate_rebar_usecase.dart';
import 'package:site_buddy/features/calculator/domain/usecases/calculate_sand_usecase.dart';

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
