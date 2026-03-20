import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/backend/backend_client.dart';
import 'dart:developer' as developer;

/// PROVIDER: healthRepositoryProvider
final healthRepositoryProvider = Provider<HealthRepository>((ref) {
  final backendClient = ref.watch(backendClientProvider);
  return HealthRepository(backendClient);
});

/// CLASS: HealthRepository
/// PURPOSE: Manages backend connectivity status and heartbeats.
class HealthRepository {
  final BackendClient _backendClient;

  HealthRepository(this._backendClient);

  /// METHOD: isBackendHealthy
  /// PURPOSE: Verifies if the FastAPI backend is responding correctly.
  Future<bool> isBackendHealthy() async {
    try {
      final healthy = await _backendClient.checkHealth();
      developer.log('Backend Health Status: ${healthy ? 'ONLINE' : 'OFFLINE'}', name: 'site_buddy.HealthRepository');
      return healthy;
    } catch (e) {
      developer.log('Backend Health Check Failed: $e', name: 'site_buddy.HealthRepository', error: e);
      return false;
    }
  }
}



