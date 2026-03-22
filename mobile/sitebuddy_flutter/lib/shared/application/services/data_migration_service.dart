import 'package:hive/hive.dart';
import 'package:site_buddy/shared/domain/models/project_status.dart';
import 'package:site_buddy/shared/domain/models/design/design_report.dart'; // Contains DesignType
import 'package:site_buddy/shared/domain/models/calculation_history_entry.dart';
import 'package:site_buddy/shared/domain/models/project.dart';
import 'package:site_buddy/core/logging/app_logger.dart';

/// SERVICE: DataMigrationService
/// PURPOSE: Ensures data consistency across architectural migrations.
/// - Handles Project System transition by assigning legacy data to a default project.
/// - Cleans up corrupted or orphaned records.
class DataMigrationService {
  static const String _defaultProjectId = 'default_project_001';
  static const String _defaultProjectName = 'My Project';

  /// Primary migration runner. Should be called during App Initialization.
  static Future<void> migrateAll() async {
    AppLogger.info('Starting data migration audit...', tag: 'Migration');
    final stopwatch = Stopwatch()..start();

    try {
      await _ensureDefaultProject();
      final reportStats = await _migrateDesignReports();
      final historyStats = await _migrateCalculationHistory();

      stopwatch.stop();
      AppLogger.info(
        'Migration completed in ${stopwatch.elapsedMilliseconds}ms. '
        'Reports: ${reportStats.migrated}/${reportStats.total}, '
        'History: ${historyStats.migrated}/${historyStats.total}',
        tag: 'Migration',
      );
    } catch (e, stack) {
      AppLogger.error('Critical failure during data migration', tag: 'Migration', error: e, stackTrace: stack);
    }
  }

  /// 1. Ensures the Default Project exists in the system.
  static Future<void> _ensureDefaultProject() async {
    final box = await Hive.openBox<Project>('projects_box');
    
    if (!box.containsKey(_defaultProjectId)) {
      AppLogger.info('Creating default project context...', tag: 'Migration');
      final now = DateTime.now();
      final defaultProj = Project(
        id: _defaultProjectId,
        name: _defaultProjectName,
        location: 'Default Location',
        status: ProjectStatus.active,
        createdAt: now,
        updatedAt: now,
        lastAccessedAt: now,
        logsCount: 0,
        calculationsCount: 0,
      );
      await box.put(_defaultProjectId, defaultProj);
    }
  }

  /// 2. Migrates DesignReports to ensure non-null projectId.
  static Future<_MigrationStats> _migrateDesignReports() async {
    final box = await Hive.openBox<DesignReport>('history_reports_box');
    int migrated = 0;
    int corrupted = 0;

    for (var key in box.keys) {
      final report = box.get(key);
      if (report == null) continue;

      bool needsUpdate = false;
      String? updatedId = report.id;
      
      // Fix missing ID
      if (updatedId.isEmpty) {
        updatedId = key.toString();
        needsUpdate = true;
      }

      // Fix legacy projectId (null or empty)
      // Note: Since we changed DesignReport constructor to require projectId,
      // entries in Hive might still have null at index 3 if saved with old model.
      // Hive allows this, but reading it might return null.
      
      // We check the internal state - but since the field is now 'required',
      // we must ensure it's not empty string or some placeholder.
      if (report.projectId.isEmpty || report.projectId == 'null') {
        needsUpdate = true;
      }

      if (needsUpdate) {
        final updatedReport = report.copyWith(
          id: updatedId,
          projectId: report.projectId.isEmpty ? _defaultProjectId : report.projectId,
          updatedAt: report.updatedAt,
        );
        await box.put(key, updatedReport);
        migrated++;
      }
    }
    return _MigrationStats(box.length, migrated, corrupted);
  }

  /// 3. Migrates CalculationHistoryEntry to ensure non-null projectId.
  static Future<_MigrationStats> _migrateCalculationHistory() async {
    final box = await Hive.openBox<CalculationHistoryEntry>('calculation_history_box');
    int migrated = 0;
    int corrupted = 0;

    for (var key in box.keys) {
      final entry = box.get(key);
      if (entry == null) continue;

      bool needsUpdate = false;
      
      // Fix missing projectId
      if (entry.projectId.isEmpty || entry.projectId == 'null') {
        needsUpdate = true;
      }

      // Cleanup invalid timestamps (e.g. 1970)
      if (entry.timestamp.year < 2020) {
        needsUpdate = true;
      }

      if (needsUpdate) {
        final updatedEntry = entry.copyWith(
          projectId: entry.projectId.isEmpty ? _defaultProjectId : entry.projectId,
          timestamp: entry.timestamp.year < 2020 ? DateTime.now() : entry.timestamp,
        );
        await box.put(key, updatedEntry);
        migrated++;
      }
    }
    return _MigrationStats(box.length, migrated, corrupted);
  }
}

class _MigrationStats {
  final int total;
  final int migrated;
  final int corrupted;
  _MigrationStats(this.total, this.migrated, this.corrupted);
}
