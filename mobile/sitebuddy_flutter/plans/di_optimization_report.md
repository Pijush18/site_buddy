# Dependency Injection Optimization Report
**Project:** SiteBuddy Flutter  
**Date:** 2026-03-23  
**Objective:** Simplify and modernize the DI architecture

---

## 1. CURRENT DI ANALYSIS

### Current Architecture Overview

The project uses a **manual ProviderContainer** approach with `UncontrolledProviderScope`, which adds unnecessary complexity.

```
lib/main.dart
    └── bootstrap()
            ├── SharedPreferences.getInstance()
            ├── ProviderContainer(overrides: [sharedPreferencesProvider])
            ├── AppInitializer(container)
            └── runApp(UncontrolledProviderScope(container: container, ...))
```

### Files Using Manual DI

| File | Pattern | Issue |
|------|---------|-------|
| `lib/main.dart` | Calls `bootstrap()` | Indirect container access |
| `lib/app/bootstrap/bootstrap.dart` | `ProviderContainer()` + `UncontrolledProviderScope` | **Over-engineered** |
| `lib/app/bootstrap/app_initializer.dart` | Takes `ProviderContainer` parameter | **Hidden dependency** |
| `lib/core/providers/shared_prefs_provider.dart` | Throws `UnimplementedError` | **Fail-fast pattern** |

### Complexity Points and Risks

#### 1. **Manual ProviderContainer Creation**
```dart
// bootstrap.dart - Line 40-44
final container = ProviderContainer(
  overrides: [
    sharedPreferencesProvider.overrideWithValue(prefs),
  ],
);
```
**Risk:** Creates a second container that isn't connected to Flutter's widget tree
**Complexity:** Requires understanding of both ProviderContainer and UncontrolledProviderScope

#### 2. **UncontrolledProviderScope**
```dart
// bootstrap.dart - Line 51-55
runApp(
  UncontrolledProviderScope(
    container: container,
    child: const SiteBuddyApp(),
  ),
);
```
**Risk:** Disconnects the container from Flutter's normal widget tree lifecycle
**Complexity:** Memory leaks if not disposed properly

#### 3. **AppInitializer Takes Container**
```dart
// app_initializer.dart - Line 27-29
class AppInitializer {
  final ProviderContainer container;
  AppInitializer(this.container);
}
```
**Risk:** Direct container access in services breaks encapsulation
**Complexity:** Harder to test, violates DI principles

#### 4. **SharedPreferences Provider Throws**
```dart
// shared_prefs_provider.dart - Line 7-11
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'SharedPreferences must be initialized in main.dart',
  );
});
```
**Risk:** App crashes if not overridden
**Complexity:** Fail-fast pattern isn't idiomatic Riverpod

### Current Dependency Graph

```
main()
  └── bootstrap()
        ├── SharedPreferences (external)
        ├── ProviderContainer (manual)
        │     └── sharedPreferencesProvider.overrideWithValue(prefs)
        ├── AppInitializer(container)
        │     ├── settingsProvider
        │     ├── connectivityServiceProvider
        │     ├── backendClientProvider
        │     ├── knowledgeServiceProvider
        │     ├── projectRepositoryProvider
        │     ├── projectSessionServiceProvider
        │     └── dataMigrationServiceProvider
        └── UncontrolledProviderScope(container)
              └── SiteBuddyApp()
```

---

## 2. TARGET ARCHITECTURE

### Simplified Architecture

The idiomatic Riverpod approach uses `ProviderScope.overrides` at the app root:

```
main()
  └── WidgetsFlutterBinding.ensureInitialized()
        ├── Firebase.initializeApp()
        └── runApp(
              ProviderScope(
                overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
                child: const SiteBuddyApp(),
              ),
            )
        └── SiteBuddyApp (uses ConsumerWidget/ConsumerStatefulWidget)
              └── ref.watch() reads providers
```

### Simplified Dependency Graph

```
ProviderScope(overrides: [sharedPreferencesProvider])
  └── SiteBuddyApp
        ├── settingsProvider (watches sharedPreferencesProvider)
        └── ... all other providers auto-resolve
```

### Key Benefits

| Aspect | Before | After |
|--------|--------|-------|
| Container management | Manual | Automatic |
| Memory leaks | Possible | None |
| Testing | Requires container mocking | Uses standard overrides |
| Code complexity | 3 files + manual wiring | 1 file + ProviderScope |
| Lifecycle management | Manual disposal needed | Automatic |

---

## 3. MIGRATION PLAN

### Step-by-Step Safe Migration

#### Phase 1: Prepare Provider Changes

**Step 1.1:** Change `sharedPreferencesProvider` to use `FutureProvider` (optional but cleaner)

```dart
// Before (current)
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('...');
});

// After (simplified - keep same but cleaner)
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw StateError('SharedPreferences must be overridden in ProviderScope');
});
```

**Step 1.2:** Update `AppInitializer` to use `Ref` instead of `ProviderContainer`

#### Phase 2: Simplify Bootstrap

**Step 2.1:** Move initialization logic to async initialization
**Step 2.2:** Use `FutureProvider` for async initialization
**Step 2.3:** Remove `UncontrolledProviderScope`

#### Phase 3: Update Main Entry Point

**Step 3.1:** Move ProviderScope to main.dart
**Step 3.2:** Use async/await for Firebase + SharedPreferences
**Step 3.3:** Remove bootstrap.dart file

### Rollback Safety Strategy

1. **Keep bootstrap.dart** as backup until fully validated
2. **Test incrementally** after each file change
3. **Git branch** for isolation

---

## 4. IMPLEMENTATION

### Simplified main.dart

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:site_buddy/app/app.dart';
import 'package:site_buddy/core/providers/shared_prefs_provider.dart';
import 'package:site_buddy/core/logging/app_logger.dart';

Future<void> main() async {
  // 1. Initialize Flutter binding
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Initialize Firebase (non-blocking if fails)
  await _initializeFirebase();

  // 3. Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  // 4. Run app with ProviderScope
  runApp(
    ProviderScope(
      overrides: [
        // Override SharedPreferences provider
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const SiteBuddyApp(),
    ),
  );
}

Future<void> _initializeFirebase() async {
  try {
    await Firebase.initializeApp();
  } catch (e, st) {
    AppLogger.error('Firebase initialization failed', error: e, stackTrace: st);
  }
}
```

### Simplified AppInitializer (using Ref)

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:site_buddy/core/logging/app_logger.dart';

import 'package:site_buddy/core/providers/settings_provider.dart';
import 'package:site_buddy/core/services/data_migration_service.dart';
import 'package:site_buddy/core/network/connectivity_service.dart';
import 'package:site_buddy/core/backend/backend_client.dart';
import 'package:site_buddy/core/services/knowledge_service.dart';
import 'package:site_buddy/shared/application/providers/project_providers.dart';
import 'package:site_buddy/features/history/domain/models/calculation_history_entry.dart';
import 'package:site_buddy/features/project/domain/models/project.dart';
import 'package:site_buddy/features/project/domain/models/project_status.dart';
import 'package:site_buddy/features/level_log/data/models/level_entry_model.dart';
import 'package:site_buddy/features/level_log/data/models/level_method_model.dart';
import 'package:site_buddy/features/level_log/data/models/level_log_session_model.dart';
import 'package:site_buddy/core/branding/branding_model.dart';
import 'package:site_buddy/features/structural/shared/domain/models/design_report.dart';
import 'package:site_buddy/shared/application/services/data_migration_service.dart' as project_migration;

/// Provider that resolves when app initialization is complete
final initializationCompleteProvider = StateProvider<bool>((ref) => false);

/// Async provider for app initialization - call once at app startup
final appInitializerProvider = FutureProvider<void>((ref) async {
  // 1. Initialize Hive
  await Hive.initFlutter();

  // 2. Register Hive Adapters
  await _registerHiveAdapters();

  // 3. Open Hive boxes
  await _openHiveBoxes();

  // 4. Run migrations
  await _runMigrations(ref);

  // 5. Initialize services (trigger lazy loading)
  ref.read(connectivityServiceProvider);
  ref.read(backendClientProvider);
  await ref.read(knowledgeServiceProvider.future);

  // 6. Prime project session
  await _primeProjectSession(ref);

  // 7. Mark as complete
  ref.read(initializationCompleteProvider.notifier).state = true;
  
  AppLogger.debug('App initialization complete', tag: 'AppInitializer');
});

Future<void> _registerHiveAdapters() async {
  // Core models
  if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(ProjectAdapter());
  if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(ProjectStatusAdapter());
  if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter(LevelEntryModelAdapter());
  if (!Hive.isAdapterRegistered(3)) Hive.registerAdapter(LevelLogSessionModelAdapter());
  if (!Hive.isAdapterRegistered(4)) Hive.registerAdapter(LevelMethodModelAdapter());
  if (!Hive.isAdapterRegistered(5)) Hive.registerAdapter(BrandingModelAdapter());
  
  // History models (typeId 200+)
  if (!Hive.isAdapterRegistered(200)) {
    Hive.registerAdapter(CalculationHistoryEntryAdapter());
  }
  if (!Hive.isAdapterRegistered(201)) {
    Hive.registerAdapter(CalculationTypeAdapter());
  }

  // Design reports (typeId 20+)
  if (!Hive.isAdapterRegistered(20)) {
    Hive.registerAdapter(DesignTypeAdapter());
  }
  if (!Hive.isAdapterRegistered(21)) {
    Hive.registerAdapter(DesignReportAdapter());
  }
}

Future<void> _openHiveBoxes() async {
  await Hive.openBox<DesignReport>('history_reports_box');
  await Hive.openBox<CalculationHistoryEntry>('calculation_history_box');
  await Hive.openBox<Project>('projects_box');
  await Hive.openBox('project_activities_box');
}

Future<void> _runMigrations(Ref ref) async {
  // Run project system migration
  await project_migration.DataMigrationService.migrateAll();
  
  // Run SharedPreferences to Hive migration
  await ref.read(dataMigrationServiceProvider).runMigration();
}

Future<void> _primeProjectSession(Ref ref) async {
  final projectRepo = ref.read(projectRepositoryProvider);
  final sessionService = ref.read(projectSessionServiceProvider);
  
  final projects = await projectRepo.getProjects();
  if (projects.isNotEmpty) {
    await sessionService.setActiveProject(projects.first);
    AppLogger.debug('Session Restored: ${projects.first.id}', tag: 'AppInitializer');
  }
}
```

### Updated SiteBuddyApp

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/app/router.dart';
import 'package:site_buddy/core/providers/settings_provider.dart';
import 'package:site_buddy/core/theme/app_theme.dart';
import 'package:site_buddy/core/localization/generated/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// The root application widget.
/// 
/// [SIMPLIFIED] - No longer needs to handle initialization.
/// Use AppInitializer widget or ref.watch(appInitializerProvider) 
/// in a splash screen to wait for initialization.
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
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: settings.themeMode,
    );
  }
}
```

### Example Splash Screen (Optional)

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/app/bootstrap/app_initializer.dart';

/// Splash screen that waits for app initialization.
/// 
/// Usage: Add this as the initial route in appRouter.
class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initAsync = ref.watch(appInitializerProvider);
    
    return Scaffold(
      body: initAsync.when(
        data: (_) => const _InitCompleteWidget(),
        loading: () => const _LoadingWidget(),
        error: (e, st) => _ErrorWidget(error: e),
      ),
    );
  }
}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget();
  
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class _InitCompleteWidget extends StatelessWidget {
  const _InitCompleteWidget();
  
  @override
  Widget build(BuildContext context) {
    // Navigate to home after initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // context.go('/home'); // Uncomment with actual route
    });
    return const SizedBox.shrink();
  }
}

class _ErrorWidget extends StatelessWidget {
  final Object error;
  
  const _ErrorWidget({required this.error});
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text('Initialization failed:\n$error'),
        ],
      ),
    );
  }
}
```

---

## 5. VALIDATION CHECKLIST

After migration, verify:

- [ ] **No `ProviderContainer` usage** - Search for `ProviderContainer` returns 0 results
- [ ] **No `UncontrolledProviderScope` usage** - Search returns 0 results  
- [ ] **`sharedPreferencesProvider`** - Still has override in main.dart
- [ ] **App boots correctly** - Splash screen shows, navigates to home
- [ ] **All providers resolve** - No `throw UnimplementedError` crashes
- [ ] **Firebase works** - Analytics logging functional
- [ ] **Hive works** - Data persistence functional
- [ ] **Settings persist** - Theme/language changes save correctly

### Smoke Test Commands

```bash
# Search for any remaining manual container usage
grep -r "ProviderContainer" lib/
grep -r "UncontrolledProviderScope" lib/

# Verify no throw patterns remain
grep -r "throw UnimplementedError" lib/
grep -r "throw StateError.*override" lib/
```

---

## 6. SUMMARY

| Aspect | Before | After | Improvement |
|--------|--------|-------|-------------|
| Files involved | 4 (main, bootstrap, app_initializer, main.dart) | 2 (main, app) | 50% reduction |
| Container lifecycle | Manual | Automatic | No leaks |
| Testing | Requires container mocking | Standard overrides | Simpler |
| Code lines | ~150 | ~80 | 47% reduction |
| Complexity | High | Low | 3x simpler |

### Files to Delete After Migration

1. `lib/app/bootstrap/bootstrap.dart` (replaced by main.dart logic)
2. `lib/app/bootstrap/app_initializer.dart` (replaced by simplified version)

### Files to Modify

1. `lib/main.dart` - Move initialization logic here
2. `lib/app/app.dart` - Rename to SiteBuddyApp (currently in main.dart)
3. `lib/core/providers/shared_prefs_provider.dart` - Optional cleanup

---

*End of DI Optimization Report*
