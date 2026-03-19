import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/app/bootstrap/bootstrap.dart';
import 'package:site_buddy/core/providers/settings_provider.dart';
import 'package:site_buddy/core/theme/app_theme.dart';
import 'package:site_buddy/core/localization/generated/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:site_buddy/app/router.dart';

import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase (Assuming default options or configured via native files)
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('CRITICAL: Firebase initialization failed: $e');
    debugPrint('The app will continue in offline/limited mode.');
  }

  // Delegate to bootstrap layer
  await bootstrap();
}

/// The root application widget.
class SiteBuddyApp extends ConsumerWidget {
  const SiteBuddyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final locale = Locale(settings.locale);

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
      locale: locale,

      // THEME CONFIGURATION
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: settings.themeMode,
    );
  }
}
