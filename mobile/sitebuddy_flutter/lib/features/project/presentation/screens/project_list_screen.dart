import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/theme/app_font_sizes.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/features/project/application/controllers/project_controller.dart';
import 'package:site_buddy/core/network/connectivity_service.dart';

/// SCREEN: ProjectListScreen
/// PURPOSE: List all civil engineering projects following the Predefined Layout System.
/// RULE: AppScreenWrapper → SbSectionList → Local Components.
class ProjectListScreen extends ConsumerWidget {
  const ProjectListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(projectControllerProvider);
    final projects = state.projects;

    return AppScreenWrapper(
      title: 'Projects',
      isScrollable: true, // Switched to true to support SbSectionList's internal scrolling if needed
      usePadding: true,
      actions: [
        Consumer(
          builder: (context, ref, _) {
            final isOnline = ref.watch(connectivityProvider).value ?? true;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Row(
                children: [
                  Icon(
                    isOnline ? SbIcons.checkFilled : SbIcons.warning,
                    size: 16,
                    color: isOnline ? Colors.green : Colors.orange,
                  ),
                  const SizedBox(width: AppSpacing.sm),
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
      // ── PREDEFINED LAYOUT SYSTEM ──
      // SbSectionList centralizes the vertical rhythm (24px gap).
      child: SbSectionList(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        sections: [
          // ── SECTION 1: PRIMARY ACTION ──
          SbButton.primary(
            label: 'New Project',
            icon: Icons.add,
            onPressed: () => context.push('/projects/create'),
            width: double.infinity,
          ),

          // ── SECTION 2: DATA LIST ──
          if (projects.isEmpty)
            SbEmptyState(
              icon: Icons.folder_off_outlined,
              title: 'No Projects Yet',
              subtitle: 'Create your first civil engineering project to get started.',
              actionLabel: 'New Project',
              onAction: () => context.push('/projects/create'),
            )
          else
            ...projects.map((project) {
              final formattedDate = DateFormat('MMM dd, yyyy').format(project.createdAt);
              return ProjectCard(
                name: project.name,
                date: formattedDate,
                location: project.location,
                logsCount: 0,
                calcsCount: 0,
                onTap: () => context.push('/projects/detail', extra: project),
              );
            }),
        ],
      ),
    );
  }
}
