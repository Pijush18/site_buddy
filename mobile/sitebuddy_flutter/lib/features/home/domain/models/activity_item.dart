import 'package:site_buddy/features/home/domain/models/activity_type.dart';

/// CLASS: ActivityItem
/// PURPOSE: Represents a single item in the Recent Activity feed.
/// WHY: Provides a common interface for different features to report their status to Home.
class ActivityItem {
  /// Defines the visual icon and logical source.
  final ActivityType type;

  /// Primary headline (e.g., "Last Calculation").
  final String title;

  /// Secondary details (e.g., "Concrete Vol: 4.5 m³").
  final String subtitle;

  /// Exact time the activity occurred, used for sorting.
  final DateTime timestamp;
  
  final String? deepLink;
  
  final String? projectId;

  const ActivityItem({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.timestamp,
    this.deepLink,
    this.projectId,
  });
}
