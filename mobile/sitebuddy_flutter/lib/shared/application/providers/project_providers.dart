import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/shared/application/services/project_session_service.dart';
import 'package:site_buddy/features/project/presentation/providers/project_providers.dart';

import 'package:site_buddy/shared/domain/repositories/recent_activity_repository.dart';
import 'package:site_buddy/shared/data/repositories/hive_recent_activity_repository.dart';
import 'package:site_buddy/shared/presentation/providers/history_providers.dart';

// RE-EXPORT active project provider for convenience
export 'active_project_provider.dart';
export 'package:site_buddy/features/project/presentation/providers/project_providers.dart';

/// PROVIDER: projectSessionServiceProvider
/// PURPOSE: Central access point for managing the active project session.
/// USES: ChangeNotifierProvider to allow notifications on project switch.
final projectSessionServiceProvider =
    ChangeNotifierProvider<ProjectSessionService>((ref) {
      final repository = ref.watch(projectRepositoryProvider);
      return ProjectSessionService(repository: repository);
    });

/// PROVIDER: activeProjectIdProvider
/// PURPOSE: Reactive provider that returns the active project ID.
/// Watches session changes and auto-updates when project switches.
/// THROWS: StateError if no active project (fail-fast)
final activeProjectIdProvider = Provider<String>((ref) {
  ref.watch(projectSessionServiceProvider);
  return ref.read(projectSessionServiceProvider).getActiveProjectId();
});

/// PROVIDER: recentActivityRepositoryProvider
/// PURPOSE: Standardized access to project-filtered activity feed.
final recentActivityRepositoryProvider = Provider<RecentActivityRepository>((
  ref,
) {
  final historyRepo = ref.watch(historyRepositoryProvider);
  return HiveRecentActivityRepository(historyRepository: historyRepo);
});
