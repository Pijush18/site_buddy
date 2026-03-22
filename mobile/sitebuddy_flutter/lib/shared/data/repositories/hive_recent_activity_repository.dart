import 'package:hive_flutter/hive_flutter.dart';
import 'package:site_buddy/features/home/domain/models/activity_item.dart';
import 'package:site_buddy/features/home/domain/models/activity_type.dart';
import 'package:site_buddy/features/structural/shared/domain/models/design_report.dart';
import 'package:site_buddy/features/project/domain/models/project.dart';
import 'package:site_buddy/shared/domain/repositories/history_repository.dart';
import 'package:site_buddy/shared/domain/repositories/recent_activity_repository.dart';
import 'package:site_buddy/core/logging/app_logger.dart';

/// REPOSITORY IMPLEMENTATION: HiveRecentActivityRepository
/// PURPOSE: Aggregates and filters recent activities from history and other sources.
class HiveRecentActivityRepository implements RecentActivityRepository {
  final HistoryRepository _historyRepository;
  static const String _projectActivityBoxName = 'project_activities_box';

  HiveRecentActivityRepository({required HistoryRepository historyRepository})
    : _historyRepository = historyRepository;

  /// Helper to access the pre-opened box (opened in AppInitializer).
  Box get _box {
    if (!Hive.isBoxOpen(_projectActivityBoxName)) {
      throw StateError(
        'Hive box "$_projectActivityBoxName" must be opened during AppInitializer',
      );
    }
    return Hive.box(_projectActivityBoxName);
  }

  @override
  Future<List<ActivityItem>> getRecentActivities(
    String projectId, {
    int limit = 5,
  }) async {
    try {
      AppLogger.debug(
        'Fetching recent activity for project: $projectId',
        tag: 'RecentActivity',
      );

      // 1. Fetch design reports from history
      final reports = _historyRepository.getReportsByProject(projectId);
      final reportActivities = reports.map(
        (report) => ActivityItem(
          type: _mapDesignToActivityType(report.designType),
          title: report.typeLabel,
          subtitle: report.summary,
          timestamp: report.timestamp,
          projectId: report.projectId,
          deepLink: '/history/detail/${report.id}',
        ),
      );

      // 2. Fetch project events (creation etc) from pre-opened box
      final projectActivities = _box.values
          .where((data) => data is Map && data['projectId'] == projectId)
          .map((data) {
            final map = data as Map;
            return ActivityItem(
              type: ActivityType.values.firstWhere(
                (e) => e.name == map['type'],
                orElse: () => ActivityType.project,
              ),
              title: map['title'] as String,
              subtitle: map['subtitle'] as String,
              timestamp: DateTime.parse(map['timestamp'] as String),
              projectId: map['projectId'] as String,
            );
          });

      // 3. Aggregate and Sort
      final allActivities = [...reportActivities, ...projectActivities];
      allActivities.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      return allActivities.take(limit).toList();
    } catch (e, stack) {
      AppLogger.error(
        'Failed to fetch recent activities',
        tag: 'RecentActivity',
        error: e,
        stackTrace: stack,
      );
      return [];
    }
  }

  @override
  Future<void> addProject(Project project) async {
    try {
      // Store as Map to avoid needing a Hive Adapter for ActivityItem
      final activityMap = {
        'type': ActivityType.project.name,
        'title': 'Project Created',
        'subtitle': '${project.name} initialized',
        'timestamp': project.createdAt.toIso8601String(),
        'projectId': project.id,
      };

      await _box.put('${project.id}_created', activityMap);
      AppLogger.info(
        'Project activity recorded (Map): ${project.id}',
        tag: 'RecentActivity',
      );
    } catch (e, stack) {
      AppLogger.error(
        'Failed to record project activity',
        tag: 'RecentActivity',
        error: e,
        stackTrace: stack,
      );
    }
  }

  @override
  void invalidateCache(String projectId) {
    // HistoryRepository already handles internal caching.
  }

  ActivityType _mapDesignToActivityType(DesignType type) {
    // Map design types to visual activity categories in Home
    switch (type) {
      case DesignType.beam:
      case DesignType.slab:
      case DesignType.column:
      case DesignType.footing:
        return ActivityType.calculator;
      case DesignType.siteLeveling:
        return ActivityType.leveling;
      case DesignType.brick:
      case DesignType.concrete:
      case DesignType.plaster:
      case DesignType.excavation:
      case DesignType.shuttering:
      case DesignType.steel:
      case DesignType.currency:
      case DesignType.siteGradient:
      case DesignType.road:
      case DesignType.irrigation:
        return ActivityType.calculator;
    }
  }
}


