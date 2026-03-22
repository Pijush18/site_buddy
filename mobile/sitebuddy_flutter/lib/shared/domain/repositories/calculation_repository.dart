import 'package:site_buddy/shared/domain/models/calculation_history_entry.dart';

abstract class CalculationRepository {
  Future<void> addEntry(CalculationHistoryEntry entry);
  Future<List<CalculationHistoryEntry>> getEntriesByProject(String projectId);
  Future<CalculationHistoryEntry?> getEntryById(String id);
  Future<void> deleteEntry(String id);
  
  /// Deletes ALL calculation history entries for a specific project.
  /// Called when a project is deleted to prevent orphaned data.
  Future<void> deleteByProjectId(String projectId);
  
  Future<void> syncCalculations(String projectId);
}
