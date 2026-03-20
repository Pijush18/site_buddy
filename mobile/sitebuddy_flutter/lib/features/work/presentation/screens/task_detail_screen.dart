import 'package:site_buddy/core/design_system/sb_icons.dart';

import 'package:site_buddy/core/design_system/sb_spacing.dart';
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
            style: theme.textTheme.titleLarge!,
          ),
          const SizedBox(height: SbSpacing.lg), // Replaced const SizedBox(height: SbSpacing.lg)
          SbCard(
            child: Column(
              children: [
                SbListItemTile(
                  title: 'Project',
                  onTap: () {}, // Detail view entry
                  trailing: Text(
                    task.projectId,
                    style: theme.textTheme.bodyLarge!,
                  ),
                ),
                SbListItemTile(
                  title: 'Assigned To',
                  onTap: () {}, // Detail view entry
                  trailing: Text(
                    task.assignedTo,
                    style: theme.textTheme.bodyLarge!,
                  ),
                ),
                SbListItemTile(
                  title: 'Priority',
                  onTap: () {}, // Detail view entry
                  trailing: Text(
                    task.priority.name.toUpperCase(),
                    style: theme.textTheme.bodyLarge!,
                  ),
                ),
                SbListItemTile(
                  title: 'Status',
                  onTap: () {}, // Detail view entry
                  trailing: Text(
                    task.status.name.toUpperCase(),
                    style: theme.textTheme.bodyLarge!,
                  ),
                ),
                SbListItemTile(
                  title: 'Due Date',
                  onTap: () {}, // Detail view entry
                  trailing: Text(
                    task.dueDate.toLocal().toString().split(' ').first,
                    style: theme.textTheme.bodyLarge!,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: SbSpacing.xxl), // Replaced AppLayout.vGap24
          Text(
            'DESCRIPTION',
            style: theme.textTheme.labelMedium!,
          ),
          const SizedBox(height: SbSpacing.sm / 2), // Replaced const SizedBox(height: SbSpacing.xs)
          Text(
            task.description.isEmpty
                ? 'No description provided.'
                : task.description,
            style: Theme.of(context).textTheme.bodyLarge!,
          ),
          const SizedBox(height: SbSpacing.xxl), // Replaced AppLayout.vGap32
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
                  const SizedBox(width: SbSpacing.lg), // Replaced const SizedBox(width: SbSpacing.lg)
                  Text(
                    'Task Completed',
                    style: theme.textTheme.bodyLarge!,
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











