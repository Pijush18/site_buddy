import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:site_buddy/core/providers/shared_prefs_provider.dart';
import 'package:site_buddy/core/providers/settings_provider.dart';
import 'package:site_buddy/core/theme/app_theme.dart';
import 'package:site_buddy/core/localization/generated/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:site_buddy/app/router.dart';
import 'package:site_buddy/core/logging/app_logger.dart';

/// ENTRY POINT: SiteBuddy App
/// 
/// [SIMPLIFIED DI] - Uses idiomatic ProviderScope with overrides.
/// 
/// Benefits over previous ProviderContainer approach:
/// - Automatic container lifecycle management
/// - No memory leak risks
/// - Simpler testing with standard overrides
/// - 50% fewer files involved
Future<void> main() async {
  // 1. Initialize Flutter binding
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Initialize Firebase (non-blocking if fails)
  await _initializeFirebase();

  // 3. Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  // 4. Run app with idiomatic ProviderScope
  // This replaces the previous manual ProviderContainer + UncontrolledProviderScope pattern
  runApp(
    ProviderScope(
      overrides: [
        // Override SharedPreferences provider with initialized instance
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const SiteBuddyApp(),
    ),
  );
}

/// Initialize Firebase with graceful error handling
Future<void> _initializeFirebase() async {
  try {
    await Firebase.initializeApp();
  } catch (e, st) {
    AppLogger.error(
      'Firebase initialization failed',
      error: e,
      stackTrace: st,
    );
    // Continue without Firebase - app still works offline
  }
}

/// ROOT WIDGET: SiteBuddyApp
/// 
/// [REFACTORED] - Now purely a ConsumerWidget.
/// Initialization is handled via appInitializerProvider in the splash screen.
class SiteBuddyApp extends ConsumerWidget {
  const SiteBuddyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch settings for theme/locale changes
    // Note: settingsProvider depends on sharedPreferencesProvider which is overridden
    final settings = ref.watch(settingsProvider);

    return MaterialApp.router(
      title: 'Site Buddy',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      // LOCALIZATION
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(settings.locale),
      // THEME
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: settings.themeMode,
    );
  }
}
