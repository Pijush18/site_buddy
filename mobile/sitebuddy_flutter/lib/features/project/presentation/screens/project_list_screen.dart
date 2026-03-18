import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/theme/app_font_sizes.dart';
import 'package:site_buddy/core/widgets/app_screen_wrapper.dart';
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
      isScrollable: false,
      usePadding: false,
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
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          SbButton.primary(
            label: 'New Project',
            icon: Icons.add,
            onPressed: () => context.push('/projects/create'),
            width: double.infinity,
          ),
          const SizedBox(height: AppSpacing.md),
          if (projects.isEmpty)
            SbEmptyState(
              icon: Icons.folder_off_outlined,
              title: 'No Projects Yet',
              subtitle:
                  'Create your first civil engineering project to get started.',
              actionLabel: 'New Project',
              onAction: () => context.push('/projects/create'),
            )
          else
            ...projects.map((project) {
              final formattedDate =
                  DateFormat('MMM dd, yyyy').format(project.createdAt);
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: ProjectCard(
                  name: project.name,
                  date: formattedDate,
                  location: project.location,
                  logsCount: 0,
                  calcsCount: 0,
                  onTap: () => context.push('/projects/detail', extra: project),
                ),
              );
            }),
        ],
      ),
    );
  }
}
