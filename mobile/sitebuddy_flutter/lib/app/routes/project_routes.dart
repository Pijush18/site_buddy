import 'package:go_router/go_router.dart';
import 'package:site_buddy/core/navigation/app_transitions.dart';
import 'package:site_buddy/features/project/presentation/screens/project_share_screen.dart';
import 'package:site_buddy/features/project/presentation/screens/project_list_screen.dart';
import 'package:site_buddy/features/project/presentation/screens/project_editor_screen.dart';
import 'package:site_buddy/features/project/presentation/screens/project_detail_screen.dart';

import 'package:site_buddy/features/level_log/presentation/screens/level_log_screen.dart';
import 'package:site_buddy/features/history/presentation/screens/calculation_history_screen.dart';

final projectRoutes = [
  GoRoute(
    path: '/projects',
    pageBuilder: (context, state) => AppTransitions.fadeSlide(
      state: state,
      child: const ProjectListScreen(),
    ),
    routes: [
      GoRoute(
        path: 'detail',
        pageBuilder: (context, state) {
          return AppTransitions.fadeSlide(
            state: state,
            child: const ProjectDetailScreen(),
          );
        },
      ),
      GoRoute(
        path: 'edit',
        pageBuilder: (context, state) {
          final id = state.extra as String?;
          return AppTransitions.fadeSlide(
            state: state,
            child: ProjectEditorScreen(projectId: id),
          );
        },
      ),
      GoRoute(
        path: 'share',
        name: 'projectShare',
        pageBuilder: (context, state) {
          final id = state.extra as String;
          return AppTransitions.fadeSlide(
            state: state,
            child: ProjectShareScreen(projectId: id),
          );
        },
      ),
      GoRoute(
        path: 'level-log',
        name: 'levelLog',
        pageBuilder: (context, state) {
          final logId = state.extra as String?;
          return AppTransitions.fadeSlide(
            state: state,
            child: LevelLogScreen(logId: logId),
          );
        },
      ),
      GoRoute(
        path: 'history',
        pageBuilder: (context, state) {
          return AppTransitions.fadeSlide(
            state: state,
            child: const CalculationHistoryScreen(),
          );
        },
      ),
    ],
  ),
  GoRoute(
    path: 'project/create', // Branch 0 version
    pageBuilder: (context, state) => AppTransitions.fadeSlide(
      state: state,
      child: const ProjectEditorScreen(),
    ),
  ),
];
