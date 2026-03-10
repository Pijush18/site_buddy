/// FILE HEADER
/// ----------------------------------------------
/// File: activity_item.dart
/// Feature: home
/// Layer: domain
///
/// PURPOSE:
/// Core domain entity for visualizing recent global actions in the dashboard.
///
/// RESPONSIBILITIES:
/// - Holds structured data about a user action.
/// - Agnostic to the specific feature's internal data model.
///
/// DEPENDENCIES:
/// - ActivityType enum.
///
/// FUTURE IMPROVEMENTS:
/// - Add deep link navigation references or IDs to route directly.
/// ----------------------------------------------
library;


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

  const ActivityItem({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.timestamp,
  });
}
