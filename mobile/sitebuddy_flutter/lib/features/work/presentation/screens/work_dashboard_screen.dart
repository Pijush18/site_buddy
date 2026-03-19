import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';

import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/features/work/application/controllers/work_controller.dart';
import 'package:site_buddy/features/work/domain/entities/task.dart';
import 'package:site_buddy/features/work/domain/entities/meeting.dart';

class WorkDashboardScreen extends ConsumerWidget {
  const WorkDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(workControllerProvider);
    final controller = ref.read(workControllerProvider.notifier);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // trigger load once
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!state.isLoading && state.tasks.isEmpty && state.meetings.isEmpty) {
        controller.loadAll();
      }
    });

    Widget buildTaskCard(Task t) {
      Color priorityColor;
      switch (t.priority) {
        case TaskPriority.low:
          priorityColor = colorScheme.primary;
          break;
        case TaskPriority.medium:
          priorityColor = colorScheme.tertiary;
          break;
        case TaskPriority.high:
          priorityColor = colorScheme.error;
          break;
        case TaskPriority.critical:
          priorityColor = colorScheme.primary;
          break;
      }
      return Dismissible(
        key: ValueKey(t.id),
        direction: DismissDirection.endToStart,
        onDismissed: (_) async {
          final updated = t.copyWith(
            status: TaskStatus.completed,
            completionDate: DateTime.now(),
            updatedAt: DateTime.now(),
          );
          await controller.updateTask(updated);
        },
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(SbIcons.checkFilled, color: colorScheme.primary),
        ),
        child: SbListItemTile(
          icon: SbIcons.task,
          title: t.title,
          subtitle: 'Project ${t.projectId} • Due ${t.dueDate.toLocal().toString().split(' ').first}',
          onTap: () {
            context.push('/tasks/detail', extra: t);
          },
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  t.status.name.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Container(width: 4, height: 40, color: priorityColor),
            ],
          ),
        ),
      );
    }

    Widget buildMeetingCard(Meeting m) {
      IconData icon;
      switch (m.meetingType) {
        case MeetingType.siteInspection:
          icon = Icons.search;
          break;
        case MeetingType.clientMeeting:
          icon = SbIcons.profile;
          break;
        default:
          icon = SbIcons.meeting;
      }
      return SbListItemTile(
        icon: icon,
        title: m.title,
        subtitle: '${m.meetingDate.toLocal().toString().split(' ').first} • ${m.mode.name}',
        onTap: () {
          context.push('/meetings/detail', extra: m);
        },
        trailing: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: colorScheme.secondaryContainer.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            m.status.name.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: colorScheme.secondary,
            ),
          ),
        ),
      );
    }

    List<Widget> bodyItems = [];
    switch (state.selectedTab) {
      case WorkTab.tasks:
        bodyItems = state.tasks.map(buildTaskCard).toList();
        break;
      case WorkTab.meetings:
        bodyItems = state.meetings.map(buildMeetingCard).toList();
        break;
      case WorkTab.calendar:
        bodyItems = state.meetings.map(buildMeetingCard).toList();
        break;
      case WorkTab.all:
        bodyItems.addAll(state.tasks.map(buildTaskCard));
        bodyItems.addAll(state.meetings.map(buildMeetingCard));
        break;
    }

    return AppScreenWrapper(
      title: 'Work Management',
      isScrollable: false,
      actions: [
        IconButton(
          icon: const Icon(SbIcons.add),
          onPressed: () {
            SbFeedback.showBottomSheet(
              context: context,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SbListItemTile(
                    icon: SbIcons.addTask,
                    iconColor: colorScheme.primary,
                    title: 'Create Task',
                    onTap: () {
                      context.pop();
                      context.push('/tasks/create');
                    },
                  ),
                  SbListItemTile(
                    icon: SbIcons.meeting,
                    iconColor: colorScheme.secondary,
                    title: 'Schedule Meeting',
                    onTap: () {
                      context.pop();
                      context.push('/meetings/create');
                    },
                  ),
                  const SizedBox(height: AppSpacing.md), // Replaced AppLayout.vGap16
                ],
              ),
            );
          },
        ),
      ],
      child: Column(
        children: [
          SbDropdown<WorkTab>(
            items: WorkTab.values,
            value: state.selectedTab,
            itemLabelBuilder: (tab) => tab.name.toUpperCase(),
            onChanged: (val) {
              if (val != null) controller.selectTab(val);
            },
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : bodyItems.isEmpty
                    ? const SbEmptyState(
                        icon: SbIcons.task,
                        title: 'No Items Yet',
                        subtitle: 'Tap the "+" icon to create one.',
                      )
                    : ListView.separated(
                        padding: EdgeInsets.zero,
                        itemCount: bodyItems.length,
                        separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.sm), // Replaced AppLayout.vGap8
                        itemBuilder: (context, index) => bodyItems[index],
                      ),
          ),
        ],
      ),
    );
  }
}
