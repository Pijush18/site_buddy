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
import 'package:site_buddy/app/router.dart';
import 'package:site_buddy/main.dart';

/// Entry point for application bootstrapping.
Future<void> bootstrap() async {
  // Initialize other services if Firebase is available
  try {
    if (Firebase.apps.isNotEmpty) {
      // 1.1 Configure Crashlytics
    if (!kIsWeb) {
      FlutterError.onError = (errorDetails) {
        FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      };
      // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };
    }

    // 1.2 Log App Open with Analytics
    await FirebaseAnalytics.instance.logAppOpen();

    // 1.3 Initialize Remote Config
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 1),
    ));
    await remoteConfig.fetchAndActivate();
    }
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
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

  // 6. Trigger initialization pipeline
  // Note: We don't await this here so the UI (SplashScreen) can show up immediately.
  initializer.initialize();
}
