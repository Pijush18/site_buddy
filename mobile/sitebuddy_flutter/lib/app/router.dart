/// PURPOSE: Application Routing configuration.
/// Goal: Modularized and maintainable routing structure.
library;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:site_buddy/app/navigation_shell.dart';
import 'package:site_buddy/dev/ui_lab/ui_lab_screen.dart';
import 'package:site_buddy/core/providers/settings_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
Page<T> fadeTransition<T>({
  required Widget child,
  required GoRouterState state,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
    transitionDuration: const Duration(milliseconds: 300),
  );
}

final appRouter = GoRouter(
  initialLocation: '/splash',
  redirect: (context, state) {
    // 0. Ensure Firebase is initialized before accessing Auth
    if (Firebase.apps.isEmpty) {
      return null; // or '/splash' if you want to force staying on splash
    }

    final user = FirebaseAuth.instance.currentUser;
    final container = ProviderScope.containerOf(context);
    final settings = container.read(settingsProvider);

    final isAuthRoute = state.matchedLocation == '/login' ||
        state.matchedLocation == '/register' ||
        state.matchedLocation == '/reset-password';
    final isSplashRoute = state.matchedLocation == '/splash';
    final isRootRoute = state.matchedLocation == '/';

    // 1. If not authenticated and not on an auth/splash route, go to login
    if (user == null && !isAuthRoute && !isSplashRoute) {
      return '/login';
    }

    // 2. If authenticated and on an auth/splash/root route, check for restoration
    if (user != null && (isAuthRoute || isSplashRoute || isRootRoute)) {
      if (settings.restoreLastScreen) {
        final lastRoute = container.read(settingsProvider.notifier).getLastRoute();
        // Only redirect if lastRoute is different from current and not basic routes
        if (lastRoute != null && 
            lastRoute != state.matchedLocation &&
            lastRoute != '/login' && 
            lastRoute != '/splash' &&
            lastRoute != '/reset-password' &&
            lastRoute != '/register') {
          return lastRoute;
        }
      }
      
      // If on auth route but authenticated, always go home (if not restored)
      if (isAuthRoute) return '/';
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      pageBuilder: (context, state) => fadeTransition(
        state: state,
        child: const LoginScreen(),
      ),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/reset-password',
      builder: (context, state) => const ResetPasswordScreen(),
    ),
    GoRoute(
      path: '/subscription',
      builder: (context, state) => const SubscriptionScreen(),
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
              pageBuilder: (context, state) => fadeTransition(
                state: state,
                child: const HomeScreen(),
              ),
              routes: [
                GoRoute(
                  path: 'level',
                  builder: (context, state) => const LevelLogScreen(projectId: 'default'),
                ),
                GoRoute(
                  path: 'reports',
                  builder: (context, state) => const ReportsScreen(),
                ),
                GoRoute(
                  path: 'settings/branding',
                  builder: (context, state) => const BrandingSettingsScreen(),
                ),
                GoRoute(
                  path: 'report/preview',
                  builder: (context, state) {
                    final report = state.extra as SiteReport;
                    return SiteReportPreviewScreen(report: report);
                  },
                ),
                ...aiRoutes,
                ...projectRoutes.where((r) => r.path == 'project/create'),
                ...workRoutes.where((r) => r.path == '/tasks'),
                GoRoute(
                  path: 'settings',
                  builder: (context, state) => const SettingsScreen(),
                  routes: [
                    GoRoute(
                      path: 'privacy',
                      builder: (context, state) => const PrivacyPolicyScreen(),
                    ),
                    GoRoute(
                      path: 'terms',
                      builder: (context, state) =>
                          const TermsConditionsScreen(),
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
      builder: (context, state) {
        final entry = state.extra as CalculationHistoryEntry;
        return HistoryDetailScreen(entry: entry);
      },
    ),
    GoRoute(
      path: '/projects/:id/level-log',
      name: 'levelLog',
      builder: (context, state) {
        final projectId = state.pathParameters['id']!;
        final logId = state.extra as String?;
        return LevelLogScreen(projectId: projectId, logId: logId);
      },
    ),
    GoRoute(
      path: '/projects/:id/history',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return CalculationHistoryScreen(projectId: id);
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
        builder: (context, state) => const UiLabScreen(),
      ),
  ],
);
