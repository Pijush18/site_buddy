import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:site_buddy/app/bootstrap/app_initializer.dart';
import 'package:site_buddy/core/providers/shared_prefs_provider.dart';
import 'package:site_buddy/core/providers/settings_provider.dart';
import 'package:site_buddy/core/logging/app_logger.dart';
import 'package:site_buddy/app/router.dart';
import 'package:site_buddy/main.dart';

/// Entry point for application bootstrapping.
Future<void> bootstrap() async {
  // Initialize other services if Firebase is available
  try {
    if (Firebase.apps.isNotEmpty) {
      // 1.1 Configure Crashlytics (synchronous — no network)
    if (!kIsWeb) {
      FlutterError.onError = (errorDetails) {
        FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      };
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };
    }
    }
  } catch (e, st) {
    AppLogger.error('Firebase Crashlytics setup failed', error: e, stackTrace: st);
  }

  // 2. Pre-initialize dependencies needed for Provider overrides
  final prefs = await SharedPreferences.getInstance();

  // 3. Create the top-level ProviderContainer
  final container = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
    ],
  );

  // 4. Initialize AppInitializer
  final initializer = AppInitializer(container);

  // 5. Start the application (runApp)
  // We use UncontrolledProviderScope to manage our own container
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const SiteBuddyApp(),
    ),
  );

  // 5.1 Track last visited screen
  appRouter.routerDelegate.addListener(() {
    final location = appRouter.routeInformationProvider.value.uri.toString();
    final settings = container.read(settingsProvider);
    if (settings.restoreLastScreen) {
      // Avoid saving auth or splash routes
      final isAuthRoute = location == '/login' ||
          location == '/register' ||
          location == '/reset-password' ||
          location == '/splash';
      if (!isAuthRoute) {
        container.read(settingsProvider.notifier).setLastRoute(location);
      }
    }
  });

  // 6. Firebase network services (non-blocking — runs AFTER UI is up)
  _initFirebaseNetworkServices();

  // 7. Trigger initialization pipeline
  // Note: We don't await this here so the UI (SplashScreen) can show up immediately.
  initializer.initialize();
}

/// Fire-and-forget: Analytics + Remote Config.
/// These require network and MUST NOT block runApp().
Future<void> _initFirebaseNetworkServices() async {
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
  } catch (e) {
    AppLogger.warning('Firebase network services init failed (non-fatal): $e', tag: 'Bootstrap');
  }
}
