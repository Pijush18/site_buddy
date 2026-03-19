import 'package:hive/hive.dart';
import 'package:site_buddy/shared/domain/models/calculation_history_entry.dart';
import 'package:site_buddy/shared/domain/repositories/history_repository.dart';
import 'package:site_buddy/core/backend/backend_client.dart';
import 'package:site_buddy/core/network/connectivity_service.dart';
import 'dart:developer' as developer;

class HiveHistoryRepository implements HistoryRepository {
  static const String _boxName = 'calculation_history_box';

  final BackendClient? _backendClient;
  final ConnectivityService? _connectivityService;

  HiveHistoryRepository({
    BackendClient? backendClient,
    ConnectivityService? connectivityService,
  })  : _backendClient = backendClient,
        _connectivityService = connectivityService;

  @override
  Future<void> addEntry(CalculationHistoryEntry entry) async {
    final box = await Hive.openBox<CalculationHistoryEntry>(_boxName);
    await box.put(entry.id, entry);
    await box.close();
  }

  @override
  Future<List<CalculationHistoryEntry>> getEntriesByProject(
    String projectId,
  ) async {
    final box = await Hive.openBox<CalculationHistoryEntry>(_boxName);
    final entries = box.values.where((e) => e.projectId == projectId).toList();
    await box.close();
    return entries;
  }

  @override
  Future<CalculationHistoryEntry?> getEntryById(String id) async {
    final box = await Hive.openBox<CalculationHistoryEntry>(_boxName);
    final entry = box.get(id);
    await box.close();
    return entry;
  }

  @override
  Future<void> deleteEntry(String id) async {
    final box = await Hive.openBox<CalculationHistoryEntry>(_boxName);
    await box.delete(id);
    await box.close();
  }

  @override
  Future<void> syncCalculations(String projectId) async {
    // 1. Guard against missing dependencies or offline status
    if (_backendClient == null || _connectivityService == null) return;
    
    if (!await _connectivityService.isOnline) {
      developer.log('Calculation sync aborted: Device is offline', name: 'HiveHistoryRepository');
      return;
    }

    try {
      // 2. Fetch local calculations for this project
      final localEntries = await getEntriesByProject(projectId);
      if (localEntries.isEmpty) return;

      // 3. Fetch remote calculations from backend
      final remoteEntries = await _backendClient.fetchCalculations(projectId);
      final remoteIds = remoteEntries.map((e) => e.id).toSet();

      // 4. Upload missing calculations
      int syncCount = 0;
      for (final entry in localEntries) {
        if (!remoteIds.contains(entry.id)) {
          await _backendClient.createCalculation(entry);
          syncCount++;
        }
      }

      developer.log('Calculation sync complete: $syncCount records uploaded for project $projectId', name: 'HiveHistoryRepository');
    } catch (e) {
      // Offline-first: log failure but don't crash the user flow
      developer.log('Calculation cloud sync failed: $e', name: 'HiveHistoryRepository', error: e);
    }
  }
}

// Riverpod provider moved to shared/presentation/providers/history_providers.dart
