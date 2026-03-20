/// FILE HEADER
/// ----------------------------------------------
/// File: project_repository.dart
/// Feature: project
/// Layer: domain
///
/// PURPOSE:
/// Defines the contract for providing Project entities to the application.
///
/// RESPONSIBILITIES:
/// - Abstracting data source (database/network) from the business logic.
///
/// DEPENDENCIES:
/// - Project entity
///
/// FUTURE IMPROVEMENTS:
/// - Implement SQLite-backed version of this repo.
/// - Add methods to delete or rename projects.
///
library;

/// - Add Firebase sync
/// - Add offline storage
/// ----------------------------------------------


import 'package:site_buddy/shared/domain/models/project.dart';

/// CLASS: ProjectRepository
/// PURPOSE: Abstract interface representing the data layer for Projects.
/// WHY: Enforces the Dependency Inversion principle in Clean Architecture.
abstract class ProjectRepository {
  /// METHOD: getProjects
  /// PURPOSE: Fetches the list of all active projects.
  /// PARAMETERS: None
  /// RETURNS: A Future completing with a list of `Project` objects.
  /// LOGIC: Queries local database and maps rows to entities.
  Future<List<Project>> getProjects();

  /// METHOD: getProjectById
  /// PURPOSE: Retrieves a single project.
  Future<Project?> getProjectById(String id);

  /// METHOD: createProject
  /// PURPOSE: Saves a brand new project.
  Future<Project> createProject(Project project);

  /// METHOD: updateProject
  /// PURPOSE: Applies mutation to an existing project entity.
  Future<Project> updateProject(Project project);

  /// METHOD: deleteProject
  /// PURPOSE: Deletes a project by its id.
  Future<void> deleteProject(String id);

  /// METHOD: syncProjects
  /// PURPOSE: Synchronizes local projects with the cloud backend.
  Future<void> syncProjects();
}



