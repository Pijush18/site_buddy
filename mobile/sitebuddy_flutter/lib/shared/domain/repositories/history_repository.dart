import 'package:site_buddy/shared/domain/models/design/design_report.dart';

/// REPOSITORY INTERFACE: HistoryRepository
/// PURPOSE: Contract for managing the global persistent history of all calculations.
abstract class HistoryRepository {
  /// SAVES a report to history. Overwrites if a report with the same ID exists.
  Future<void> save(DesignReport report);

  /// RETRIEVES all saved reports, sorted by timestamp (newest first).
  List<DesignReport> getAll();

  /// RETRIEVES reports filtered by a specific project ID.
  List<DesignReport> getReportsByProject(String projectId);

  /// REMOVES a specific report from history by its unique identifier.
  Future<void> delete(String id);

  /// CLEARS all historical records from the system.
  Future<void> clear();

  /// CHECKS if a specific report already exists in history.
  bool exists(String id);
}
