/// FILE HEADER
/// ----------------------------------------------
/// File: home_state.dart
/// Feature: home
/// Layer: application
///
/// PURPOSE:
/// State container for the Home Dashboard.
///
/// RESPONSIBILITIES:
/// - Holds the aggregated list of global activities.
/// - Immutable structure.
///
/// DEPENDENCIES:
/// - ActivityItem domain model.
///
/// FUTURE IMPROVEMENTS:
/// - Add isLoading or Error states when fetching from real databases.
/// - Add pagination cursors.
/// ----------------------------------------------
library;


import 'package:site_buddy/features/home/domain/models/activity_item.dart';

/// CLASS: HomeState
/// PURPOSE: State representing the current UI data for the HomeScreen.
class HomeState {
  /// The timeline of aggregated cross-feature actions.
  final List<ActivityItem> recentActivities;

  const HomeState({required this.recentActivities});

  /// METHOD: initial
  /// PURPOSE: Factory for an empty starting state.
  factory HomeState.initial() {
    return const HomeState(recentActivities: []);
  }

  /// METHOD: copyWith
  /// PURPOSE: Standard immutable state cloner.
  HomeState copyWith({List<ActivityItem>? recentActivities}) {
    return HomeState(
      recentActivities: recentActivities ?? this.recentActivities,
    );
  }
}



