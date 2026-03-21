import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/features/project/application/controllers/project_controller.dart';
import 'package:site_buddy/core/navigation/app_routes.dart';

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
      body: _buildContent(context, state),
    );
  }

  Widget _buildContent(BuildContext context, dynamic state) {
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
        subtitle: 'Create your first civil engineering project to get started.',
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
          onTap: () => context.push(AppRoutes.projectDetail(project.id)),
        );
      }).toList(),
    );
  }
}
