import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/features/project/application/controllers/project_controller.dart';
import 'package:site_buddy/core/network/connectivity_service.dart';

/// SCREEN: ProjectListScreen
/// PURPOSE: List all civil engineering projects following the Predefined Layout System.
class ProjectListScreen extends ConsumerWidget {
  const ProjectListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(projectControllerProvider);
    final projects = state.projects;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return AppScreenWrapper(
      title: 'Projects',
      isScrollable: true,
      usePadding: true,
      actions: [
        Consumer(
          builder: (context, ref, _) {
            final isOnline = ref.watch(connectivityProvider).value ?? true;
            final statusColor = isOnline ? Colors.green : Colors.orange;
            
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: SbSpacing.md),
              child: Row(
                children: [
                  Icon(
                    isOnline ? SbIcons.checkFilled : SbIcons.warning,
                    size: 16,
                    color: statusColor,
                  ),
                  const SizedBox(width: SbSpacing.xs),
                  Text(
                    isOnline ? 'Synced' : 'Offline',
                    style: textTheme.labelMedium,
                  ),
                ],
              ),
            );
          },
        ),
      ],
      child: SbSectionList(
        physics: const BouncingScrollPhysics(),
        sections: [
          // ── HERO SECTION & PRIMARY CTA ──
          SbSection(
            child: SbModuleHero(
              icon: SbIcons.project,
              title: 'Project Management',
              subtitle: 'Track and manage your site projects, dimensions, and engineering logs.',
              child: SbButton.primary(
                label: 'New Project',
                icon: Icons.add,
                onPressed: () => context.push('/projects/create'),
                width: 180, // More controlled width for visibility
              ),
            ),
          ),

          if (projects.isEmpty)
            SbSection(
              child: SbEmptyState(
                icon: Icons.folder_off_outlined,
                title: 'No Projects Yet',
                subtitle: 'Create your first civil engineering project to get started.',
                actionLabel: 'New Project',
                onAction: () => context.push('/projects/create'),
              ),
            )
          else
            SbSection(
              title: 'Recent Projects',
              subtitle: 'Quickly access your recently updated site projects.',
              child: SbListGroup(
                children: projects.map((project) {
                  final formattedDate = DateFormat('MMM dd, yyyy').format(project.createdAt);
                  return ProjectCard(
                    name: project.name,
                    date: formattedDate,
                    location: project.location,
                    logsCount: 0,
                    calcsCount: 0,
                    onTap: () => context.push('/projects/detail', extra: project),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}



