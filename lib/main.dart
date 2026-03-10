import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/providers/settings_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:site_buddy/core/providers/shared_prefs_provider.dart';
import 'package:site_buddy/core/theme/app_theme.dart';
import 'package:site_buddy/core/localization/generated/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:site_buddy/shared/domain/models/project.dart';
import 'package:site_buddy/shared/domain/models/project_status.dart';
import 'package:site_buddy/features/level_log/data/models/level_entry_model.dart';
import 'package:site_buddy/features/level_log/data/models/level_method_model.dart';
import 'package:site_buddy/features/level_log/data/models/level_log_session_model.dart';
import 'package:site_buddy/core/services/data_migration_service.dart';
import 'package:site_buddy/app/router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register Hive Adapters
  Hive.registerAdapter(ProjectAdapter());
  Hive.registerAdapter(ProjectStatusAdapter());
  Hive.registerAdapter(LevelEntryModelAdapter());
  Hive.registerAdapter(LevelLogSessionModelAdapter());
  Hive.registerAdapter(LevelMethodModelAdapter());

  final prefs = await SharedPreferences.getInstance();

  // Initialize Global App State and Persistence
  final container = ProviderContainer(
    overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
  );

  // Initialize Settings Provider
  container.read(settingsProvider);

  // Run Legacy SharedPreferences to Hive Migration
  await container.read(dataMigrationServiceProvider).runMigration();

  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

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
