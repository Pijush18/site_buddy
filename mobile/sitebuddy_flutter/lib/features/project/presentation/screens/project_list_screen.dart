import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/theme/app_font_sizes.dart';
import 'package:site_buddy/core/widgets/app_screen_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/features/project/application/controllers/project_controller.dart';
import 'package:site_buddy/core/network/connectivity_service.dart';

/// SCREEN: ProjectListScreen
class ProjectListScreen extends ConsumerWidget {
  const ProjectListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(projectControllerProvider);
    final projects = state.projects;

    return AppScreenWrapper(
      title: 'Projects',
      actions: [
        Consumer(
          builder: (context, ref, _) {
            final isOnline = ref.watch(connectivityProvider).value ?? true;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md), // Replaced AppLayout.pMedium
              child: Row(
                children: [
                  Icon(
                    isOnline ? SbIcons.checkFilled : SbIcons.warning,
                    size: 16,
                    color: isOnline ? Colors.green : Colors.orange,
                  ),
                  const SizedBox(width: AppSpacing.sm), // Replaced AppLayout.hGap8
                  Text(
                    isOnline ? 'Synced' : 'Offline',
                    style: TextStyle(
                      fontSize: AppFontSizes.tab,
                      color: isOnline ? Colors.green : Colors.orange,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
      child: Column(
        children: [
          SbButton.primary(
            label: 'New Project',
            icon: SbIcons.add,
            onPressed: () => context.push('/projects/create'),
          ),
          const SizedBox(height: AppSpacing.md),
          projects.isEmpty
              ? const SbEmptyState(
                  icon: SbIcons.projectOff,
                  title: 'No Projects Yet',
                  subtitle:
                      'Create your first civil engineering project to get started.',
                  actionLabel: 'New Project',
                )
              : Column(
                  children: projects.map((project) {
                    final formattedDate =
                        DateFormat('MMM dd, yyyy').format(project.createdAt);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md), // Replaced AppLayout.md
                      child: ProjectCard(
                        name: project.name,
                        date: formattedDate,
                        location: project.location,
                        logsCount: 0,
                        calcsCount: 0,
                        onTap: () =>
                            context.push('/projects/detail', extra: project),
                      ),
                    );
                  }).toList(),
                ),
        ],
      ),
    );
  }
}
