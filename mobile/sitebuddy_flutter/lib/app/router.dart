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

// Screens
import 'package:site_buddy/features/home/presentation/screens/home_screen.dart';
import 'package:site_buddy/features/level_log/presentation/screens/level_log_screen.dart';
import 'package:site_buddy/features/reports/presentation/screens/reports_screen.dart';
import 'package:site_buddy/features/settings/presentation/screens/branding_settings_screen.dart';
import 'package:site_buddy/features/reports/presentation/screens/site_report_preview_screen.dart';
import 'package:site_buddy/shared/domain/models/site_report.dart';
import 'package:site_buddy/features/settings/presentation/screens/settings_screen.dart';
import 'package:site_buddy/features/settings/presentation/screens/privacy_policy_screen.dart';
import 'package:site_buddy/features/settings/presentation/screens/terms_conditions_screen.dart';
import 'package:site_buddy/shared/domain/models/calculation_history_entry.dart';
import 'package:site_buddy/features/history/presentation/screens/calculation_history_screen.dart';
import 'package:site_buddy/features/history/presentation/screens/history_detail_screen.dart';
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

// PAGE TRANSITIONS

final appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  redirect: (context, state) {
    // 0. Ensure Firebase is initialized before accessing Auth
    if (Firebase.apps.isEmpty) {
      return null; // or '/splash' if you want to force staying on splash
    }

    final user = FirebaseAuth.instance.currentUser;
    final container = ProviderScope.containerOf(context);
    final settings = container.read(settingsProvider);

    final isAuthRoute =
        state.matchedLocation == AppRoutes.login ||
        state.matchedLocation == AppRoutes.register ||
        state.matchedLocation == AppRoutes.resetPassword;
    final isSplashRoute = state.matchedLocation == AppRoutes.splash;
    final isRootRoute = state.matchedLocation == AppRoutes.home;

    // 1. If not authenticated and not on an auth/splash route, go to login
    if (user == null && !isAuthRoute && !isSplashRoute) {
      return AppRoutes.login;
    }

    // 2. If authenticated and on an auth/splash/root route, check for restoration
    if (user != null && (isAuthRoute || isSplashRoute || isRootRoute)) {
      if (settings.restoreLastScreen) {
        final lastRoute = container
            .read(settingsProvider.notifier)
            .getLastRoute();
        // Only redirect if lastRoute is different from current and not basic routes
        if (lastRoute != null &&
            lastRoute != state.matchedLocation &&
            lastRoute != AppRoutes.login &&
            lastRoute != AppRoutes.splash &&
            lastRoute != AppRoutes.resetPassword &&
            lastRoute != AppRoutes.register) {
          return lastRoute;
        }
      }

      // If on auth route but authenticated, always go home (if not restored)
      if (isAuthRoute) return AppRoutes.home;
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
        // BRANCH 0: HOME
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
                    // FIX: Removed hardcoded fallback 'default' projectId
                    // LevelLogScreen requires a valid projectId - navigation should only occur
                    // after user selects a project from the project list
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
                  routes: [
                    GoRoute(
                      path: 'privacy',
                      pageBuilder: (context, state) => AppTransitions.fadeSlide(
                        state: state,
                        child: const PrivacyPolicyScreen(),
                      ),
                    ),
                    GoRoute(
                      path: 'terms',
                      pageBuilder: (context, state) => AppTransitions.fadeSlide(
                        state: state,
                        child: const TermsConditionsScreen(),
                      ),
                    ),
                  ],
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
    // GLOBAL ROUTES
    GoRoute(
      path: '/history-detail',
      pageBuilder: (context, state) {
        final entry = state.extra as CalculationHistoryEntry;
        return AppTransitions.fadeSlide(
          state: state,
          child: HistoryDetailScreen(entry: entry),
        );
      },
    ),
    GoRoute(
      path: '/projects/:id/level-log',
      name: 'levelLog',
      pageBuilder: (context, state) {
        final projectId = state.pathParameters['id']!;
        final logId = state.extra as String?;
        return AppTransitions.fadeSlide(
          state: state,
          child: LevelLogScreen(projectId: projectId, logId: logId),
        );
      },
    ),
    GoRoute(
      path: '/projects/:id/history',
      pageBuilder: (context, state) {
        final id = state.pathParameters['id']!;
        return AppTransitions.fadeSlide(
          state: state,
          child: CalculationHistoryScreen(projectId: id),
        );
      },
    ),
    ...designRedirects,
    ...projectRoutes.where(
      (r) => r.path.startsWith('/projects') && r.path != '/projects',
    ),
    ...workRoutes.where(
      (r) => r.path.startsWith('/tasks/') && r.path != '/tasks',
    ),
    if (kDebugMode)
      GoRoute(
        path: '/dev/ui-lab',
        pageBuilder: (context, state) =>
            AppTransitions.fadeSlide(state: state, child: const UiLabScreen()),
      ),
  ],
);
