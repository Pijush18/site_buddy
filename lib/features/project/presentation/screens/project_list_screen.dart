import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/features/project/application/controllers/project_controller.dart';

/// SCREEN: ProjectListScreen
class ProjectListScreen extends ConsumerWidget {
  const ProjectListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(projectControllerProvider);
    final projects = state.projects;

    return SbPage.list(
      title: 'Projects',
      header: SbButton.primary(
        label: 'New Project',
        icon: SbIcons.add,
        onPressed: () => context.push('/projects/create'),
      ),
      body: projects.isEmpty
          ? const SbEmptyState(
              icon: SbIcons.projectOff,
              title: 'No Projects Yet',
              subtitle:
                  'Create your first civil engineering project to get started.',
              actionLabel: 'New Project',
              onAction:
                  null, // Should probably be a real action but keeping simple for now
            )
          : ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: projects.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppLayout.md),
              itemBuilder: (context, index) {
                final project = projects[index];
                final formattedDate = DateFormat(
                  'MMM dd, yyyy',
                ).format(project.createdAt);
                return ProjectCard(
                  name: project.name,
                  date: formattedDate,
                  location: project.location,
                  logsCount: 0,
                  calcsCount: 0,
                  onTap: () => context.push('/projects/detail', extra: project),
                );
              },
            ),
    );
  }
}
