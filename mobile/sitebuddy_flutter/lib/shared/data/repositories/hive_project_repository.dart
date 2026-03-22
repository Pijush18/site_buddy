import 'package:hive_flutter/hive_flutter.dart';
import 'package:site_buddy/shared/domain/models/project.dart';
import 'package:site_buddy/shared/domain/repositories/project_repository.dart';
import 'package:site_buddy/core/logging/app_logger.dart';

/// REPOSITORY IMPLEMENTATION: HiveProjectRepository
/// PURPOSE: Standardized production-grade persistence for construction projects.
class HiveProjectRepository implements ProjectRepository {
  static const String _boxName = 'projects_box';

  /// In-memory cache for ultra-fast reads.
  List<Project>? _cache;

  /// Helper to access the pre-opened box.
  Box<Project> get _box {
    if (!Hive.isBoxOpen(_boxName)) {
      throw StateError(
        'Hive box "$_boxName" must be opened during AppInitializer',
      );
    }
    return Hive.box<Project>(_boxName);
  }

  /// Internal: Ensures the cache is populated and sorted (lastAccessedAt DESC).
  List<Project> _getCache() {
    if (_cache == null) {
      _cache = _box.values.toList();
      _sortCache(_cache!);
    }
    return _cache!;
  }

  void _sortCache(List<Project> list) {
    list.sort((a, b) {
      final aTime = a.lastAccessedAt ?? a.createdAt;
      final bTime = b.lastAccessedAt ?? b.createdAt;
      return bTime.compareTo(aTime);
    });
  }

  @override
  Future<List<Project>> getProjects() async {
    return List.unmodifiable(_getCache());
  }

  @override
  Future<Project?> getProjectById(String id) async {
    final cache = _getCache();
    try {
      return cache.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Project> createProject(Project project) async {
    // FAIL FAST on invalid data - validate required fields
    if (project.id.isEmpty) {
      throw ArgumentError('Project ID cannot be empty');
    }

    if (project.name.isEmpty) {
      throw ArgumentError('Project name cannot be empty');
    }

    if (project.location.isEmpty) {
      throw ArgumentError('Project location cannot be empty');
    }

    try {
      AppLogger.info(
        'Creating project: ${project.id} (${project.name})',
        tag: 'ProjectRepo',
      );

      // 1. Save to Hive
      await _box.put(project.id, project);

      // 2. Update Cache
      final cache = _getCache();
      cache.add(project);
      _sortCache(cache);

      return project;
    } catch (e, stack) {
      AppLogger.error(
        'Failed to create project: ${project.id}',
        tag: 'ProjectRepo',
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }

  @override
  Future<Project> updateProject(Project project) async {
    try {
      // 1. Save to Hive
      await _box.put(project.id, project);

      // 2. Update Cache
      final cache = _getCache();
      final index = cache.indexWhere((p) => p.id == project.id);
      if (index >= 0) {
        cache[index] = project;
        _sortCache(cache);
      }
      return project;
    } catch (e, stack) {
      AppLogger.error(
        'Failed to update project: ${project.id}',
        tag: 'ProjectRepo',
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }

  @override
  Future<void> deleteProject(String id) async {
    try {
      AppLogger.warning('Deleting project: $id', tag: 'ProjectRepo');

      // 1. Delete from Hive
      await _box.delete(id);

      // 2. Update Cache
      _cache?.removeWhere((p) => p.id == id);
    } catch (e, stack) {
      AppLogger.error(
        'Failed to delete project: $id',
        tag: 'ProjectRepo',
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }

  @override
  Future<void> setLastAccessed(String id) async {
    final project = await getProjectById(id);
    if (project != null) {
      final updated = project.copyWith(lastAccessedAt: DateTime.now());
      await updateProject(updated);
    }
  }

  @override
  Future<void> syncProjects() async {
    // Integration point for background sync
    AppLogger.info('Sync requested (Not implemented yet)', tag: 'ProjectRepo');
  }
}
