import 'package:go_router/go_router.dart';
import 'package:site_buddy/features/project/presentation/screens/project_share_screen.dart';
import 'package:site_buddy/features/project/presentation/screens/project_list_screen.dart';
import 'package:site_buddy/features/project/presentation/screens/project_editor_screen.dart';
import 'package:site_buddy/features/project/presentation/screens/project_detail_screen.dart';

final projectRoutes = [
  GoRoute(
    path: '/projects',
    builder: (context, state) => const ProjectListScreen(),
    routes: [
      GoRoute(
        path: 'create',
        builder: (context, state) => const ProjectEditorScreen(),
      ),
    ],
  ),
  GoRoute(
    path: '/projects/detail/:id',
    builder: (context, state) {
      final id = state.pathParameters['id']!;
      return ProjectDetailScreen(projectId: id);
    },
  ),
  GoRoute(
    path: '/projects/:id/edit',
    builder: (context, state) {
      final id = state.pathParameters['id']!;
      return ProjectEditorScreen(projectId: id);
    },
  ),
  GoRoute(
    path: '/projects/:id/share',
    name: 'projectShare',
    builder: (context, state) {
      final id = state.pathParameters['id']!;
      return ProjectShareScreen(projectId: id);
    },
  ),
  GoRoute(
    path: 'project/create', // Branch 0 version
    builder: (context, state) => const ProjectEditorScreen(),
  ),
];
