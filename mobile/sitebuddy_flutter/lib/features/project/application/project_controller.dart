import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/features/project/data/repositories/project_repository.dart';
import 'package:site_buddy/features/project/domain/models/project_model.dart';
import 'package:site_buddy/core/enums/unit_system.dart';
import 'package:uuid/uuid.dart';

/// Provider for ProjectRepository
final projectRepositoryProvider = Provider<ProjectRepository>((ref) {
  return ProjectRepository();
});

/// State class for project list
class ProjectListState {
  final List<ProjectModel> projects;
  final bool isLoading;
  final String? error;
  final String searchQuery;

  const ProjectListState({
    this.projects = const [],
    this.isLoading = false,
    this.error,
    this.searchQuery = '',
  });

  ProjectListState copyWith({
    List<ProjectModel>? projects,
    bool? isLoading,
    String? error,
    String? searchQuery,
  }) {
    return ProjectListState(
      projects: projects ?? this.projects,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  List<ProjectModel> get filteredProjects {
    if (searchQuery.isEmpty) return projects;
    final query = searchQuery.toLowerCase();
    return projects.where((p) {
      return p.name.toLowerCase().contains(query) ||
          (p.description?.toLowerCase().contains(query) ?? false) ||
          p.tags.any((tag) => tag.toLowerCase().contains(query));
    }).toList();
  }

  List<ProjectModel> get recentProjects {
    return projects.take(5).toList();
  }

  int get totalProjects => projects.length;
  int get inProgressCount => 
      projects.where((p) => p.status == ProjectStatus.inProgress).length;
  int get completedCount => 
      projects.where((p) => p.status == ProjectStatus.completed).length;
}

/// Controller for managing project list state
class ProjectListController extends Notifier<ProjectListState> {
  late final ProjectRepository _repository;
  final _uuid = const Uuid();

  @override
  ProjectListState build() {
    _repository = ref.watch(projectRepositoryProvider);
    _loadProjects();
    return const ProjectListState(isLoading: true);
  }

  Future<void> _loadProjects() async {
    try {
      await _repository.init();
      state = state.copyWith(
        projects: _repository.getAll(),
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load projects: $e',
      );
    }
  }

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true);
    await _loadProjects();
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  Future<ProjectModel> createProject({
    required String name,
    String? description,
    ProjectType type = ProjectType.residential,
    String? location,
    String? clientName,
    UnitSystem unitSystem = UnitSystem.metric,
  }) async {
    final project = ProjectModel(
      id: _uuid.v4(),
      name: name,
      description: description,
      type: type,
      location: location,
      clientName: clientName,
      unitSystem: unitSystem,
    );

    await _repository.save(project);
    state = state.copyWith(
      projects: [project, ...state.projects],
    );

    return project;
  }

  Future<void> updateProject(ProjectModel project) async {
    final updated = project.copyWith(updatedAt: DateTime.now());
    await _repository.save(updated);
    
    state = state.copyWith(
      projects: state.projects.map((p) {
        return p.id == updated.id ? updated : p;
      }).toList(),
    );
  }

  Future<void> deleteProject(String id) async {
    await _repository.delete(id);
    state = state.copyWith(
      projects: state.projects.where((p) => p.id != id).toList(),
    );
  }

  Future<void> updateProjectStatus(String id, ProjectStatus status) async {
    final project = _repository.getById(id);
    if (project != null) {
      await updateProject(project.copyWith(status: status));
    }
  }

  Future<void> addCalculationToProject(
    String projectId,
    String calculationType,
    Map<String, dynamic> calculation,
  ) async {
    final project = _repository.getById(projectId);
    if (project != null) {
      await updateProject(project.addCalculation(calculationType, calculation));
    }
  }

  Future<void> removeCalculationFromProject(
    String projectId,
    String calculationType,
    String calculationId,
  ) async {
    final project = _repository.getById(projectId);
    if (project != null) {
      await updateProject(project.removeCalculation(calculationType, calculationId));
    }
  }
}

/// Provider for ProjectListController
final projectListControllerProvider =
    NotifierProvider<ProjectListController, ProjectListState>(() {
  return ProjectListController();
});

/// Provider for getting a single project by ID
final projectByIdProvider = Provider.family<ProjectModel?, String>((ref, id) {
  final state = ref.watch(projectListControllerProvider);
  try {
    return state.projects.firstWhere((p) => p.id == id);
  } catch (_) {
    return null;
  }
});

/// State for currently active project (for editing)
class ActiveProjectState {
  final ProjectModel? project;
  final bool isDirty;

  const ActiveProjectState({
    this.project,
    this.isDirty = false,
  });

  ActiveProjectState copyWith({
    ProjectModel? project,
    bool? isDirty,
  }) {
    return ActiveProjectState(
      project: project ?? this.project,
      isDirty: isDirty ?? this.isDirty,
    );
  }
}

/// Controller for currently active project
class ActiveProjectController extends Notifier<ActiveProjectState> {
  @override
  ActiveProjectState build() {
    return const ActiveProjectState();
  }

  void setProject(ProjectModel? project) {
    state = ActiveProjectState(project: project, isDirty: false);
  }

  void updateProject(ProjectModel project) {
    state = state.copyWith(project: project, isDirty: true);
  }

  void markClean() {
    state = state.copyWith(isDirty: false);
  }

  void clear() {
    state = const ActiveProjectState();
  }
}

/// Provider for ActiveProjectController
final activeProjectControllerProvider =
    NotifierProvider<ActiveProjectController, ActiveProjectState>(() {
  return ActiveProjectController();
});
