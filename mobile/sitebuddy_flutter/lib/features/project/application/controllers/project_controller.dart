/// FILE HEADER
/// ----------------------------------------------
/// File: project_controller.dart
/// Feature: project
/// Layer: application
///
/// PURPOSE:
/// Manages project list and selection, interfacing with domain repositories.
///
/// RESPONSIBILITIES:
/// - Stores a state combining a list of `Project` objects and active UI flags.
/// - Handles creation and editing of projects.
///
/// DEPENDENCIES:
/// - Riverpod for NotifierProvider.
/// - Project entity and ProjectState.
///
/// FUTURE IMPROVEMENTS:
/// - Connect to real remote ProjectRepository.
///
library;

/// - Add Firebase sync logic.
/// ----------------------------------------------


import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/shared/domain/models/project.dart';
import 'package:site_buddy/shared/domain/models/project_status.dart';
import 'package:site_buddy/features/project/application/state/project_state.dart';
import 'package:site_buddy/features/project/presentation/providers/project_providers.dart';
import 'package:site_buddy/features/auth/application/auth_providers.dart';

/// Provider exposing the [ProjectController].
final projectControllerProvider =
    NotifierProvider<ProjectController, ProjectState>(ProjectController.new);

/// CLASS: ProjectController
/// PURPOSE: Riverpod state controller for the projects module.
class ProjectController extends Notifier<ProjectState> {
  @override
  ProjectState build() {
    // 1. Listen for Auth changes to clear/refresh projects
    ref.listen(authStateProvider, (previous, next) {
      final user = next.value;
      final prevUser = previous?.value;

      if (user != null && prevUser == null) {
        // Logged in: Refresh projects
        _loadProjects();
      } else if (user == null && prevUser != null) {
        // Logged out: Clear projects immediately
        state = const ProjectState(projects: [], isLoading: false);
      }
    });

    // 2. Initial load
    _loadProjects();

    return const ProjectState(projects: [], isLoading: true);
  }

  Future<void> _loadProjects() async {
    final useCase = ref.read(getProjectsUseCaseProvider);
    final projects = await useCase.execute();
    state = state.copyWith(projects: projects, isLoading: false);
  }

  /// METHOD: getProjectById
  /// PURPOSE: Retrieves a single project without mutating the state selection directly
  Project? getProjectById(String id) {
    try {
      return state.projects.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  /// METHOD: createProject
  /// PURPOSE: Saves a brand new project to local storage.
  Future<void> createProject({
    required String name,
    required String location,
    String? clientName,
    String? description,
    required ProjectStatus status,
  }) async {
    state = state.copyWith(isLoading: true, clearFailure: true);

    // Mock ID generation
    final newId = DateTime.now().millisecondsSinceEpoch.toString();

    final newProj = Project(
      id: newId,
      name: name,
      location: location,
      clientName: clientName,
      description: description,
      status: status,
      createdAt: DateTime.now(),
      logsCount: 0,
      calculationsCount: 0,
    );

    final useCase = ref.read(createProjectUseCaseProvider);
    await useCase.execute(newProj);

    state = state.copyWith(
      isLoading: false,
      projects: [...state.projects, newProj],
    );
  }

  /// METHOD: updateProject
  /// PURPOSE: Mutation to an existing project entity with persistence.
  Future<void> updateProject(Project updatedProject) async {
    state = state.copyWith(isLoading: true, clearFailure: true);

    final idx = state.projects.indexWhere((p) => p.id == updatedProject.id);
    final useCase = ref.read(updateProjectUseCaseProvider);
    if (idx != -1) {
      await useCase.execute(updatedProject);

      final updatedList = List<Project>.from(state.projects);
      updatedList[idx] = updatedProject;

      state = state.copyWith(
        isLoading: false,
        projects: updatedList,
        selectedProject: state.selectedProject?.id == updatedProject.id
            ? updatedProject
            : state.selectedProject,
      );
    } else {
      state = state.copyWith(isLoading: false);
    }
  }

  /// METHOD: deleteProject
  /// PURPOSE: Removal from local storage and state.
  Future<void> deleteProject(String id) async {
    state = state.copyWith(isLoading: true);

    final useCase = ref.read(deleteProjectUseCaseProvider);
    await useCase.execute(id);

    state = state.copyWith(
      isLoading: false,
      projects: state.projects.where((p) => p.id != id).toList(),
      selectedProject: state.selectedProject?.id == id
          ? null
          : state.selectedProject,
    );
  }

  /// METHOD: attachChatToProject
  /// PURPOSE: Attaching an AI Chat ID to an existing project entity with persistence.
  Future<void> attachChatToProject(String chatId, String projectId) async {
    state = state.copyWith(isLoading: true, clearFailure: true);

    final idx = state.projects.indexWhere((p) => p.id == projectId);
    if (idx != -1) {
      final project = state.projects[idx];
      // Prevent duplicates
      if (!project.linkedChatIds.contains(chatId)) {
        final updatedProject = project.copyWith(
          linkedChatIds: [...project.linkedChatIds, chatId],
        );

        final useCase = ref.read(updateProjectUseCaseProvider);
        await useCase.execute(updatedProject);

        final updatedList = List<Project>.from(state.projects);
        updatedList[idx] = updatedProject;

        state = state.copyWith(
          isLoading: false,
          projects: updatedList,
          selectedProject: state.selectedProject?.id == projectId
              ? updatedProject
              : state.selectedProject,
        );
      } else {
        state = state.copyWith(isLoading: false);
      }
    } else {
      state = state.copyWith(isLoading: false);
    }
  }
}



