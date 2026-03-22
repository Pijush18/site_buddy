import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/features/home/application/controllers/home_state.dart';
import 'package:site_buddy/shared/application/providers/project_providers.dart';
import 'package:site_buddy/core/logging/app_logger.dart';

/// PROVIDER: homeProvider
/// PURPOSE: Allows presentation layer to read and watch HomeState.
final homeProvider = NotifierProvider<HomeController, HomeState>(
  HomeController.new,
);

/// CLASS: HomeController
/// PURPOSE: StateNotifier managing the aggregation of application activity.
/// Refreshes automatically when the active project switches.
class HomeController extends Notifier<HomeState> {
  
  @override
  HomeState build() {
    // 1. Listen to ProjectSessionService for changes
    // This ensures HomeController rebuilds whenever setActiveProject is called
    final session = ref.watch(projectSessionServiceProvider);
    final projectId = session.getActiveProjectId();
    
    AppLogger.info('HomeController building for Project: $projectId', tag: 'HomeCtrl');

    // 2. Initial Activities
    // Note: build() cannot be async, so we use a side-effect to load data
    _loadActivities(projectId);

    return const HomeState(recentActivities: []);
  }

  /// METHOD: _loadActivities
  /// PURPOSE: Asynchronously fetches and updates the state with real project data.
  Future<void> _loadActivities(String projectId) async {
    try {
      final repository = ref.read(recentActivityRepositoryProvider);
      
      // Fetch latest activities (limit to top 5)
      final activities = await repository.getRecentActivities(projectId);
      
      // Sort is handled by repository but ensuring here for safety
      activities.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      state = HomeState(recentActivities: activities);
      
      AppLogger.info('HomeController loaded ${activities.length} activities for $projectId', tag: 'HomeCtrl');
    } catch (e, stack) {
      AppLogger.error('Failed to load home activities', tag: 'HomeCtrl', error: e, stackTrace: stack);
    }
  }

  /// REFRESH: Manual refresh trigger (e.g., Pull-to-refresh)
  Future<void> refresh() async {
    final session = ref.read(projectSessionServiceProvider);
    await _loadActivities(session.getActiveProjectId());
  }
}
