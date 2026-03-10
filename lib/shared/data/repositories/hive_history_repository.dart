import 'package:hive/hive.dart';
import 'package:site_buddy/shared/domain/models/calculation_history_entry.dart';
import 'package:site_buddy/shared/domain/repositories/history_repository.dart';

class HiveHistoryRepository implements HistoryRepository {
  static const String _boxName = 'calculation_history_box';

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
}

// Riverpod provider moved to shared/presentation/providers/history_providers.dart
