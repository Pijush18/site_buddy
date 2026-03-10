import 'package:site_buddy/shared/domain/models/calculation_history_entry.dart';

abstract class HistoryRepository {
  Future<void> addEntry(CalculationHistoryEntry entry);
  Future<List<CalculationHistoryEntry>> getEntriesByProject(String projectId);
  Future<CalculationHistoryEntry?> getEntryById(String id);
  Future<void> deleteEntry(String id);
}
