import 'package:site_buddy/core/network/api_config.dart';

/// CLASS: BackendConfig
/// PURPOSE: Centralized configuration for the SiteBuddy Backend.
class BackendConfig {
  BackendConfig._();

  /// The version of the API we are currently targeting.
  static const String apiVersion = 'v1';

  /// Returns the base URL based on the current environment.
  static String get baseUrl => ApiConfig.baseUrl;

  static const Duration timeout = Duration(seconds: 30);
}



