import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/features/project/application/controllers/project_controller.dart';
import 'package:site_buddy/core/navigation/app_routes.dart';
import 'package:site_buddy/shared/application/providers/project_providers.dart';
import 'package:site_buddy/shared/domain/models/project.dart';

/// SCREEN: ProjectListScreen
/// PURPOSE: List all civil engineering projects following the Predefined Layout System.
class ProjectListScreen extends ConsumerWidget {
  const ProjectListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(projectControllerProvider);

    return SbPage.list(
      title: 'Projects',
      appBarActions: [
        IconButton(
          icon: const Icon(SbIcons.add),
          onPressed: () => context.push(AppRoutes.projectCreate),
        ),
      ],
      header: SBGridActionCard(
        icon: SbIcons.addCircle,
        label: 'New Project',
        onTap: () => context.push(AppRoutes.projectCreate),
        isHighlighted: true,
      ),
      body: _buildContent(context, ref, state),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, dynamic state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.failure != null) {
      return Center(child: Text('Error: ${state.failure}'));
    }

    if (state.projects.isEmpty) {
      return const SbEmptyState(
        icon: SbIcons.project,
        title: 'No Projects Yet',
        subtitle: 'Create a project to start.',
      );
    }

    return SbListGroup(
      children: state.projects.map<Widget>((project) {
        return ProjectCard(
          name: project.name,
          date: DateFormat('MMM dd, yyyy').format(project.createdAt),
          location: project.location,
          logsCount: project.logsCount,
          calcsCount: project.calculationsCount,
          // FIX: Set active project before navigating
          onTap: () => _navigateToProjectDetail(context, ref, project),
        );
      }).toList(),
    );
  }

  // Helper to set active project before navigation
  void _navigateToProjectDetail(
    BuildContext context,
    WidgetRef ref,
    Project project,
  ) {
    ref.read(projectSessionServiceProvider).setActiveProject(project);
    context.push(AppRoutes.projectDetail());
  }
}
