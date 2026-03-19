import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/theme/app_font_sizes.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/core/widgets/sb_widgets.dart';

import 'package:site_buddy/features/work/domain/entities/task.dart';
import 'package:site_buddy/features/work/application/controllers/work_controller.dart';

class TaskDetailScreen extends ConsumerWidget {
  final Task task;
  const TaskDetailScreen({required this.task, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(workControllerProvider.notifier);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppScreenWrapper(
      title: 'Task Details',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            task.title,
            style: TextStyle(
              fontSize: AppFontSizes.title,
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.md), // Replaced AppLayout.vGap16
          SbCard(
            child: Column(
              children: [
                SbListItemTile(
                  title: 'Project',
                  onTap: () {}, // Detail view entry
                  trailing: Text(
                    task.projectId,
                    style: const TextStyle(fontSize: AppFontSizes.subtitle),
                  ),
                ),
                SbListItemTile(
                  title: 'Assigned To',
                  onTap: () {}, // Detail view entry
                  trailing: Text(
                    task.assignedTo,
                    style: const TextStyle(fontSize: AppFontSizes.subtitle),
                  ),
                ),
                SbListItemTile(
                  title: 'Priority',
                  onTap: () {}, // Detail view entry
                  trailing: Text(
                    task.priority.name.toUpperCase(),
                    style: TextStyle(
                      fontSize: AppFontSizes.subtitle,
                      fontWeight: FontWeight.bold,
                      color:
                          (task.priority == TaskPriority.critical ||
                                  task.priority == TaskPriority.high)
                              ? colorScheme.error
                              : colorScheme.primary,
                    ),
                  ),
                ),
                SbListItemTile(
                  title: 'Status',
                  onTap: () {}, // Detail view entry
                  trailing: Text(
                    task.status.name.toUpperCase(),
                    style: const TextStyle(fontSize: AppFontSizes.subtitle),
                  ),
                ),
                SbListItemTile(
                  title: 'Due Date',
                  onTap: () {}, // Detail view entry
                  trailing: Text(
                    task.dueDate.toLocal().toString().split(' ').first,
                    style: const TextStyle(fontSize: AppFontSizes.subtitle),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24
          Text(
            'DESCRIPTION',
            style: TextStyle(
              fontSize: AppFontSizes.tab,
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.sm / 2), // Replaced AppLayout.vGap4
          Text(
            task.description.isEmpty
                ? 'No description provided.'
                : task.description,
            style: const TextStyle(fontSize: AppFontSizes.subtitle),
          ),
          const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap32
          if (task.status != TaskStatus.completed) ...[
            SbButton.primary(
              label: 'Mark as Completed',
              icon: SbIcons.checkFilled,
              onPressed: () async {
                final updated = task.copyWith(
                  status: TaskStatus.completed,
                  completionDate: DateTime.now(),
                  updatedAt: DateTime.now(),
                );
                await controller.updateTask(updated);
                if (!context.mounted) return;
                context.pop();
              },
            ),
          ] else ...[
            SbCard(
              color: colorScheme.primary.withValues(alpha: 0.1),
              child: Row(
                children: [
                  Icon(SbIcons.checkFilled, color: colorScheme.primary),
                  const SizedBox(width: AppSpacing.md), // Replaced AppLayout.hGap16
                  Text(
                    'Task Completed',
                    style: TextStyle(
                      fontSize: AppFontSizes.subtitle,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
