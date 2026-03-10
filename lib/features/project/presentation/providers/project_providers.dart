import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/features/project/domain/repositories/project_repository.dart';
import 'package:site_buddy/features/project/domain/usecases/get_projects_usecase.dart';
import 'package:site_buddy/features/project/domain/usecases/create_project_usecase.dart';
import 'package:site_buddy/features/project/domain/usecases/update_project_usecase.dart';
import 'package:site_buddy/features/project/domain/usecases/delete_project_usecase.dart';
import 'package:site_buddy/features/project/data/repositories/hive_project_repository.dart';

/// Provider exposing the [ProjectRepository].
final projectRepositoryProvider = Provider<ProjectRepository>((ref) {
  return HiveProjectRepository();
});

final getProjectsUseCaseProvider = Provider((ref) {
  final repository = ref.watch(projectRepositoryProvider);
  return GetProjectsUseCase(repository);
});

final createProjectUseCaseProvider = Provider((ref) {
  final repository = ref.watch(projectRepositoryProvider);
  return CreateProjectUseCase(repository);
});

final updateProjectUseCaseProvider = Provider((ref) {
  final repository = ref.watch(projectRepositoryProvider);
  return UpdateProjectUseCase(repository);
});

final deleteProjectUseCaseProvider = Provider((ref) {
  final repository = ref.watch(projectRepositoryProvider);
  return DeleteProjectUseCase(repository);
});
