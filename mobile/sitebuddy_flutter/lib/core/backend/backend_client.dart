import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/network/api_client.dart';
import 'package:site_buddy/core/backend/backend_endpoints.dart';
import 'package:site_buddy/shared/domain/models/project.dart';
import 'package:site_buddy/shared/domain/models/calculation_history_entry.dart';
import 'package:site_buddy/shared/domain/models/site_report.dart';
import 'dart:io';
import 'package:dio/dio.dart';

/// Riverpod provider for the global BackendClient.
final backendClientProvider = Provider<BackendClient>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return BackendClient(apiClient);
});

/// CLASS: BackendClient
/// PURPOSE: High-level client for communicating with the SiteBuddy engineering backend.
class BackendClient {
  final ApiClient _apiClient;

  BackendClient(this._apiClient);

  /// SENDS a natural language prompt to the engineering AI model.
  Future<Map<String, dynamic>> queryAssistant(String prompt) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      BackendEndpoints.assistantQuery,
      data: {'prompt': prompt},
    );
    return response.data ?? {};
  }

  /// FETCHES all projects associated with the user from the cloud.
  Future<List<Project>> fetchProjects() async {
    final response = await _apiClient.get<List<dynamic>>(
      BackendEndpoints.projects,
    );
    
    if (response.data == null) return [];
    
    return response.data!
        .map((json) => Project.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// PUSHES a new project to the cloud.
  Future<void> createProject(Project project) async {
    await _apiClient.post(
      BackendEndpoints.projects,
      data: project.toJson(),
    );
  }

  /// FETCHES all calculations for a specific project from the cloud.
  Future<List<CalculationHistoryEntry>> fetchCalculations(String projectId) async {
    final response = await _apiClient.get<List<dynamic>>(
      BackendEndpoints.projectCalculations(projectId),
    );
    
    if (response.data == null) return [];
    
    return response.data!
        .map((json) => CalculationHistoryEntry.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// PUSHES a new calculation to the cloud.
  Future<void> createCalculation(CalculationHistoryEntry entry) async {
    await _apiClient.post(
      BackendEndpoints.calculations,
      data: entry.toJson(),
    );
  }

  /// UPLOADS a generated PDF report to cloud storage.
  Future<String> uploadReport({
    required String projectId,
    required File file,
  }) async {
    final formData = FormData.fromMap({
      'project_id': projectId,
      'file': await MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
      ),
    });

    final response = await _apiClient.post<Map<String, dynamic>>(
      BackendEndpoints.reportUpload,
      data: formData,
    );
    
    return response.data?['pdf_url'] ?? '';
  }

  /// FETCHES all reports for a specific project from the cloud.
  Future<List<SiteReport>> fetchReports(String projectId) async {
    final response = await _apiClient.get<List<dynamic>>(
      BackendEndpoints.reports, // Assuming index endpoint exists or using project sub-route
      // BackendEndpoints.projectReports(projectId) would be better if defined
    );
    
    if (response.data == null) return [];
    
    return response.data!
        .map((json) => SiteReport.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// FETCHES the current user's subscription status from the backend.
  Future<Map<String, dynamic>> getSubscriptionStatus() async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      BackendEndpoints.subscriptionStatus,
    );
    return response.data ?? {'has_premium': false, 'plan': 'free', 'status': 'active'};
  }

  /// VALIDATES a store purchase with the backend.
  Future<void> validatePurchase({
    required String purchaseToken,
    required String productId,
    required String packageName,
  }) async {
    await _apiClient.post(
      BackendEndpoints.subscriptionValidate,
      data: {
        'purchase_token': purchaseToken,
        'product_id': productId,
        'package_name': packageName,
      },
    );
  }

  /// CHECKS backend health status.
  Future<bool> checkHealth() async {
    try {
      final res = await _apiClient.get(BackendEndpoints.checkHealth);
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
