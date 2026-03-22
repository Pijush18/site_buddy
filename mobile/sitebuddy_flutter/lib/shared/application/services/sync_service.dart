import 'package:site_buddy/features/structural/shared/domain/models/design_report.dart';
import 'package:site_buddy/shared/domain/repositories/history_repository.dart';
import 'package:site_buddy/core/logging/app_logger.dart';

/// SERVICE: SyncService
/// PURPOSE: Offline-first background synchronization for DesignReport history.
/// 
/// ARCHITECTURE:
/// - Repositories remain the local source of truth (Local-First).
/// - SyncService reconciles local Hive data with remote Backend data.
/// - Uses 'Latest Timestamp Wins' conflict resolution.
class SyncService {
  final HistoryRepository _repository;
  // final BackendClient _backend; // To be injected in future steps

  SyncService({
    required HistoryRepository repository,
  }) : _repository = repository;

  /// CORE: Full Synchronize Cycle
  Future<void> sync() async {
    try {
      AppLogger.info('Starting DesignReport synchronization...', tag: 'SyncService');
      
      // 1. Push Local Changes to Server
      await _pushLocalReports();
      
      // 2. Fetch Remote Updates from Server
      await _fetchRemoteReports();
      
      AppLogger.info('Synchronization complete.', tag: 'SyncService');
    } catch (e, stack) {
      AppLogger.error('Synchronization cycle failed', tag: 'SyncService', error: e, stackTrace: stack);
      // Note: We don't rethrow here to prevent blocking background workers,
      // but log it for monitoring.
    }
  }

  /// Pushes all reports where isSynced is false to the server.
  Future<void> _pushLocalReports() async {
    final unsynced = _repository.getAll().where((r) => !r.isSynced).toList();
    
    if (unsynced.isEmpty) {
      AppLogger.debug('No local changes to push.', tag: 'SyncService');
      return;
    }

    AppLogger.info('Pushing ${unsynced.length} reports to server...', tag: 'SyncService');

    for (final report in unsynced) {
      try {
        // MOCK: await _backend.uploadReport(report);
        
        // Update local report as synced
        final updatedReport = _markAsSynced(report);
        await _repository.save(updatedReport);
      } catch (e) {
        AppLogger.warning('Failed to push report ${report.id}: $e', tag: 'SyncService');
        // Continue with next report, will retry on next sync cycle
      }
    }
  }

  /// Fetches remote reports and reconciles with local Hive box.
  Future<void> _fetchRemoteReports() async {
    try {
      // MOCK: final List<DesignReport> remoteReports = await _backend.fetchAllReports();
      final List<DesignReport> remoteReports = []; // Placeholder

      if (remoteReports.isEmpty) return;

      for (final remote in remoteReports) {
        final local = _repository.getAll().where((r) => r.id == remote.id).firstOrNull;

        if (local == null) {
          // New report from another device
          await _repository.save(remote);
          AppLogger.debug('Synced new remote report: ${remote.id}', tag: 'SyncService');
        } else {
          // Conflict Resolution: Latest UpdatedAt wins
          final remoteUpdate = remote.updatedAt;
          final localUpdate = local.updatedAt;
          
          if (remoteUpdate != null && (localUpdate == null || remoteUpdate.isAfter(localUpdate))) {
            await _repository.save(remote);
            AppLogger.debug('Resolved conflict for ${remote.id}: Remote updated.', tag: 'SyncService');
          }
        }
      }
    } catch (e) {
      AppLogger.error('Failed to fetch remote reports', tag: 'SyncService', error: e);
    }
  }

  /// Helper to create a synced version of a report.
  DesignReport _markAsSynced(DesignReport report) {
    return report.copyWith(isSynced: true);
  }
}

