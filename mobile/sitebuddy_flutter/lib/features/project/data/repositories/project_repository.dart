import 'package:hive_flutter/hive_flutter.dart';
import 'package:site_buddy/features/project/domain/models/project_model.dart';

/// REPOSITORY: ProjectRepository
/// Handles local storage and retrieval of projects using Hive.
class ProjectRepository {
  static const String _boxName = 'projects';
  
  late Box<ProjectModel> _box;
  
  /// Initialize the repository and open Hive box
  Future<void> init() async {
    // Register adapters if not already registered
    if (!Hive.isAdapterRegistered(20)) {
      Hive.registerAdapter(ProjectTypeAdapter());
    }
    if (!Hive.isAdapterRegistered(21)) {
      Hive.registerAdapter(ProjectStatusAdapter());
    }
    if (!Hive.isAdapterRegistered(22)) {
      Hive.registerAdapter(ProjectModelAdapter());
    }
    
    _box = await Hive.openBox<ProjectModel>(_boxName);
  }

  /// Get all projects
  List<ProjectModel> getAll() {
    return _box.values.toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  /// Get project by ID
  ProjectModel? getById(String id) {
    try {
      return _box.values.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Get projects by status
  List<ProjectModel> getByStatus(ProjectStatus status) {
    return _box.values.where((p) => p.status == status).toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  /// Get projects by type
  List<ProjectModel> getByType(ProjectType type) {
    return _box.values.where((p) => p.type == type).toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  /// Search projects by name or description
  List<ProjectModel> search(String query) {
    final lowerQuery = query.toLowerCase();
    return _box.values.where((p) {
      return p.name.toLowerCase().contains(lowerQuery) ||
          (p.description?.toLowerCase().contains(lowerQuery) ?? false) ||
          p.tags.any((tag) => tag.toLowerCase().contains(lowerQuery));
    }).toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  /// Save or update a project
  Future<void> save(ProjectModel project) async {
    await _box.put(project.id, project);
  }

  /// Delete a project
  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  /// Delete all projects
  Future<void> deleteAll() async {
    await _box.clear();
  }

  /// Check if project exists
  bool exists(String id) {
    return _box.containsKey(id);
  }

  /// Get project count
  int get count => _box.length;

  /// Get recent projects (last N projects)
  List<ProjectModel> getRecent({int limit = 5}) {
    final sorted = getAll();
    return sorted.take(limit).toList();
  }

  /// Watch for changes to the box
  Stream<BoxEvent> watch() {
    return _box.watch();
  }

  /// Close the box
  Future<void> close() async {
    await _box.close();
  }

  /// Export all projects as JSON
  List<Map<String, dynamic>> exportAll() {
    return _box.values.map((p) => p.toJson()).toList();
  }

  /// Import projects from JSON
  Future<int> importFromJson(List<Map<String, dynamic>> jsonList) async {
    int imported = 0;
    for (final json in jsonList) {
      try {
        final project = ProjectModel.fromJson(json);
        if (!exists(project.id)) {
          await save(project);
          imported++;
        }
      } catch (e) {
        // Skip invalid entries
        continue;
      }
    }
    return imported;
  }
}
