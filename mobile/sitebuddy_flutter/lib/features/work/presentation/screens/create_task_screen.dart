import 'package:site_buddy/core/design_system/sb_icons.dart';

import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/core/widgets/sb_widgets.dart';

import 'package:go_router/go_router.dart';

import 'package:site_buddy/features/work/application/controllers/work_controller.dart';
import 'package:site_buddy/features/work/domain/entities/task.dart';

class CreateTaskScreen extends ConsumerStatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  ConsumerState<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends ConsumerState<CreateTaskScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _projectController = TextEditingController();
  final _assignedController = TextEditingController();
  TaskPriority _priority = TaskPriority.low;
  DateTime? _dueDate;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _projectController.dispose();
    _assignedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(workControllerProvider.notifier);

    return SbPage.form(
      title: 'Create Task',
      primaryAction: SbButton.primary(
        label: 'Create Task',
        icon: SbIcons.addTask,
        onPressed: () async {
          if (_titleController.text.isEmpty) {
            SbFeedback.showToast(
              context: context,
              message: 'Please enter a title',
            );
            return;
          }
          final id = DateTime.now().millisecondsSinceEpoch.toString();
          final now = DateTime.now();
          final task = Task(
            id: id,
            projectId: _projectController.text,
            title: _titleController.text,
            description: _descriptionController.text,
            priority: _priority,
            status: TaskStatus.pending,
            assignedTo: _assignedController.text,
            startDate: now,
            dueDate: _dueDate ?? now,
            createdAt: now,
            updatedAt: now,
          );
          await controller.createTask(task);
          if (!context.mounted) return;
          context.pop();
        },
        width: double.infinity,
      ),
      body: SbSectionList(
        sections: [
          SbSection(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SbInput(
                  controller: _titleController,
                  label: 'Title',
                  hint: 'Task title',
                  onChanged: (v) {},
                ),
                const SizedBox(height: SbSpacing.md),
                SbInput(
                  controller: _descriptionController,
                  label: 'Description',
                  hint: 'Brief description of the task',
                  maxLines: 3,
                  onChanged: (v) {},
                ),
                const SizedBox(height: SbSpacing.md),
                SbInput(
                  controller: _projectController,
                  label: 'Project ID',
                  hint: 'e.g., PRJ-001',
                  onChanged: (v) {},
                ),
                const SizedBox(height: SbSpacing.xl),
                Text(
                  'PRIORITY',
                  style: Theme.of(context).textTheme.labelLarge!,
                ),
                const SizedBox(height: SbSpacing.sm),
                SbDropdown<TaskPriority>(
                  value: _priority,
                  items: TaskPriority.values,
                  itemLabelBuilder: (p) => p.name.toUpperCase(),
                  onChanged: (v) {
                    if (v != null) setState(() => _priority = v);
                  },
                ),
                const SizedBox(height: SbSpacing.xl),
                SbInput(
                  controller: _assignedController,
                  label: 'Assigned To',
                  hint: 'User name or ID',
                  onChanged: (v) {},
                ),
                const SizedBox(height: SbSpacing.xl),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'DUE DATE',
                            style: Theme.of(context).textTheme.labelLarge!,
                          ),
                          const SizedBox(height: SbSpacing.sm),
                          Text(
                            _dueDate == null
                                ? 'Not set'
                                : _dueDate!.toLocal().toString().split(' ').first,
                            style: Theme.of(context).textTheme.bodyLarge!,
                          ),
                        ],
                      ),
                    ),
                    SbButton.ghost(
                      label: 'Select',
                      icon: SbIcons.calendar,
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (!mounted) return;
                        if (picked != null) setState(() => _dueDate = picked);
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











