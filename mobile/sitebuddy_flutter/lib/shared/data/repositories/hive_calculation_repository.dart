import 'package:hive/hive.dart';
import 'package:site_buddy/features/history/domain/models/calculation_history_entry.dart';
import 'package:site_buddy/shared/domain/repositories/calculation_repository.dart';
import 'package:site_buddy/shared/domain/repositories/project_repository.dart';
import 'package:site_buddy/core/backend/backend_client.dart';
import 'package:site_buddy/core/network/connectivity_service.dart';
import 'package:site_buddy/core/logging/app_logger.dart';
import 'dart:developer' as developer;

/// UNIFIED REPOSITORY for all engineering calculations (structural + material estimators).
class HiveCalculationRepository implements CalculationRepository {
  static const String _boxName = 'calculation_history_box';

  final BackendClient? _backendClient;
  final ConnectivityService? _connectivityService;
  final ProjectRepository? _projectRepository;
  
  /// In-memory cache for optimized retrieval.
  List<CalculationHistoryEntry>? _cache;

  HiveCalculationRepository({
    BackendClient? backendClient,
    ConnectivityService? connectivityService,
    ProjectRepository? projectRepository,
  })  : _backendClient = backendClient,
        _connectivityService = connectivityService,
        _projectRepository = projectRepository;

  /// Helper to access pre-opened box (consistent with other repositories).
  Box<CalculationHistoryEntry> get _box {
    if (!Hive.isBoxOpen(_boxName)) {
      throw StateError(
        'Hive box "$_boxName" must be opened during AppInitializer',
      );
    }
    return Hive.box<CalculationHistoryEntry>(_boxName);
  }

  /// Ensures cache is populated and sorted.
  Future<List<CalculationHistoryEntry>> _getCache() async {
    if (_cache == null) {
      final box = _box;
      _cache = box.values.toList();
      _cache!.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    }
    return _cache!;
  }

  @override
  Future<void> addEntry(CalculationHistoryEntry entry) async {
    // 1. Validation
    if (entry.id.isEmpty) {
      AppLogger.error('Attempted to save CalculationHistoryEntry with empty ID', tag: 'CalcRepo');
      throw ArgumentError('Calculation ID cannot be empty');
    }

    try {
      // 2. Update Hive - await ensures write completes before logging success
      final box = _box;
      await box.put(entry.id, entry);
      
      // 3. Update Cache - only after Hive write succeeds
      final currentCache = await _getCache();
      final index = currentCache.indexWhere((e) => e.id == entry.id);
      
      if (index >= 0) {
        currentCache[index] = entry;
      } else {
        currentCache.add(entry);
      }
      currentCache.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      
      // 4. Update Project Activity
      await _projectRepository?.setLastAccessed(entry.projectId);

      // LOG INTEGRITY: Only log AFTER successful write
      developer.log('[History] Saved for project: ${entry.projectId}', name: 'HiveCalculationRepository');
      AppLogger.info('[History] Saved entry: ${entry.id} for project: ${entry.projectId}', tag: 'CalcRepo');
    } catch (e, stack) {
      AppLogger.error('Failed to add calculation entry: ${entry.id}', tag: 'CalcRepo', error: e, stackTrace: stack);
      rethrow;
    }
  }

  @override
  Future<List<CalculationHistoryEntry>> getEntriesByProject(
    String projectId,
  ) async {
    // DEBUG: Trace history fetch with project ID
    developer.log('[History] Fetch for project: $projectId', name: 'HiveCalculationRepository');
    AppLogger.debug('[History] Fetch for project: $projectId', tag: 'CalcRepo');
    final cache = await _getCache();
    final filteredEntries = cache.where((e) => e.projectId == projectId).toList();
    AppLogger.debug('[History] Found ${filteredEntries.length} entries for project: $projectId', tag: 'CalcRepo');
    return filteredEntries;
  }

  @override
  Future<CalculationHistoryEntry?> getEntryById(String id) async {
    final cache = await _getCache();
    try {
      return cache.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> deleteEntry(String id) async {
    try {
      // 1. Update Hive
      final box = _box;
      await box.delete(id);
      
      // 2. Update Cache
      final cache = await _getCache();
      cache.removeWhere((e) => e.id == id);
    } catch (e) {
      developer.log('HiveCalculationRepository.deleteEntry failed', error: e);
      rethrow;
    }
  }

  @override
  /// Deletes ALL calculation history entries for a specific project.
  /// Called when a project is deleted to prevent orphaned data.
  Future<void> deleteByProjectId(String projectId) async {
    try {
      // 1. Get all entries for this project
      final entriesToDelete = _cache?.where((e) => e.projectId == projectId).toList() ?? [];
      
      if (entriesToDelete.isEmpty) {
        AppLogger.debug('No history entries found for project: $projectId', tag: 'CalcRepo');
        return;
      }

      // 2. Delete from Hive
      final box = _box;
      for (final entry in entriesToDelete) {
        await box.delete(entry.id);
      }
      
      // 3. Update Cache
      _cache?.removeWhere((e) => e.projectId == projectId);
      
      AppLogger.info('Deleted ${entriesToDelete.length} history entries for project: $projectId', tag: 'CalcRepo');
    } catch (e, stack) {
      AppLogger.error('Failed to delete history for project: $projectId', tag: 'CalcRepo', error: e, stackTrace: stack);
      rethrow;
    }
  }

  @override
  Future<void> syncCalculations(String projectId) async {
    if (_backendClient == null || _connectivityService == null) return;
    
    if (!await _connectivityService.isOnline) {
      developer.log('Calculation sync aborted: Device is offline', name: 'HiveCalculationRepository');
      return;
    }

    try {
      final localEntries = await getEntriesByProject(projectId);
      if (localEntries.isEmpty) return;

      final remoteEntries = await _backendClient.fetchCalculations(projectId);
      final remoteIds = remoteEntries.map((e) => e.id).toSet();

      int syncCount = 0;
      for (final entry in localEntries) {
        if (!remoteIds.contains(entry.id)) {
          await _backendClient.createCalculation(entry);
          syncCount++;
        }
      }

      developer.log('Calculation sync complete: $syncCount records uploaded for project $projectId', name: 'HiveCalculationRepository');
    } catch (e) {
      developer.log('Calculation cloud sync failed: $e', name: 'HiveCalculationRepository', error: e);
    }
  }
}

