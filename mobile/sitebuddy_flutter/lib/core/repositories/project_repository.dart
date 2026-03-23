import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:site_buddy/core/models/project_item.dart';

/// REPOSITORY: ProjectRepository
/// Handles CRUD operations for Project and ProjectItem persistence using Hive
class ProjectRepository {
  static const String _projectBoxName = 'projects';
  static const String _projectItemBoxName = 'project_items';
  late Box<Project> _projectBox;
  late Box<ProjectItem> _projectItemBox;
  final Uuid _uuid = const Uuid();

  /// Initialize the repository and open Hive boxes
  Future<void> init() async {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(ProjectAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(ProjectItemAdapter());
    }
    _projectBox = await Hive.openBox<Project>(_projectBoxName);
    _projectItemBox = await Hive.openBox<ProjectItem>(_projectItemBoxName);
  }

  // ═══════════════════════════════════════════════════════════════════════
  // PROJECT OPERATIONS
  // ═══════════════════════════════════════════════════════════════════════

  /// Create a new project
  Future<Project> createProject({
    required String name,
    String? description,
  }) async {
    final now = DateTime.now();
    final project = Project(
      id: _uuid.v4(),
      name: name,
      description: description,
      createdAt: now,
      updatedAt: now,
    );
    await _projectBox.put(project.id, project);
    return project;
  }

  /// Get all projects sorted by updated date (newest first)
  List<Project> getProjects() {
    final projects = _projectBox.values.toList();
    projects.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return projects;
  }

  /// Get a single project by ID
  Project? getProject(String id) {
    return _projectBox.get(id);
  }

  /// Update a project
  Future<Project> updateProject(Project project) async {
    final updated = project.copyWith(updatedAt: DateTime.now());
    await _projectBox.put(updated.id, updated);
    return updated;
  }

  /// Delete a project and its associated items
  Future<void> deleteProject(String id) async {
    // Delete all project items
    final itemsToDelete = _projectItemBox.values
        .where((item) => item.projectId == id)
        .map((item) => item.id)
        .toList();
    for (final itemId in itemsToDelete) {
      await _projectItemBox.delete(itemId);
    }
    // Delete project
    await _projectBox.delete(id);
  }

  // ═══════════════════════════════════════════════════════════════════════
  // PROJECT ITEM OPERATIONS
  // ═══════════════════════════════════════════════════════════════════════

  /// Add a history item to a project
  Future<ProjectItem> addItemToProject({
    required String projectId,
    required String historyItemId,
  }) async {
    final item = ProjectItem(
      id: _uuid.v4(),
      projectId: projectId,
      historyItemId: historyItemId,
      addedAt: DateTime.now(),
    );
    await _projectItemBox.put(item.id, item);
    
    // Update project's updatedAt
    final project = _projectBox.get(projectId);
    if (project != null) {
      await updateProject(project);
    }
    
    return item;
  }

  /// Remove a history item from a project
  Future<void> removeItemFromProject(String projectItemId) async {
    await _projectItemBox.delete(projectItemId);
  }

  /// Get all items in a project
  List<ProjectItem> getProjectItems(String projectId) {
    return _projectItemBox.values
        .where((item) => item.projectId == projectId)
        .toList()
      ..sort((a, b) => b.addedAt.compareTo(a.addedAt));
  }

  /// Get project item count
  int getProjectItemCount(String projectId) {
    return _projectItemBox.values
        .where((item) => item.projectId == projectId)
        .length;
  }

  /// Get total project count
  int get projectCount => _projectBox.length;
}