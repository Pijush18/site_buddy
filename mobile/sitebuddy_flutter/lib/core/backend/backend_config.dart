import 'package:flutter/foundation.dart';

/// CLASS: BackendConfig
/// PURPOSE: Centralized configuration for the SiteBuddy Backend.
class BackendConfig {
  BackendConfig._();

  /// The version of the API we are currently targeting.
  static const String apiVersion = 'v1';

  /// Returns the base URL based on the current environment.
  static String get baseUrl {
    if (kDebugMode) {
      // Local FastAPI dev server
      return 'http://10.0.2.2:8000/api/$apiVersion'; 
    }
    
    // Future production URL
    return 'https://api.sitebuddy.ai/api/$apiVersion';
  }

  static const Duration timeout = Duration(seconds: 30);
}
