import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_surface.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/design_system/sb_text_styles.dart';
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
          padding: AppLayout.paddingLarge,
          child: Icon(SbIcons.checkFilled, color: SbSurface.card(context)),
        ),
        child: SbCard(
          onTap: () {
            context.push('/tasks/detail', extra: t);
          },
          child: Row(
            children: [
              Container(width: 4, height: 40, color: priorityColor),
              AppLayout.hGap8,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.title,
                      style: SbTextStyles.title(context),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    AppLayout.vGap4,
                    Text(
                      'Project ${t.projectId} • Due ${t.dueDate.toLocal().toString().split(' ').first}',
                      style: SbTextStyles.bodySecondary(context).copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              AppLayout.hGap8,
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppLayout.pSmall,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppLayout.smallRadius),
                ),
                child: Text(
                  t.status.name.toUpperCase(),
                  style: SbTextStyles.caption(context).copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
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
      return SbCard(
        onTap: () {
          context.push('/meetings/detail', extra: m);
        },
        child: Row(
          children: [
            Icon(icon, color: colorScheme.primary, size: 20),
            AppLayout.hGap8,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    m.title,
                    style: SbTextStyles.title(context),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  AppLayout.vGap4,
                  Text(
                    '${m.meetingDate.toLocal().toString().split(' ').first} • ${m.mode.name}',
                    style: SbTextStyles.bodySecondary(context).copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            AppLayout.hGap8,
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppLayout.pSmall,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppLayout.smallRadius),
              ),
              child: Text(
                m.status.name.toUpperCase(),
                style: SbTextStyles.caption(context).copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
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

    return SbPage.list(
      title: 'Work Management',
      appBarActions: [
        SbButton.icon(
          icon: SbIcons.add,
          onPressed: () {
            SbFeedback.showBottomSheet(
              context: context,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SbListItem(
                    leading: Icon(SbIcons.addTask, color: colorScheme.primary),
                    title: 'Create Task',
                    onTap: () {
                      context.pop();
                      context.push('/tasks/create');
                    },
                  ),
                  SbListItem(
                    leading: Icon(
                      SbIcons.meeting,
                      color: colorScheme.secondary,
                    ),
                    title: 'Schedule Meeting',
                    onTap: () {
                      context.pop();
                      context.push('/meetings/create');
                    },
                  ),
                  AppLayout.vGap16,
                ],
              ),
            );
          },
        ),
      ],
      header: SbDropdown<WorkTab>(
        items: WorkTab.values,
        value: state.selectedTab,
        itemLabelBuilder: (tab) => tab.name.toUpperCase(),
        onChanged: (val) {
          if (val != null) controller.selectTab(val);
        },
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : bodyItems.isEmpty
              ? const SbEmptyState(
                  icon: SbIcons.task,
                  title: 'No Items Yet',
                  subtitle: 'Tap the "+" icon to create one.',
                )
              : ListView.separated(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: bodyItems.length,
                  separatorBuilder: (context, index) => AppLayout.vGap8,
                  itemBuilder: (context, index) => bodyItems[index],
                ),
    );
  }
}
