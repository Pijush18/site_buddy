import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/features/project/application/controllers/project_controller.dart';
import 'package:site_buddy/core/network/connectivity_service.dart';
import 'package:site_buddy/core/design_system/sb_text_styles.dart';

/// SCREEN: ProjectListScreen
class ProjectListScreen extends ConsumerWidget {
  const ProjectListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(projectControllerProvider);
    final projects = state.projects;

    return SbPage.list(
      title: 'Projects',
      appBarActions: [
        Consumer(
          builder: (context, ref, _) {
            final isOnline = ref.watch(connectivityProvider).value ?? true;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppLayout.pMedium),
              child: Row(
                children: [
                  Icon(
                    isOnline ? SbIcons.checkFilled : SbIcons.warning,
                    size: 16,
                    color: isOnline ? Colors.green : Colors.orange,
                  ),
                  AppLayout.hGap8,
                  Text(
                    isOnline ? 'Synced' : 'Offline',
                    style: SbTextStyles.caption(context).copyWith(
                      color: isOnline ? Colors.green : Colors.orange,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
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
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: projects.length,
              separatorBuilder: (_, _) => AppLayout.vGap16,
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
