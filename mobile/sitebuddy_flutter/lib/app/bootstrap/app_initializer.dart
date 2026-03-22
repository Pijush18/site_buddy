import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/core/providers/settings_provider.dart';
import 'package:site_buddy/core/services/data_migration_service.dart';
import 'package:site_buddy/shared/domain/models/project.dart';
import 'package:site_buddy/shared/domain/models/project_status.dart';
import 'package:site_buddy/features/level_log/data/models/level_entry_model.dart';
import 'package:site_buddy/features/level_log/data/models/level_method_model.dart';
import 'package:site_buddy/features/level_log/data/models/level_log_session_model.dart';
import 'package:site_buddy/core/branding/branding_model.dart';
import 'package:site_buddy/core/network/connectivity_service.dart';
import 'package:site_buddy/core/backend/backend_client.dart';
import 'package:site_buddy/core/services/knowledge_service.dart';
import 'package:site_buddy/shared/application/services/data_migration_service.dart' as project_migration;
import 'package:site_buddy/shared/application/providers/project_providers.dart';
import 'package:site_buddy/shared/domain/models/calculation_history_entry.dart';
import 'package:site_buddy/shared/domain/models/design/design_report.dart'; // Contains DesignType


/// Provider to track the initialization state of the application.
final initializationProvider = StateProvider<bool>((ref) => false);

/// Class responsible for initializing application services.
class AppInitializer {
  final ProviderContainer container;

  AppInitializer(this.container);

  /// Initializes essential application services.
  Future<void> initialize() async {
    // 1. Initialize Hive
    await Hive.initFlutter();

    // 2. Register Hive Adapters
    if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(ProjectAdapter());
    if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(ProjectStatusAdapter());
    if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter(LevelEntryModelAdapter());
    if (!Hive.isAdapterRegistered(3)) Hive.registerAdapter(LevelLogSessionModelAdapter());
    if (!Hive.isAdapterRegistered(4)) Hive.registerAdapter(LevelMethodModelAdapter());
    if (!Hive.isAdapterRegistered(5)) Hive.registerAdapter(BrandingModelAdapter());
    
    // History & Design Extensions (typeId 200+)
    if (!Hive.isAdapterRegistered(200)) {
      Hive.registerAdapter(CalculationHistoryEntryAdapter());
    }
    if (!Hive.isAdapterRegistered(201)) {
      Hive.registerAdapter(CalculationTypeAdapter());
    }

    // Standardized Design Reports (typeId 210+)
    if (!Hive.isAdapterRegistered(210)) {
      Hive.registerAdapter(DesignReportAdapter());
    }
    if (!Hive.isAdapterRegistered(211)) {
      Hive.registerAdapter(DesignTypeAdapter());
    }

    // ── Open Essential Boxes ──
    await Hive.openBox<DesignReport>('history_reports_box');
    await Hive.openBox<CalculationHistoryEntry>('calculation_history_box');
    await Hive.openBox<Project>('projects_box');
    await Hive.openBox('project_activities_box');

    // ── Run Project System Migration ──
    await project_migration.DataMigrationService.migrateAll();

    // 3. Initialize Settings Provider to load data
    container.read(settingsProvider);

    // 4. Initialize Network Connectivity Service
    container.read(connectivityServiceProvider);

    // 5. Initialize Backend Client
    container.read(backendClientProvider);

    // 6. Initialize Knowledge Service
    await container.read(knowledgeServiceProvider).loadKnowledge();

    // 7. Prime Project Session
    final projectRepo = container.read(projectRepositoryProvider);
    final sessionService = container.read(projectSessionServiceProvider);
    
    final projects = await projectRepo.getProjects();
    if (projects.isNotEmpty) {
      // Set the most recently accessed project as active
      await sessionService.setActiveProject(projects.first);
    }

    // 8. Run Legacy SharedPreferences to Hive Migration
    await container.read(dataMigrationServiceProvider).runMigration();


    // Mark initialization as complete
    container.read(initializationProvider.notifier).state = true;
  }
}



