import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

/// ENUM: LogLevel
/// PURPOSE: Standardized levels for filtering and monitoring.
enum LogLevel { debug, info, warning, error }

/// SERVICE: AppLogger
/// PURPOSE: Centralized, structured logging for debugging and production stability.
/// 
/// FEATURES:
/// - Consistent formatting (Level: [Tag] Message)
/// - Error & Stacktrace support
/// - Production-safe (disabled in 'No Desktop' or specific release modes if needed,
///   but currently uses kDebugMode/developer.log for optimal Flutter integration).
/// - Extensible for Crashlytics/Sentry integration.
class AppLogger {
  static const String _defaultTag = 'SiteBuddy';

  /// LOG DEBUG: High-volume technical details.
  static void debug(String message, {String tag = _defaultTag}) {
    _log(LogLevel.debug, message, tag: tag);
  }

  /// LOG INFO: Significant operational milestones.
  static void info(String message, {String tag = _defaultTag}) {
    _log(LogLevel.info, message, tag: tag);
  }

  /// LOG WARNING: Unexpected but non-fatal events.
  static void warning(String message, {String tag = _defaultTag}) {
    _log(LogLevel.warning, message, tag: tag);
  }

  /// LOG ERROR: Fatal or critical failures.
  static void error(
    String message, {
    String tag = _defaultTag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(
      LogLevel.error,
      message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// CORE PRIVATE: Structured log formatting.
  static void _log(
    LogLevel level,
    String message, {
    String tag = _defaultTag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    // 1. Prepare visual level indicator
    final String levelStr = level.name.toUpperCase().padRight(7);
    
    // 2. Structured message
    final String fullMessage = '$levelStr [$tag] $message';

    // 3. Routing: In production, we could send to Sentry/Crashlytics here.
    if (level == LogLevel.error) {
      // Integration Point for Error Monitoring
      // if (!kDebugMode) FirebaseCrashlytics.instance.recordError(error, stackTrace, reason: message);
    }

    // 4. Output: Use developer.log for proper integration with IDE log viewers
    developer.log(
      fullMessage,
      name: 'SiteBuddy',
      level: _getLevelValue(level),
      error: error,
      stackTrace: stackTrace,
      time: DateTime.now(),
    );

    // 5. Console fallback if developer tool isn't attached (optional for developer experience)
    if (kDebugMode && level == LogLevel.error) {
      // ignore: avoid_print
      debugPrint('❌ ERROR [$tag]: $message');
      // ignore: avoid_print
      if (error != null) debugPrint('   Error: $error');
    }
  }

  /// Maps LogLevel to developer.log integer levels.
  static int _getLevelValue(LogLevel level) {
    switch (level) {
      case LogLevel.debug: return 500;
      case LogLevel.info: return 800;
      case LogLevel.warning: return 900;
      case LogLevel.error: return 1000;
    }
  }
}
