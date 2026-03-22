import 'package:site_buddy/features/project/domain/models/project.dart';

/// REPOSITORY: ProjectRepository
/// PURPOSE: Abstract contract for managing construction projects.
abstract class ProjectRepository {
  /// READ: Fetches all projects, sorted by [lastAccessedAt] DESC.
  Future<List<Project>> getProjects();

  /// READ: Fetches a single project by ID.
  Future<Project?> getProjectById(String id);

  /// PERSIST: Creates a new project.
  Future<Project> createProject(Project project);

  /// UPDATE: Updates an existing project.
  Future<Project> updateProject(Project project);

  /// DELETE: Removes a project and its references.
  Future<void> deleteProject(String id);

  /// UPDATE: Updates the [lastAccessedAt] timestamp.
  Future<void> setLastAccessed(String id);

  /// SYNC: Synchronizes local projects with the cloud backend.
  Future<void> syncProjects();
}

