import 'dart:io';
import 'dart:developer' as developer;
import 'package:site_buddy/shared/domain/models/site_report.dart';
import 'package:site_buddy/features/reports/domain/repositories/report_repository.dart';
import 'package:site_buddy/core/backend/backend_client.dart';
import 'package:site_buddy/core/network/connectivity_service.dart';

class ReportRepositoryImpl implements ReportRepository {
  final BackendClient _backendClient;
  final ConnectivityService _connectivityService;

  ReportRepositoryImpl({
    required BackendClient backendClient,
    required ConnectivityService connectivityService,
  })  : _backendClient = backendClient,
        _connectivityService = connectivityService;

  @override
  Future<String> uploadReport(SiteReport report, File file) async {
    // 1. Connectivity check
    if (!await _connectivityService.isOnline) {
      developer.log('Report upload aborted: Device is offline', name: 'ReportRepository');
      return '';
    }

    try {
      // 2. Network Check & Upload
      final fileUrl = await _backendClient.uploadReport(
        projectId: report.projectId,
        file: file,
      );
      
      developer.log('Report uploaded successfully: $fileUrl', name: 'ReportRepository');
      return fileUrl;
    } catch (e) {
      // 3. Fault Tolerance
      developer.log('Report cloud upload failed: $e', name: 'ReportRepository', error: e);
      return '';
    }
  }

  @override
  Future<List<SiteReport>> getReportsByProject(String projectId) async {
    try {
      if (!await _connectivityService.isOnline) return [];
      return await _backendClient.fetchReports(projectId);
    } catch (e) {
      developer.log('Failed to fetch reports: $e', name: 'ReportRepository', error: e);
      return [];
    }
  }
}



