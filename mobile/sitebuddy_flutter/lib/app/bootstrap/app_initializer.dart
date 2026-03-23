import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:site_buddy/core/logging/app_logger.dart';

import 'package:site_buddy/core/services/knowledge_service.dart';
import 'package:site_buddy/core/services/data_migration_service.dart';
import 'package:site_buddy/core/network/connectivity_service.dart';
import 'package:site_buddy/core/backend/backend_client.dart';
import 'package:site_buddy/shared/application/providers/project_providers.dart';
import 'package:site_buddy/features/history/domain/models/calculation_history_entry.dart';
import 'package:site_buddy/features/project/domain/models/project.dart';
import 'package:site_buddy/features/project/domain/models/project_status.dart';
import 'package:site_buddy/features/level_log/data/models/level_entry_model.dart';
import 'package:site_buddy/features/level_log/data/models/level_method_model.dart';
import 'package:site_buddy/features/level_log/data/models/level_log_session_model.dart';
import 'package:site_buddy/core/branding/branding_model.dart';
import 'package:site_buddy/features/structural/shared/domain/models/design_report.dart';
import 'package:site_buddy/shared/application/services/data_migration_service.dart' as project_migration;

/// Provider to track the initialization state of the application.
/// 
/// [SIMPLIFIED DI] - Uses standard provider pattern with Ref.
final initializationProvider = StateProvider<bool>((ref) => false);

/// Async provider for app initialization.
/// 
/// Call `ref.watch(appInitializerProvider)` once in a splash screen
/// to ensure initialization completes before navigating to main content.
/// 
/// Usage:
/// ```dart
/// final initAsync = ref.watch(appInitializerProvider);
/// return initAsync.when(
///   data: (_) => HomeScreen(),
///   loading: () => SplashScreen(),
///   error: (e, _) => ErrorScreen(error: e),
/// );
/// ```
final appInitializerProvider = FutureProvider<void>((ref) async {
  await _initializeApp(ref);
});

/// Internal initialization logic using Ref instead of ProviderContainer
Future<void> _initializeApp(Ref ref) async {
  // 1. Initialize Hive
  await Hive.initFlutter();
  AppLogger.debug('Hive initialized', tag: 'AppInitializer');

  // 2. Register Hive Adapters
  await _registerHiveAdapters();

  // 3. Open Hive boxes
  await _openHiveBoxes();

  // 4. Run migrations
  await _runMigrations(ref);

  // 5. Initialize services (trigger lazy loading)
  ref.read(connectivityServiceProvider);
  ref.read(backendClientProvider);
  final knowledgeService = ref.read(knowledgeServiceProvider);
  await knowledgeService.loadKnowledge();

  // 6. Prime project session
  await _primeProjectSession(ref);

  // 7. Mark as complete
  ref.read(initializationProvider.notifier).state = true;
  
  AppLogger.debug('App initialization complete', tag: 'AppInitializer');
}

/// Register all Hive type adapters
Future<void> _registerHiveAdapters() async {
  // Core models
  if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(ProjectAdapter());
  if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(ProjectStatusAdapter());
  if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter(LevelEntryModelAdapter());
  if (!Hive.isAdapterRegistered(3)) Hive.registerAdapter(LevelLogSessionModelAdapter());
  if (!Hive.isAdapterRegistered(4)) Hive.registerAdapter(LevelMethodModelAdapter());
  if (!Hive.isAdapterRegistered(5)) Hive.registerAdapter(BrandingModelAdapter());
  
  // History models (typeId 200+)
  if (!Hive.isAdapterRegistered(200)) {
    Hive.registerAdapter(CalculationHistoryEntryAdapter());
  }
  if (!Hive.isAdapterRegistered(201)) {
    Hive.registerAdapter(CalculationTypeAdapter());
  }

  // Design reports (typeId 20+)
  if (!Hive.isAdapterRegistered(20)) {
    Hive.registerAdapter(DesignTypeAdapter());
  }
  if (!Hive.isAdapterRegistered(21)) {
    Hive.registerAdapter(DesignReportAdapter());
  }
  
  AppLogger.debug('Hive adapters registered', tag: 'AppInitializer');
}

/// Open required Hive boxes
Future<void> _openHiveBoxes() async {
  await Hive.openBox<DesignReport>('history_reports_box');
  await Hive.openBox<CalculationHistoryEntry>('calculation_history_box');
  await Hive.openBox<Project>('projects_box');
  await Hive.openBox('project_activities_box');
  AppLogger.debug('Hive boxes opened', tag: 'AppInitializer');
}

/// Run data migrations
Future<void> _runMigrations(Ref ref) async {
  // Run project system migration
  await project_migration.DataMigrationService.migrateAll();
  
  // Run SharedPreferences to Hive migration
  await ref.read(dataMigrationServiceProvider).runMigration();
  AppLogger.debug('Migrations complete', tag: 'AppInitializer');
}

/// Prime the project session with the most recent project
Future<void> _primeProjectSession(Ref ref) async {
  final projectRepo = ref.read(projectRepositoryProvider);
  final sessionService = ref.read(projectSessionServiceProvider);
  
  final projects = await projectRepo.getProjects();
  if (projects.isNotEmpty) {
    await sessionService.setActiveProject(projects.first);
    AppLogger.debug('Session Restored: ${projects.first.id}', tag: 'AppInitializer');
  }
}
