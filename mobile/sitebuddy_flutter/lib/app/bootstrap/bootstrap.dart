import 'package:flutter/foundation.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:site_buddy/core/logging/app_logger.dart';

/// Bootstrap module for pre-runApp initialization.
/// 
/// [SIMPLIFIED DI] - This file is kept minimal.
/// All provider initialization is now handled by ProviderScope in main.dart.
/// 
/// This file handles:
/// 1. Firebase Crashlytics error handling setup
/// 2. Firebase Analytics/Remote Config (non-blocking, runs after UI)
/// 
/// IMPORTANT: No ProviderContainer or UncontrolledProviderScope needed here.
/// All DI is now handled by the ProviderScope in main.dart.

/// Configure Firebase Crashlytics for error reporting.
/// Must be called before runApp() with FlutterError.onError.
Future<void> setupCrashlytics() async {
  try {
    if (Firebase.apps.isEmpty) return;
    
    if (!kIsWeb) {
      // Set up Flutter error handler for Crashlytics
      FlutterError.onError = (errorDetails) {
        FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      };
      
      // Set up platform error handler
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };
    }
  } catch (e, st) {
    AppLogger.error(
      'Firebase Crashlytics setup failed',
      error: e,
      stackTrace: st,
    );
  }
}

/// Fire-and-forget: Analytics + Remote Config.
/// These require network and MUST NOT block runApp().
/// 
/// This runs AFTER the app UI is up to avoid blocking startup.
Future<void> initFirebaseNetworkServices() async {
  try {
    if (Firebase.apps.isEmpty) return;

    // Log app open
    await FirebaseAnalytics.instance.logAppOpen();

    // Remote Config with short timeout
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: const Duration(hours: 1),
    ));
    await remoteConfig.fetchAndActivate();
    
    AppLogger.debug('Firebase network services initialized', tag: 'Bootstrap');
  } catch (e) {
    AppLogger.warning(
      'Firebase network services init failed (non-fatal): $e',
      tag: 'Bootstrap',
    );
  }
}


/// ============================================================================
/// DEPRECATED: Old bootstrap() function
/// ============================================================================
/// 
/// The old `bootstrap()` function used ProviderContainer + UncontrolledProviderScope.
/// This has been replaced by idiomatic ProviderScope in main.dart.
/// 
/// OLD CODE (removed):
/// ```dart
/// Future<void> bootstrap() async {
///   final prefs = await SharedPreferences.getInstance();
///   final container = ProviderContainer(
///     overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
///   );
///   runApp(
///     UncontrolledProviderScope(
///       container: container,
///       child: const SiteBuddyApp(),
///     ),
///   );
/// }
/// ```
/// 
/// NEW CODE (in main.dart):
/// ```dart
/// Future<void> main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   await Firebase.initializeApp();
///   final prefs = await SharedPreferences.getInstance();
///   runApp(
///     ProviderScope(
///       overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
///       child: const SiteBuddyApp(),
///     ),
///   );
/// }
/// ```
/// 
/// See plans/di_optimization_report.md for full migration details. 
