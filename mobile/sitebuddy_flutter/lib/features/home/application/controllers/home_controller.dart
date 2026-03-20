/// FILE HEADER
/// ----------------------------------------------
/// File: home_controller.dart
/// Feature: home
/// Layer: application
///
/// PURPOSE:
/// Aggregate activities from different features into a unified state for the Home Dashboard.
///
/// RESPONSIBILITIES:
/// - Connects to diverse data sources (Calculator, Leveling, Project).
/// - Transforms models into ActivityItem entities.
/// - Sorts and manages the state data.
///
/// DEPENDENCIES:
/// - Riverpod for Notifier lifecycle and DI.
/// - HomeState and Activity models.
///
library;

/// - Connect real feature providers instead of using mocks.
/// - Add pagination logic.
/// - Add AI suggestions based on recent patterns.
/// ----------------------------------------------


import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/features/home/domain/models/activity_type.dart';
import 'package:site_buddy/features/home/domain/models/activity_item.dart';
import 'package:site_buddy/features/home/application/controllers/home_state.dart';

/// PROVIDER: homeProvider
/// PURPOSE: Allows presentation layer to read and watch HomeState.
final homeProvider = NotifierProvider<HomeController, HomeState>(
  HomeController.new,
);

/// CLASS: HomeController
/// PURPOSE: StateNotifier managing the aggregation of application activity.
class HomeController extends Notifier<HomeState> {
  /// METHOD: build
  /// PURPOSE: Initializes the state of the controller.
  @override
  HomeState build() {
    // Generate initial activities immediately on mount.
    final activities = _buildActivities();
    return HomeState(recentActivities: activities);
  }

  /// METHOD: _buildActivities
  /// PURPOSE: Mocks data gathering and aggregation from sub-features.
  /// WHY: Provides structured timeline data mapped to the ActivityItem entity.
  List<ActivityItem> _buildActivities() {
    // In the future this will read from `ref.watch(projectProvider)` etc.

    final activities = <ActivityItem>[
      ActivityItem(
        type: ActivityType.calculator,
        title: 'Last Calculation',
        subtitle: 'Concrete Vol: 4.5 m³',
        timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
      ),
      ActivityItem(
        type: ActivityType.project,
        title: 'Last Project',
        subtitle: 'Bridge Pier A - In Progress',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      ActivityItem(
        type: ActivityType.leveling,
        title: 'Leveling Data',
        subtitle: 'RL: 104.22m',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];

    // Sort descending (newest first).
    activities.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return activities;
  }
}



