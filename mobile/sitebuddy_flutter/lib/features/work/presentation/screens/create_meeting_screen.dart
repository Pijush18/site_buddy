import 'package:site_buddy/core/design_system/sb_icons.dart';

import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/core/widgets/sb_widgets.dart';

import 'package:site_buddy/features/work/application/controllers/work_controller.dart';
import 'package:site_buddy/features/work/domain/entities/meeting.dart';

class CreateMeetingScreen extends ConsumerStatefulWidget {
  const CreateMeetingScreen({super.key});

  @override
  ConsumerState<CreateMeetingScreen> createState() =>
      _CreateMeetingScreenState();
}

class _CreateMeetingScreenState extends ConsumerState<CreateMeetingScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _projectController = TextEditingController();
  final _locationController = TextEditingController();
  final _participantsController = TextEditingController();
  MeetingType _type = MeetingType.other;
  MeetingMode _mode = MeetingMode.physical;
  DateTime? _date;
  TimeOfDay? _start;
  TimeOfDay? _end;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _projectController.dispose();
    _locationController.dispose();
    _participantsController.dispose();
    super.dispose();
  }

  Future<void> _submit(BuildContext context) async {
    if (_titleController.text.isEmpty) {
      SbFeedback.showToast(context: context, message: 'Please enter a title');
      return;
    }
    final controller = ref.read(workControllerProvider.notifier);
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final now = DateTime.now();
    final meeting = Meeting(
      id: id,
      projectId: _projectController.text,
      title: _titleController.text,
      description: _descriptionController.text,
      meetingType: _type,
      mode: _mode,
      locationOrLink: _locationController.text,
      participants: _participantsController.text
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList(),
      meetingDate: _date ?? now,
      startTime: _start != null
          ? DateTime(now.year, now.month, now.day, _start!.hour, _start!.minute)
          : now,
      endTime: _end != null
          ? DateTime(now.year, now.month, now.day, _end!.hour, _end!.minute)
          : now,
      status: MeetingStatus.scheduled,
      createdAt: now,
      updatedAt: now,
    );
    await controller.createMeeting(meeting);
    if (!context.mounted) return;
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return SbPage.form(
      title: 'Schedule Meeting',
      primaryAction: SbButton.primary(
        label: 'Schedule Meeting',
        icon: SbIcons.calendar,
        onPressed: () => _submit(context),
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
                  hint: 'Meeting title',
                  onChanged: (v) {},
                ),
                const SizedBox(height: SbSpacing.lg),
                SbInput(
                  controller: _descriptionController,
                  label: 'Description',
                  hint: 'Brief agenda or summary',
                  maxLines: 3,
                  onChanged: (v) {},
                ),
                const SizedBox(height: SbSpacing.lg),
                SbInput(
                  controller: _projectController,
                  label: 'Project ID',
                  hint: 'Associated project',
                  onChanged: (v) {},
                ),
                const SizedBox(height: SbSpacing.xxl),
                Text(
                  'MEETING TYPE',
                  style: Theme.of(context).textTheme.labelLarge!,
                ),
                const SizedBox(height: SbSpacing.sm),
                SbDropdown<MeetingType>(
                  value: _type,
                  items: MeetingType.values,
                  itemLabelBuilder: (e) => e.name.toUpperCase(),
                  onChanged: (v) {
                    if (v != null) setState(() => _type = v);
                  },
                ),
                const SizedBox(height: SbSpacing.xxl),
                Text(
                  'MODE',
                  style: Theme.of(context).textTheme.labelLarge!,
                ),
                const SizedBox(height: SbSpacing.sm),
                SbDropdown<MeetingMode>(
                  value: _mode,
                  items: MeetingMode.values,
                  itemLabelBuilder: (e) => e.name.toUpperCase(),
                  onChanged: (v) {
                    if (v != null) setState(() => _mode = v);
                  },
                ),
                const SizedBox(height: SbSpacing.xxl),
                SbInput(
                  controller: _locationController,
                  label: 'Location / Link',
                  hint: 'Where is it happening?',
                  onChanged: (v) {},
                ),
                const SizedBox(height: SbSpacing.lg),
                SbInput(
                  controller: _participantsController,
                  label: 'Participants',
                  hint: 'Comma separated names',
                  onChanged: (v) {},
                ),
                const SizedBox(height: SbSpacing.xxl),
                // Date Picker
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'DATE',
                            style: Theme.of(context).textTheme.labelLarge!,
                          ),
                          const SizedBox(height: SbSpacing.sm),
                          Text(
                            _date == null
                                ? 'Not set'
                                : _date!.toLocal().toString().split(' ').first,
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
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (!mounted) return;
                        if (picked != null) setState(() => _date = picked);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: SbSpacing.lg),
                // Time Pickers
                Row(
                  children: [
                    Expanded(
                      child: _buildTimePicker(
                        context,
                        'START TIME',
                        _start == null ? 'Not set' : _start!.format(context),
                        () async {
                          final t = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (!mounted) return;
                          if (t != null) setState(() => _start = t);
                        },
                      ),
                    ),
                    const SizedBox(width: SbSpacing.lg),
                    Expanded(
                      child: _buildTimePicker(
                        context,
                        'END TIME',
                        _end == null ? 'Not set' : _end!.format(context),
                        () async {
                          final t = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (!mounted) return;
                          if (t != null) setState(() => _end = t);
                        },
                      ),
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

  Widget _buildTimePicker(
    BuildContext context,
    String label,
    String value,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge!,
        ),
        const SizedBox(height: SbSpacing.sm), // Replaced const SizedBox(height: SbSpacing.sm)
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: SbSpacing.lg, vertical: SbSpacing.sm),
            decoration: BoxDecoration(
              border: Border.all(color: colorScheme.outlineVariant),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  SbIcons.time,
                  size: 20,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: SbSpacing.sm), // Replaced const SizedBox(width: SbSpacing.sm)
                Expanded(
                  child: Text(
                    value,
                    style: Theme.of(context).textTheme.bodyLarge!,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}











