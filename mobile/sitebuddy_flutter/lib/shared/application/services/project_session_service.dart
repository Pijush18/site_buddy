import 'package:flutter/foundation.dart';
import 'package:site_buddy/shared/domain/models/project.dart';
import 'package:site_buddy/shared/domain/repositories/project_repository.dart';
import 'package:site_buddy/core/logging/app_logger.dart';

/// SERVICE: ProjectSessionService
/// PURPOSE: Manages the active project session and notifies listeners on change.
class ProjectSessionService extends ChangeNotifier {
  final ProjectRepository _repository;

  /// In-memory active project.
  Project? _activeProject;

  ProjectSessionService({required ProjectRepository repository})
    : _repository = repository;

  /// SET ACTIVE: Updates the current session, project metadata, and notifies listeners.
  Future<void> setActiveProject(Project project) async {
    if (_activeProject?.id == project.id) return;

    AppLogger.info(
      'Switching Active Project: ${project.name} (${project.id})',
      tag: 'ProjectSession',
    );
    _activeProject = project;

    // Update last accessed timestamp in repository
    await _repository.setLastAccessed(project.id);

    // Notify all listeners to trigger system-wide refresh (e.g., Repositories, Controllers)
    notifyListeners();
  }

  /// GET ACTIVE: Returns the current active project.
  Project? getActiveProject() => _activeProject;

  /// GET ACTIVE ID: Returns the active project ID.
  /// THROWS: [StateError] if no project is currently active.
  String getActiveProjectId() {
    if (_activeProject == null) {
      throw StateError(
        'No active project selected. User must select a project before performing calculations.',
      );
    }
    return _activeProject!.id;
  }

  /// CLEAR: Resets the session and notifies listeners.
  void clearActiveProject() {
    if (_activeProject == null) return;

    AppLogger.info('Active Project cleared', tag: 'ProjectSession');
    _activeProject = null;
    notifyListeners();
  }
}
