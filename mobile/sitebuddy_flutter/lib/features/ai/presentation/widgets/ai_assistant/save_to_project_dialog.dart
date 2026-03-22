import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';

/// FILE HEADER
/// ----------------------------------------------
/// File: save_to_project_dialog.dart
/// Feature: ai_assistant
/// Layer: presentation/widgets
///
/// PURPOSE:
/// Presents a bottom sheet or dialog to select a project to attach an AI query to.
///
/// RESPONSIBILITIES:
/// - Reads from `ProjectController` to list available projects.
/// - Fires the selection callback to actually execute the link maneuver.
///
/// DEPENDENCIES:
/// - Riverpod `ConsumerWidget`
/// - `ProjectController` state
///
/// FUTURE IMPROVEMENTS:
/// - Add ability to create a "New Project" directly from this dialog.
/// ----------------------------------------------

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/shared/application/providers/project_providers.dart';
import 'package:site_buddy/features/project/application/controllers/project_controller.dart';
import 'package:site_buddy/features/project/domain/models/project.dart';

import 'package:site_buddy/core/widgets/sb_widgets.dart';

class SaveToProjectDialog extends ConsumerWidget {
  /// Defines the action when a user picks a project from the list.
  final Function(Project selectedProject) onProjectSelected;

  const SaveToProjectDialog({super.key, required this.onProjectSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectState = ref.watch(projectControllerProvider);
    final activeProject = ref.watch(activeProjectProvider);

    return SizedBox(
      width: double.maxFinite,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (projectState.isLoading)
            const Center(child: CircularProgressIndicator())
          else if (projectState.projects.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: SbSpacing.lg),
              child: Center(
                child: Text(
                  'No projects available.\nCreate a project first!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge!,
                ),
              ),
            )
          else
            ...projectState.projects.map((project) {
              final isCurrent = project.id == activeProject?.id;
              return SbListItemTile(
                icon: Icons.folder_shared,
                title: project.name,
                subtitle: isCurrent
                    ? 'Current Active Project'
                    : 'Project ID: ${project.id}',
                trailing: isCurrent
                    ? Icon(
                        SbIcons.checkFilled,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : null,
                onTap: () {
                  ref
                      .read(activeProjectProvider.notifier)
                      .setActiveProject(project.id, project.name);
                  Navigator.pop(context);
                },
              );
            }),
        ],
      ),
    );
  }
}







