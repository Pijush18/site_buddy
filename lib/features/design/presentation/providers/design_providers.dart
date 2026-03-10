import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/features/design/domain/repositories/structural_repository.dart';
import 'package:site_buddy/features/design/data/hive_structural_repository.dart';
import 'package:site_buddy/features/design/domain/usecases/get_project_structural_calculations_usecase.dart';

final structuralRepositoryProvider = Provider<StructuralRepository>(
  (ref) => HiveStructuralRepository(),
);

final getProjectStructuralCalculationsUseCaseProvider = Provider((ref) {
  final repository = ref.watch(structuralRepositoryProvider);
  return GetProjectStructuralCalculationsUseCase(repository);
});
