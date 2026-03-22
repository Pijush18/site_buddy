import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/features/design/presentation/providers/design_providers.dart';
import 'package:site_buddy/features/level_log/presentation/providers/level_log_providers.dart';
import 'package:site_buddy/features/level_log/domain/entities/level_log_session.dart';
import 'package:site_buddy/shared/application/providers/project_providers.dart';

/// Wraps the complex data required by the Project Detail Screen
class ProjectDetailState {
  final Map<String, dynamic> calculations;
  final List<LevelLogSession> logs;

  ProjectDetailState({required this.calculations, required this.logs});
}

/// FIX: Get projectId from session ONLY - no family parameter
final projectDetailControllerProvider = Provider<ProjectDetailState>((ref) {
  // Get projectId from session - throws if no active project
  final projectId = ref
      .read(projectSessionServiceProvider)
      .getActiveProjectId();

  final structuralUseCase = ref.watch(
    getProjectStructuralCalculationsUseCaseProvider,
  );
  final logUseCase = ref.watch(getProjectLevelLogsUseCaseProvider);

  return ProjectDetailState(
    calculations: structuralUseCase.execute(projectId),
    logs: logUseCase.execute(projectId).cast<LevelLogSession>(),
  );
});
