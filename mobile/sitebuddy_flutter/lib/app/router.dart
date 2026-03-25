/// PURPOSE: Application Routing configuration.
/// Goal: Modularized and maintainable routing structure.
library;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:site_buddy/app/navigation_shell.dart';
import 'package:site_buddy/dev/ui_lab/ui_lab_screen.dart';
import 'package:site_buddy/core/providers/settings_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/navigation/app_transitions.dart';
import 'package:site_buddy/core/navigation/app_routes.dart';
import 'package:site_buddy/shared/application/providers/project_providers.dart';
import 'package:site_buddy/shared/application/services/project_session_service.dart';

// Screens
import 'package:site_buddy/features/home/presentation/screens/home_screen.dart';
import 'package:site_buddy/features/level_log/presentation/screens/level_log_screen.dart';
import 'package:site_buddy/features/reports/presentation/screens/reports_screen.dart';
import 'package:site_buddy/features/settings/presentation/screens/branding_settings_screen.dart';
import 'package:site_buddy/features/reports/presentation/screens/site_report_preview_screen.dart';
import 'package:site_buddy/shared/domain/models/site_report.dart';
import 'package:site_buddy/features/settings/presentation/screens/settings_screen.dart';
import 'package:site_buddy/features/splash/presentation/screens/splash_screen.dart';
import 'package:site_buddy/features/subscription/presentation/screens/subscription_screen.dart';
import 'package:site_buddy/features/auth/presentation/screens/login_screen.dart';
import 'package:site_buddy/features/auth/presentation/screens/register_screen.dart';
import 'package:site_buddy/features/auth/presentation/screens/reset_password_screen.dart';

// Route Modules
import 'package:site_buddy/app/routes/design_routes.dart';
import 'package:site_buddy/app/routes/calculator_routes.dart';
import 'package:site_buddy/app/routes/ai_routes.dart';
import 'package:site_buddy/app/routes/work_routes.dart';
import 'package:site_buddy/app/routes/project_routes.dart';

final appRouter = GoRouter(
  initialLocation: AppRoutes.splash,

  redirect: (context, state) {
    if (Firebase.apps.isEmpty) return null;

    final user = FirebaseAuth.instance.currentUser;
    final container = ProviderScope.containerOf(context, listen: false);
    final settings = container.read(settingsProvider);

    final location = state.matchedLocation;

    // Get project session safely
    ProjectSessionService? session;
    try {
      session = container.read(projectSessionServiceProvider);
    } catch (_) {
      session = null;
    }

    /// =========================
    /// 1. AUTH GUARD
    /// =========================
    final isAuthRoute =
        location == AppRoutes.login ||
        location == AppRoutes.register ||
        location == AppRoutes.resetPassword;

    final isSplashRoute = location == AppRoutes.splash;

    if (user == null && !isAuthRoute && !isSplashRoute) {
      return AppRoutes.login;
    }

    /// =========================
    /// 2. RESTORE LAST SCREEN (FIXED)
    /// ONLY runs from splash
    /// =========================
    if (user != null &&
        settings.restoreLastScreen &&
        location == AppRoutes.splash) {
      final lastRoute =
          container.read(settingsProvider.notifier).getLastRoute();

      if (lastRoute != null &&
          lastRoute != AppRoutes.login &&
          lastRoute != AppRoutes.splash &&
          lastRoute != AppRoutes.register) {
        return lastRoute;
      }
    }

    /// =========================
    /// 3. PROJECT GUARD (SCOPED)
    /// =========================
    final requiresProject =
        location.startsWith('/design') ||
        location.startsWith('/reports') ||
        location == '/level';

    if (requiresProject && session?.hasActiveProject != true) {
      return AppRoutes.projects;
    }

    /// =========================
    /// 4. AUTH REDIRECT
    /// =========================
    if (user != null && isAuthRoute) {
      return AppRoutes.home;
    }

    return null;
  },

  routes: [
    GoRoute(
      path: '/splash',
      pageBuilder: (context, state) =>
          AppTransitions.fadeSlide(state: state, child: const SplashScreen()),
    ),
    GoRoute(
      path: '/login',
      pageBuilder: (context, state) =>
          AppTransitions.fadeSlide(state: state, child: const LoginScreen()),
    ),
    GoRoute(
      path: '/register',
      pageBuilder: (context, state) =>
          AppTransitions.fadeSlide(state: state, child: const RegisterScreen()),
    ),
    GoRoute(
      path: '/reset-password',
      pageBuilder: (context, state) => AppTransitions.fadeSlide(
        state: state,
        child: const ResetPasswordScreen(),
      ),
    ),
    GoRoute(
      path: '/subscription',
      pageBuilder: (context, state) => AppTransitions.fadeSlide(
        state: state,
        child: const SubscriptionScreen(),
      ),
    ),

    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          NavigationShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              pageBuilder: (context, state) => AppTransitions.fadeSlide(
                state: state,
                child: const HomeScreen(),
              ),
              routes: [
                GoRoute(
                  path: 'level',
                  pageBuilder: (context, state) => AppTransitions.fadeSlide(
                    state: state,
                    child: const LevelLogScreen(),
                  ),
                ),
                GoRoute(
                  path: 'reports',
                  pageBuilder: (context, state) => AppTransitions.fadeSlide(
                    state: state,
                    child: const ReportsScreen(),
                  ),
                ),
                GoRoute(
                  path: 'settings/branding',
                  pageBuilder: (context, state) => AppTransitions.fadeSlide(
                    state: state,
                    child: const BrandingSettingsScreen(),
                  ),
                ),
                GoRoute(
                  path: 'report/preview',
                  pageBuilder: (context, state) {
                    final report = state.extra as SiteReport;
                    return AppTransitions.fadeSlide(
                      state: state,
                      child: SiteReportPreviewScreen(report: report),
                    );
                  },
                ),
                ...aiRoutes,
                ...projectRoutes.where((r) => r.path == 'project/create'),
                ...workRoutes.where((r) => r.path == '/tasks'),
                GoRoute(
                  path: 'settings',
                  pageBuilder: (context, state) => AppTransitions.fadeSlide(
                    state: state,
                    child: const SettingsScreen(),
                  ),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(routes: [...calculatorRoutes]),
        StatefulShellBranch(routes: [...designRoutes]),
        StatefulShellBranch(
          routes: [...projectRoutes.where((r) => r.path == '/projects')],
        ),
      ],
    ),

    if (kDebugMode)
      GoRoute(
        path: '/dev/ui-lab',
        pageBuilder: (context, state) =>
            AppTransitions.fadeSlide(state: state, child: const UiLabScreen()),
      ),
  ],
);