import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/features/project/domain/models/project_status.dart';
import 'package:site_buddy/features/project/application/controllers/project_controller.dart';

/// STATE: ProjectEditorState
/// Holds all state for the project editor screen.
class ProjectEditorState {
  final String name;
  final String location;
  final String clientName;
  final String description;
  final ProjectStatus status;
  final bool isSaving;
  final String? error;

  const ProjectEditorState({
    this.name = '',
    this.location = '',
    this.clientName = '',
    this.description = '',
    this.status = ProjectStatus.active,
    this.isSaving = false,
    this.error,
  });

  ProjectEditorState copyWith({
    String? name,
    String? location,
    String? clientName,
    String? description,
    ProjectStatus? status,
    bool? isSaving,
    String? error,
    bool clearError = false,
  }) {
    return ProjectEditorState(
      name: name ?? this.name,
      location: location ?? this.location,
      clientName: clientName ?? this.clientName,
      description: description ?? this.description,
      status: status ?? this.status,
      isSaving: isSaving ?? this.isSaving,
      error: clearError ? null : (error ?? this.error),
    );
  }

  /// Returns true if form is valid for submission
  bool get isValid => name.trim().isNotEmpty && location.trim().isNotEmpty;
}

/// NOTIFIER: ProjectEditorNotifier
/// Manages project editor form state and submission.
/// All business logic is centralized here - UI is purely declarative.
class ProjectEditorNotifier extends Notifier<ProjectEditorState> {
  @override
  ProjectEditorState build() {
    return const ProjectEditorState();
  }

  void updateName(String value) {
    state = state.copyWith(name: value, clearError: true);
  }

  void updateLocation(String value) {
    state = state.copyWith(location: value, clearError: true);
  }

  void updateClientName(String value) {
    state = state.copyWith(clientName: value);
  }

  void updateDescription(String value) {
    state = state.copyWith(description: value);
  }

  void updateStatus(ProjectStatus status) {
    state = state.copyWith(status: status);
  }

  /// Submit the project - handles all business logic
  Future<bool> submit(WidgetRef ref) async {
    if (!state.isValid) {
      state = state.copyWith(error: 'Please fill in required fields');
      return false;
    }

    state = state.copyWith(isSaving: true, clearError: true);

    try {
      // Create via project controller
      await ref.read(projectControllerProvider.notifier).createProject(
        name: state.name.trim(),
        location: state.location.trim(),
        clientName: state.clientName.trim().isNotEmpty ? state.clientName.trim() : null,
        description: state.description.trim().isNotEmpty ? state.description.trim() : null,
        status: state.status,
      );

      state = state.copyWith(isSaving: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: 'Failed to save project: ${e.toString()}',
      );
      return false;
    }
  }

  void reset() {
    state = const ProjectEditorState();
  }
}

/// Provider for ProjectEditorNotifier
final projectEditorControllerProvider =
    NotifierProvider<ProjectEditorNotifier, ProjectEditorState>(
  ProjectEditorNotifier.new,
);
