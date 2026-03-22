import 'package:hive_flutter/hive_flutter.dart';
import 'package:site_buddy/shared/domain/models/design/design_report.dart';
import 'package:site_buddy/shared/domain/repositories/history_repository.dart';
import 'package:site_buddy/core/logging/app_logger.dart';
import 'package:site_buddy/shared/domain/repositories/project_repository.dart';

/// REPOSITORY IMPLEMENTATION: HiveHistoryRepository
/// PURPOSE: Unified production-grade Hive persistence with strict project isolation.
class HiveHistoryRepository implements HistoryRepository {
  static const String _boxName = 'history_reports_box';

  final ProjectRepository? _projectRepository;

  HiveHistoryRepository({ProjectRepository? projectRepository})
    : _projectRepository = projectRepository;

  /// Project-specific in-memory cache for ultra-fast, isolated reads.
  /// Key: projectId, Value: List of DesignReports for that project.
  final Map<String, List<DesignReport>> _projectCaches = {};

  /// Helper to access the pre-opened box.
  Box<DesignReport> get _box {
    if (!Hive.isBoxOpen(_boxName)) {
      throw StateError(
        'Hive box "$_boxName" must be opened during AppInitializer',
      );
    }
    return Hive.box<DesignReport>(_boxName);
  }

  /// Internal: Ensures the cache for a specific project is populated and sorted.
  List<DesignReport> _getProjectCache(String projectId) {
    if (!_projectCaches.containsKey(projectId)) {
      AppLogger.debug(
        'Priming cache for project: $projectId',
        tag: 'HistoryRepo',
      );
      final reports = _box.values
          .where((r) => r.projectId == projectId)
          .toList();
      reports.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      _projectCaches[projectId] = reports;
    }
    return _projectCaches[projectId]!;
  }

  @override
  Future<void> save(DesignReport report) async {
    // 1. Strict Validation: Mandatory projectId
    if (report.projectId.isEmpty) {
      AppLogger.error(
        'Cannot save DesignReport with empty projectId: ${report.id}',
        tag: 'HistoryRepo',
      );
      throw ArgumentError(
        'DesignReport must be linked to a valid project (empty projectId)',
      );
    }

    if (report.id.isEmpty) {
      throw ArgumentError('Cannot save DesignReport with an empty ID');
    }

    try {
      // 2. Update Hive (Single Source of Truth)
      await _box.put(report.id, report);

      // 3. Update Project-Specific Cache
      final cache = _getProjectCache(report.projectId);
      final index = cache.indexWhere((r) => r.id == report.id);

      if (index >= 0) {
        cache[index] = report;
      } else {
        cache.add(report);
      }

      // Maintain sort order (newest first)
      cache.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      // 4. Trace access back to project
      await _projectRepository?.setLastAccessed(report.projectId);

      AppLogger.info(
        'DesignReport saved: ${report.id} in Project: ${report.projectId}',
        tag: 'HistoryRepo',
      );
    } catch (e, stack) {
      AppLogger.error(
        'Failed to save DesignReport: ${report.id}',
        tag: 'HistoryRepo',
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }

  @override
  List<DesignReport> getAll() {
    // Note: Calling getAll() is discouraged in project-centric architecture
    // Returning sorted global records as fallback
    AppLogger.warning(
      'Global getAll() called in project-centric repository',
      tag: 'HistoryRepo',
    );
    final all = _box.values.toList();
    all.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return List.unmodifiable(all);
  }

  @override
  List<DesignReport> getReportsByProject(String projectId) {
    return List.unmodifiable(_getProjectCache(projectId));
  }

  @override
  Future<void> delete(String id) async {
    try {
      final report = _box.get(id);
      if (report == null) return;

      final projectId = report.projectId;

      // 1. Delete from Hive
      await _box.delete(id);

      // 2. Update Project-Specific Cache
      _projectCaches[projectId]?.removeWhere((r) => r.id == id);

      AppLogger.info(
        'DesignReport deleted: $id from Project: $projectId',
        tag: 'HistoryRepo',
      );
    } catch (e, stack) {
      AppLogger.error(
        'Failed to delete DesignReport: $id',
        tag: 'HistoryRepo',
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }

  @override
  Future<void> clear() async {
    try {
      await _box.clear();
      _projectCaches.clear();
      AppLogger.warning('All project history data purged', tag: 'HistoryRepo');
    } catch (e, stack) {
      AppLogger.error(
        'Failed to clear history data',
        tag: 'HistoryRepo',
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }

  @override
  bool exists(String id) {
    return _box.containsKey(id);
  }
}
