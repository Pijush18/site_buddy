import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SbPage.scaffold(
      title: 'Create Task',
      bottomAction: SbButton.primary(
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
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppLayout.maxContentWidth,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SbInput(
                  controller: _titleController,
                  label: 'Title',
                  hint: 'Task title',
                ),
                const SizedBox(height: AppLayout.pMedium),
                SbInput(
                  controller: _descriptionController,
                  label: 'Description',
                  hint: 'Brief description of the task',
                  maxLines: 3,
                ),
                const SizedBox(height: AppLayout.pMedium),
                SbInput(
                  controller: _projectController,
                  label: 'Project ID',
                  hint: 'e.g., PRJ-001',
                ),
                const SizedBox(height: AppLayout.pLarge),
                Text(
                  'PRIORITY',
                  style: SbTextStyles.caption(context).copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppLayout.pSmall),
                SbDropdown<TaskPriority>(
                  value: _priority,
                  items: TaskPriority.values,
                  itemLabelBuilder: (p) => p.name.toUpperCase(),
                  onChanged: (v) {
                    if (v != null) setState(() => _priority = v);
                  },
                ),
                const SizedBox(height: AppLayout.pLarge),
                SbInput(
                  controller: _assignedController,
                  label: 'Assigned To',
                  hint: 'User name or ID',
                ),
                const SizedBox(height: AppLayout.pLarge),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'DUE DATE',
                            style: SbTextStyles.caption(context).copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: AppLayout.pSmall),
                          Text(
                            _dueDate == null
                                ? 'Not set'
                                : _dueDate!
                                      .toLocal()
                                      .toString()
                                      .split(' ')
                                      .first,
                            style: SbTextStyles.body(context),
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
                const SizedBox(height: AppLayout.pSmall),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
