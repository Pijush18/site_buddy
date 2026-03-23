import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/repositories/history_repository.dart';
import 'package:site_buddy/core/repositories/project_repository.dart';

/// PROVIDER: HistoryRepository
/// Singleton provider for HistoryRepository
final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  return HistoryRepository();
});

/// PROVIDER: ProjectRepository
/// Singleton provider for ProjectRepository
final projectRepositoryProvider = Provider<ProjectRepository>((ref) {
  return ProjectRepository();
});

/// NOTIFIER: HistoryNotifier
/// State management for history operations
class HistoryNotifier extends StateNotifier<AsyncValue<List<dynamic>>> {
  final HistoryRepository _repository;

  HistoryNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadHistory();
  }

  Future<void> loadHistory() async {
    state = const AsyncValue.loading();
    try {
      final history = _repository.getAllHistory();
      state = AsyncValue.data(history);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addHistory({
    required String toolId,
    required String title,
    required Map<String, dynamic> inputData,
    required Map<String, dynamic> resultData,
    String? projectId,
  }) async {
    try {
      await _repository.addHistory(
        toolId: toolId,
        title: title,
        inputData: inputData,
        resultData: resultData,
        projectId: projectId,
      );
      await loadHistory();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteHistory(String id) async {
    try {
      await _repository.deleteHistory(id);
      await loadHistory();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> clearHistory() async {
    try {
      await _repository.clearHistory();
      await loadHistory();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

/// PROVIDER: HistoryNotifier
/// StateNotifier for history management
final historyNotifierProvider = StateNotifierProvider<HistoryNotifier, AsyncValue<List<dynamic>>>((ref) {
  final repository = ref.watch(historyRepositoryProvider);
  return HistoryNotifier(repository);
});

/// NOTIFIER: ProjectNotifier
/// State management for project operations
class ProjectNotifier extends StateNotifier<AsyncValue<List<dynamic>>> {
  final ProjectRepository _repository;

  ProjectNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadProjects();
  }

  Future<void> loadProjects() async {
    state = const AsyncValue.loading();
    try {
      final projects = _repository.getProjects();
      state = AsyncValue.data(projects);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> createProject({
    required String name,
    String? description,
  }) async {
    try {
      await _repository.createProject(name: name, description: description);
      await loadProjects();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteProject(String id) async {
    try {
      await _repository.deleteProject(id);
      await loadProjects();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addItemToProject({
    required String projectId,
    required String historyItemId,
  }) async {
    try {
      await _repository.addItemToProject(
        projectId: projectId,
        historyItemId: historyItemId,
      );
      await loadProjects();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

/// PROVIDER: ProjectNotifier
/// StateNotifier for project management
final projectNotifierProvider = StateNotifierProvider<ProjectNotifier, AsyncValue<List<dynamic>>>((ref) {
  final repository = ref.watch(projectRepositoryProvider);
  return ProjectNotifier(repository);
});