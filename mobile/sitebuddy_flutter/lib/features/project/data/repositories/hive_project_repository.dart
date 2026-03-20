import 'package:hive/hive.dart';
import 'package:site_buddy/shared/domain/models/project.dart';
import 'package:site_buddy/features/project/domain/repositories/project_repository.dart';
import 'package:site_buddy/core/backend/backend_client.dart';
import 'package:site_buddy/core/network/connectivity_service.dart';
import 'dart:developer' as developer;

/// REPOSITORY: HiveProjectRepository
/// PURPOSE: Concrete implementation of ProjectRepository using Hive local storage.
class HiveProjectRepository implements ProjectRepository {
  static const String boxName = 'projects_box';

  final BackendClient? _backendClient;
  final ConnectivityService? _connectivityService;

  HiveProjectRepository({
    BackendClient? backendClient,
    ConnectivityService? connectivityService,
  })  : _backendClient = backendClient,
        _connectivityService = connectivityService;

  /// METHOD: _openBox
  /// PURPOSE: Ensures the box is open before any operation.
  Future<Box<Project>> _openBox() async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<Project>(boxName);
    }
    return await Hive.openBox<Project>(boxName);
  }

  @override
  Future<List<Project>> getProjects() async {
    final box = await _openBox();
    return box.values.toList();
  }

  @override
  Future<Project?> getProjectById(String id) async {
    final box = await _openBox();
    return box.get(id);
  }

  @override
  Future<Project> createProject(Project project) async {
    final box = await _openBox();
    // Use the project id as the key for easier lookup
    await box.put(project.id, project);
    return project;
  }

  @override
  Future<Project> updateProject(Project project) async {
    final box = await _openBox();
    await box.put(project.id, project);
    return project;
  }

  @override
  Future<void> deleteProject(String id) async {
    final box = await _openBox();
    await box.delete(id);
  }

  @override
  Future<void> syncProjects() async {
    // 1. Guard against missing dependencies or offline status
    if (_backendClient == null || _connectivityService == null) return;
    
    if (!await _connectivityService.isOnline) {
      developer.log('Sync aborted: Device is offline', name: 'HiveProjectRepository');
      return;
    }

    try {
      // 2. Fetch local projects
      final box = await _openBox();
      final localProjects = box.values.toList();
      if (localProjects.isEmpty) return;

      // 3. Fetch remote projects (minimal check for Phase-1)
      final remoteProjects = await _backendClient.fetchProjects();
      final remoteIds = remoteProjects.map((p) => p.id).toSet();

      // 4. Upload missing projects
      int syncCount = 0;
      for (final project in localProjects) {
        if (!remoteIds.contains(project.id)) {
          await _backendClient.createProject(project);
          syncCount++;
        }
      }

      developer.log('Sync complete: $syncCount projects uploaded to cloud', name: 'HiveProjectRepository');
    } catch (e) {
      // Offline-first: log failure but don't crash
      developer.log('Cloud sync failed: $e', name: 'HiveProjectRepository', error: e);
    }
  }
}



