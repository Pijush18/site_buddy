import 'package:site_buddy/shared/domain/models/calculation_history_entry.dart';

abstract class CalculationRepository {
  Future<void> addEntry(CalculationHistoryEntry entry);
  Future<List<CalculationHistoryEntry>> getEntriesByProject(String projectId);
  Future<CalculationHistoryEntry?> getEntryById(String id);
  Future<void> deleteEntry(String id);
  Future<void> syncCalculations(String projectId);
}
