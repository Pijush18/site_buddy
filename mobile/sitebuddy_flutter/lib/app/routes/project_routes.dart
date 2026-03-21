import 'package:go_router/go_router.dart';
import 'package:site_buddy/core/navigation/app_transitions.dart';
import 'package:site_buddy/features/project/presentation/screens/project_share_screen.dart';
import 'package:site_buddy/features/project/presentation/screens/project_list_screen.dart';
import 'package:site_buddy/features/project/presentation/screens/project_editor_screen.dart';
import 'package:site_buddy/features/project/presentation/screens/project_detail_screen.dart';

final projectRoutes = [
      GoRoute(
        path: '/projects',
        pageBuilder: (context, state) => AppTransitions.fadeSlide(
          state: state,
          child: const ProjectListScreen(),
        ),
        routes: [
          GoRoute(
            path: 'create',
            pageBuilder: (context, state) => AppTransitions.fadeSlide(
              state: state,
              child: const ProjectEditorScreen(),
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/projects/detail/:id',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          return AppTransitions.fadeSlide(
            state: state,
            child: ProjectDetailScreen(projectId: id),
          );
        },
      ),
      GoRoute(
        path: '/projects/:id/edit',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          return AppTransitions.fadeSlide(
            state: state,
            child: ProjectEditorScreen(projectId: id),
          );
        },
      ),
      GoRoute(
        path: '/projects/:id/share',
        name: 'projectShare',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          return AppTransitions.fadeSlide(
            state: state,
            child: ProjectShareScreen(projectId: id),
          );
        },
      ),
      GoRoute(
        path: 'project/create', // Branch 0 version
        pageBuilder: (context, state) => AppTransitions.fadeSlide(
          state: state,
          child: const ProjectEditorScreen(),
        ),
      ),
];



