import 'package:site_buddy/core/design_system/sb_icons.dart';

import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/design_system/sb_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/core/widgets/sb_widgets.dart';

import 'package:go_router/go_router.dart';

import 'package:site_buddy/features/work/application/controllers/create_task_controller.dart';
import 'package:site_buddy/features/work/domain/entities/task.dart';

/// SCREEN: CreateTaskScreen
/// 
/// [REFACTORED] - This screen is now purely declarative.
/// All business logic has been moved to CreateTaskNotifier.
/// 
/// VIOLATIONS FIXED:
/// - ✅ Removed setState for form state (now in Notifier)
/// - ✅ Removed setState for saving state (now in Notifier)
/// - ✅ Removed business logic from UI (now in Notifier)
/// - ✅ UI converted from ConsumerStatefulWidget to ConsumerWidget
class CreateTaskScreen extends ConsumerWidget {
  const CreateTaskScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createTaskControllerProvider);
    final notifier = ref.read(createTaskControllerProvider.notifier);

    return SbPage.form(
      title: 'New Task',
      primaryAction: PrimaryCTA(
        label: 'Create',
        icon: SbIcons.addTask,
        onPressed: state.isSaving
            ? null
            : () async {
                final success = await notifier.submit(ref);
                if (success && context.mounted) {
                  context.pop();
                }
              },
        isLoading: state.isSaving,
        width: double.infinity,
      ),
      body: SbSectionList(
        sections: [
          // Error message
          if (state.error != null)
            SbSection(
              child: Container(
                padding: const EdgeInsets.all(SbSpacing.md),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  state.error!,
                  style: SbTypography.body.copyWith(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                ),
              ),
            ),

          SbSection(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SbInput(
                  label: 'Title',
                  hint: 'Task title',
                  onChanged: notifier.updateTitle,
                ),
                const SizedBox(height: SbSpacing.md),
                SbInput(
                  label: 'Description',
                  hint: 'Brief description of the task',
                  maxLines: 3,
                  onChanged: notifier.updateDescription,
                ),
                const SizedBox(height: SbSpacing.md),
                SbInput(
                  label: 'Project',
                  hint: 'e.g., PRJ-001',
                  onChanged: notifier.updateProjectId,
                ),
                const SizedBox(height: SbSpacing.xl),
                Text(
                  'Priority',
                  style: SbTypography.label,
                ),
                const SizedBox(height: SbSpacing.sm),
                SbDropdown<TaskPriority>(
                  value: state.priority,
                  items: TaskPriority.values,
                  itemLabelBuilder: (p) => p.name.toUpperCase(),
                  onChanged: (v) {
                    if (v != null) notifier.updatePriority(v);
                  },
                ),
                const SizedBox(height: SbSpacing.xl),
                SbInput(
                  label: 'Assigned To',
                  hint: 'User name or ID',
                  onChanged: notifier.updateAssignedTo,
                ),
                const SizedBox(height: SbSpacing.xl),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Due Date',
                            style: SbTypography.label,
                          ),
                          const SizedBox(height: SbSpacing.sm),
                          Text(
                            state.dueDate == null
                                ? 'Not set'
                                : state.dueDate!.toLocal().toString().split(' ').first,
                            style: SbTypography.body,
                          ),
                        ],
                      ),
                    ),
                    GhostButton(
                      label: 'Select',
                      icon: SbIcons.calendar,
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          notifier.updateDueDate(picked);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
