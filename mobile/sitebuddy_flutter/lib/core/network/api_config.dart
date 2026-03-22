import 'package:flutter/foundation.dart';

/// CLASS: ApiConfig
/// PURPOSE: Centralized network configuration for real-device and emulator testing.
class ApiConfig {
  ApiConfig._();

  /// Local development machine IPv4 address.
  /// To change: update this value or set via environment variable at build time.
  /// For Android Emulator use: 10.0.2.2
  /// For iOS Simulator use: localhost or 127.0.0.1
  /// For real device on same network: your machine's local IP (e.g., 192.168.1.x)
  /// Default to Android emulator localhost (10.0.2.2) as it's the most common case
  /// For iOS Simulator use: localhost or 127.0.0.1
  /// For physical devices on same network, set API_HOST environment variable
  static const String _devHost = String.fromEnvironment(
    'API_HOST',
    defaultValue: "10.0.2.2",
  );
  static const String _port = "8000";

  /// Base URL derived from environment.
  static String get baseUrl {
    if (kDebugMode) {
      // Use Local network IP for real devices + emulators
      // Note: For Android Emulator, use 10.0.2.2 instead of host IP
      return "http://$_devHost:$_port/api/v1";
    }
    // Production URL
    return "https://api.sitebuddy.ai/api/v1";
  }
}
