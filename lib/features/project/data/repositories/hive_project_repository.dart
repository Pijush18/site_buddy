import 'package:hive/hive.dart';
import 'package:site_buddy/shared/domain/models/project.dart';
import 'package:site_buddy/features/project/domain/repositories/project_repository.dart';

/// REPOSITORY: HiveProjectRepository
/// PURPOSE: Concrete implementation of ProjectRepository using Hive local storage.
class HiveProjectRepository implements ProjectRepository {
  static const String boxName = 'projects_box';

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
}
