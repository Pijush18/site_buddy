import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/shared/domain/models/calculation_history_entry.dart';
import 'package:site_buddy/shared/domain/repositories/calculation_repository.dart';
import 'package:site_buddy/shared/data/repositories/hive_calculation_repository.dart';
import 'package:site_buddy/shared/data/repositories/hive_history_repository.dart';
import 'package:site_buddy/shared/domain/repositories/history_repository.dart';
import 'package:site_buddy/shared/domain/models/design/design_report.dart';
import 'package:site_buddy/core/backend/backend_client.dart';
import 'package:site_buddy/core/network/connectivity_service.dart';
import 'package:site_buddy/shared/application/providers/project_providers.dart';

/// Provide the unified history repository.
final historyRepositoryProvider = Provider<HistoryRepository>(
  (ref) => HiveHistoryRepository(),
);

/// Provide a feed of the latest 5 design reports for the active project.
final recentReportsProvider = FutureProvider<List<DesignReport>>((ref) async {
  final repo = ref.watch(historyRepositoryProvider);
  
  // Watch project session for reactivity
  final projectSession = ref.watch(projectSessionServiceProvider);
  final activeProject = projectSession.getActiveProject();
  
  // If no active project, return empty
  if (activeProject == null) {
    return [];
  }
  
  // Filter by active project
  final reports = repo.getReportsByProject(activeProject.id);
  return reports.take(5).toList();
});

/// Legacy provider for broader calculation history (Calculators/Logs).
final sharedHistoryRepositoryProvider = Provider<CalculationRepository>(
  (ref) {
    final backend = ref.watch(backendClientProvider);
    final connectivity = ref.watch(connectivityServiceProvider);
    return HiveCalculationRepository(
      backendClient: backend,
      connectivityService: connectivity,
    );
  },
);

/// FIX: Get history entries from session - Session-based architecture
/// Watches projectSessionServiceProvider for reactivity - auto-updates when project switches
/// NOTE: Removed autoDispose to prevent provider disposal on navigation,
/// which was causing inconsistent history when switching projects.
final projectHistoryProvider =
    FutureProvider<List<CalculationHistoryEntry>>((ref) {
      // Session-based: Watch the project session service for reactivity
      final projectSession = ref.watch(projectSessionServiceProvider);
      final activeProject = projectSession.getActiveProject();
      
      // If no active project, return empty list
      if (activeProject == null) {
        return Future.value([]);
      }
      
      final projectId = activeProject.id;
      // DEBUG: Log when history is being fetched
      return ref
          .read(sharedHistoryRepositoryProvider)
          .getEntriesByProject(projectId);
    });
