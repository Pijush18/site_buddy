/// CLASS: BackendEndpoints
/// PURPOSE: Centralized registry of all backend API paths.
class BackendEndpoints {
  BackendEndpoints._();

  // Assistant Endpoints
  static const String assistantQuery = '/assistant/query';
  static const String assistantFeedback = '/assistant/feedback';

  // Project Sync Endpoints
  static const String projects = '/projects';
  static const String projectSync = '/projects/sync';
  
  // Calculation Sync Endpoints
  static const String calculations = '/calculations';
  static String projectCalculations(String projectId) => '/projects/$projectId/calculations';
  
  // Report Storage Endpoints
  static const String reports = '/reports';
  static const String reportUpload = '/reports/upload';

  // User & Settings
  static const String userProfile = '/user/profile';
  static const String appSettings = '/app/settings';
  
  // Subscription Endpoints
  static const String subscriptionStatus = '/subscriptions/status';
  static const String subscriptionValidate = '/subscriptions/validate';
  
  // Verification
  static const String checkHealth = '/health';
}



