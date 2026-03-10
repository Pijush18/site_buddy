/// FILE HEADER
/// ----------------------------------------------
/// File: project_state.dart
/// Feature: project
/// Layer: application
///
/// PURPOSE:
/// Holds the immutable state of the project module.
///
/// RESPONSIBILITIES:
/// - Stores a list of Project objects.
/// - Stores the currently selected project for detail views.
/// - Manages loading flags and failure objects.
///
/// DEPENDENCIES:
/// - AppFailure, Project
///
/// FUTURE IMPROVEMENTS:
/// - Support pagination if projects list grows massive.
///
library;

/// - Add offline sync state trackers.
/// ----------------------------------------------


import 'package:equatable/equatable.dart';
import 'package:site_buddy/shared/domain/models/project.dart';
import 'package:site_buddy/core/errors/app_failure.dart';

/// CLASS: ProjectState
/// PURPOSE: Strict immutable container for Project UI state.
class ProjectState extends Equatable {
  final List<Project> projects;
  final Project? selectedProject;
  final bool isLoading;
  final AppFailure? failure;

  const ProjectState({
    required this.projects,
    this.selectedProject,
    required this.isLoading,
    this.failure,
  });

  /// METHOD: initial
  /// PURPOSE: Factory for initial empty state.
  factory ProjectState.initial() {
    return const ProjectState(projects: [], isLoading: false);
  }

  /// METHOD: copyWith
  /// PURPOSE: Immutable state duper.
  ProjectState copyWith({
    List<Project>? projects,
    Project? selectedProject,
    bool? isLoading,
    AppFailure? failure,
    bool clearFailure = false,
    bool clearSelectedProject = false,
  }) {
    return ProjectState(
      projects: projects ?? this.projects,
      selectedProject: clearSelectedProject
          ? null
          : (selectedProject ?? this.selectedProject),
      isLoading: isLoading ?? this.isLoading,
      failure: clearFailure ? null : (failure ?? this.failure),
    );
  }

  @override
  List<Object?> get props => [projects, selectedProject, isLoading, failure];
}
