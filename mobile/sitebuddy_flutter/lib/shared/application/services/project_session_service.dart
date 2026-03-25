import 'package:flutter/foundation.dart';
import 'package:site_buddy/features/project/domain/models/project.dart';
import 'package:site_buddy/shared/domain/repositories/project_repository.dart';
import 'package:site_buddy/core/logging/app_logger.dart';

/// SERVICE: ProjectSessionService
/// PURPOSE: Manages the active project session and notifies listeners on change.
/// NOTE: Production-safe version with strict + nullable access patterns
class ProjectSessionService extends ChangeNotifier {
  final ProjectRepository _repository;

  /// In-memory active project.
  Project? _activeProject;

  ProjectSessionService({required ProjectRepository repository})
      : _repository = repository;

  /// SET ACTIVE: Updates the current session and notifies listeners.
  Future<void> setActiveProject(Project project) async {
    if (_activeProject?.id == project.id) return;

    AppLogger.info(
      'Switching Active Project: ${project.name} (${project.id})',
      tag: 'ProjectSession',
    );

    _activeProject = project;

    // Update last accessed timestamp in repository
    await _repository.setLastAccessed(project.id);

    notifyListeners();
  }

  /// GET ACTIVE: Returns the current active project.
  Project? getActiveProject() => _activeProject;

  /// SAFE ACCESS: Nullable project ID (for UI layer)
  String? getActiveProjectIdOrNull() {
    return _activeProject?.id;
  }

  /// STRICT ACCESS: Non-null project ID (for domain/use cases)
  /// Throws ONLY if UI layer failed to guard properly
  String getActiveProjectId() {
    if (_activeProject == null) {
      throw StateError(
        'No active project selected. This should be handled at UI layer.',
      );
    }
    return _activeProject!.id;
  }

  /// CHECK: Whether a project is currently active.
  bool get hasActiveProject => _activeProject != null;

  /// OPTIONAL: Direct getter (readable access)
  Project? get activeProject => _activeProject;

  /// CLEAR: Resets the session and notifies listeners.
  void clearActiveProject() {
    if (_activeProject == null) return;

    AppLogger.info('Active Project cleared', tag: 'ProjectSession');

    _activeProject = null;
    notifyListeners();
  }
<<<<<<< HEAD
}

=======
}
>>>>>>> 64d70f8 (fix(navigation): resolve Home opening Project tab due to ShellRoute index mismatch)
