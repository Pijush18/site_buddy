/// CLASS: ApiEndpoints
/// PURPOSE: Centralized backend route constants for SiteBuddy.
class ApiEndpoints {
  ApiEndpoints._();

  // --- AUTH ---
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String syncUser = '/auth/sync';

  // --- ASSISTANT ---
  static const String queryAssistant = '/assistant/query';
  static const String knowledgeSearch = '/assistant/knowledge/search';

  // --- PROJECTS ---
  static const String projects = '/projects';
  static String projectDetail(String id) => '/projects/$id';

  // --- REPORTS ---
  static const String reports = '/reports';
  static String reportDetail(String id) => '/reports/$id';
  static String generateReport = '/reports/generate';

  // --- SUBSCRIPTIONS ---
  static const String subscriptionStatus = '/subscriptions/status';
  static const String verifyPurchase = '/subscriptions/verify';
}
