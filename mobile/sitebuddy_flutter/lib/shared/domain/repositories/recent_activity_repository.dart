import 'package:site_buddy/features/home/domain/models/activity_item.dart';
import 'package:site_buddy/features/project/domain/models/project.dart';

/// REPOSITORY INTERFACE: RecentActivityRepository
/// PURPOSE: Contract for fetching summarized activity feed filtered by project.
abstract class RecentActivityRepository {
  /// FETCH: Returns a list of the latest activities for a specific project.
  Future<List<ActivityItem>> getRecentActivities(String projectId, {int limit = 5});

  /// ADD: Records a project-level activity (e.g., creation).
  Future<void> addProject(Project project);

  /// INVALIDATE: Clears any internal caches for a specific project.
  void invalidateCache(String projectId);
}

