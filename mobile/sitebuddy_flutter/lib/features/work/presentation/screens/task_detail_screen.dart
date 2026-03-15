import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
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

    return SbPage.detail(
      title: 'Task Details',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            task.title,
            style: SbTextStyles.title(context).copyWith(
              color: colorScheme.primary,
            ),
          ),
          AppLayout.vGap16,
          SbCard(
            child: Column(
              children: [
                SbListItem(
                  title: 'Project',
                  trailing: Text(
                    task.projectId,
                    style: SbTextStyles.body(context),
                  ),
                ),
                SbListItem(
                  title: 'Assigned To',
                  trailing: Text(
                    task.assignedTo,
                    style: SbTextStyles.body(context),
                  ),
                ),
                SbListItem(
                  title: 'Priority',
                  trailing: Text(
                    task.priority.name.toUpperCase(),
                    style: SbTextStyles.body(context).copyWith(
                      color:
                          (task.priority == TaskPriority.critical ||
                              task.priority == TaskPriority.high)
                          ? colorScheme.error
                          : null,
                    ),
                  ),
                ),
                SbListItem(
                  title: 'Status',
                  trailing: Text(
                    task.status.name.toUpperCase(),
                    style: SbTextStyles.body(context),
                  ),
                ),
                SbListItem(
                  title: 'Due Date',
                  trailing: Text(
                    task.dueDate.toLocal().toString().split(' ').first,
                    style: SbTextStyles.body(context),
                  ),
                ),
              ],
            ),
          ),
          AppLayout.vGap24,
          Text(
            'DESCRIPTION',
            style: SbTextStyles.caption(context).copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          AppLayout.vGap4,
          Text(
            task.description.isEmpty
                ? 'No description provided.'
                : task.description,
            style: SbTextStyles.body(context),
          ),
          AppLayout.vGap32,
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
                  AppLayout.hGap16,
                  Text(
                    'Task Completed',
                    style: SbTextStyles.title(context).copyWith(
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
