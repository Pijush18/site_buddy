/// PURPOSE: Application Routing configuration.
/// Goal: Modularized and maintainable routing structure.
library;


import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:site_buddy/app/navigation_shell.dart';
import 'package:site_buddy/dev/ui_lab/ui_lab_screen.dart';

// Screens
import 'package:site_buddy/features/home/presentation/screens/home_screen.dart';
import 'package:site_buddy/features/levelling_log/presentation/screens/levelling_log_screen.dart';
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

// Route Modules
import 'package:site_buddy/app/routes/design_routes.dart';
import 'package:site_buddy/app/routes/calculator_routes.dart';
import 'package:site_buddy/app/routes/ai_routes.dart';
import 'package:site_buddy/app/routes/work_routes.dart';
import 'package:site_buddy/app/routes/project_routes.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          NavigationShell(navigationShell: navigationShell),
      branches: [
        // BRANCH 0: HOME
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const HomeScreen(),
              routes: [
                GoRoute(
                  path: 'level',
                  builder: (context, state) => const LevellingLogScreen(),
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
