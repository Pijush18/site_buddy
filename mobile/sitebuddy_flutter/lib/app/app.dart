/// FILE HEADER
/// PURPOSE: Root MaterialApp wrapper configuring themes and routing.
/// FUTURE IMPROVEMENTS: Include localization/i18n delegates.
library;


import 'package:flutter/material.dart';
import 'package:site_buddy/core/theme/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/providers/settings_provider.dart';
import 'package:site_buddy/app/router.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    return MaterialApp.router(
      title: 'Site Buddy',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: settings.themeMode,
      routerConfig: appRouter,
    );
  }
}



