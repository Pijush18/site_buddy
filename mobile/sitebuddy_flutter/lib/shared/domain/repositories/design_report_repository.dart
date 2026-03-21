import 'package:site_buddy/shared/domain/models/design/design_report.dart';

/// REPOSITORY INTERFACE: DesignReportRepository
/// PURPOSE: Contract for managing standardized calculation outputs.
abstract class DesignReportRepository {
  /// PERSISTS a complete design output.
  Future<void> saveReport(DesignReport report);

  /// RETRIEVES all reports linked to a specific project.
  Future<List<DesignReport>> getReportsByProject(String projectId);

  /// RETRIEVES a single report by unique identifier.
  Future<DesignReport?> getReportById(String id);

  /// REMOVES a report from the system.
  Future<void> deleteReport(String id);
  
  /// RETRIEVES all reports historically saved.
  Future<List<DesignReport>> getAllReports();
}
