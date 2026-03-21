import 'package:hive_flutter/hive_flutter.dart';
import 'package:site_buddy/shared/domain/models/design/design_report.dart';
import 'package:site_buddy/shared/domain/repositories/design_report_repository.dart';

/// REPOSITORY IMPLEMENTATION: HiveDesignReportRepository
/// PURPOSE: High-performance local persistence for standardized reports.
class HiveDesignReportRepository implements DesignReportRepository {
  static const String _boxName = 'design_reports_box';

  @override
  Future<void> saveReport(DesignReport report) async {
    final box = await Hive.openBox<DesignReport>(_boxName);
    await box.put(report.id, report);
  }

  @override
  Future<List<DesignReport>> getReportsByProject(String projectId) async {
    final box = await Hive.openBox<DesignReport>(_boxName);
    return box.values.where((r) => r.projectId == projectId).toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  @override
  Future<DesignReport?> getReportById(String id) async {
    final box = await Hive.openBox<DesignReport>(_boxName);
    return box.get(id);
  }

  @override
  Future<void> deleteReport(String id) async {
    final box = await Hive.openBox<DesignReport>(_boxName);
    await box.delete(id);
  }

  @override
  Future<List<DesignReport>> getAllReports() async {
    final box = await Hive.openBox<DesignReport>(_boxName);
    return box.values.toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }
}
