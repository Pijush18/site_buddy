import 'dart:io';
import 'package:site_buddy/shared/domain/models/site_report.dart';

abstract class ReportRepository {
  Future<String> uploadReport(SiteReport report, File file);
  Future<List<SiteReport>> getReportsByProject(String projectId);
}



