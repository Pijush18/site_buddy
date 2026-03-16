import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/theme/app_font_sizes.dart';
import 'package:site_buddy/core/widgets/app_screen_wrapper.dart';
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppScreenWrapper(
      title: 'Schedule Meeting',
      footer: SbButton.primary(
        label: 'Schedule Meeting',
        icon: SbIcons.calendar,
        onPressed: () => _submit(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SbInput(
            controller: _titleController,
            label: 'Title',
            hint: 'Meeting title',
          ),
          const SizedBox(height: AppSpacing.md), // Replaced AppLayout.vGap16
          SbInput(
            controller: _descriptionController,
            label: 'Description',
            hint: 'Brief agenda or summary',
            maxLines: 3,
          ),
          const SizedBox(height: AppSpacing.md), // Replaced AppLayout.vGap16
          SbInput(
            controller: _projectController,
            label: 'Project ID',
            hint: 'Associated project',
          ),
          const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24
          Text(
            'MEETING TYPE',
            style: TextStyle(
              fontSize: AppFontSizes.tab,
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.sm), // Replaced AppLayout.vGap8
          SbDropdown<MeetingType>(
            value: _type,
            items: MeetingType.values,
            itemLabelBuilder: (e) => e.name.toUpperCase(),
            onChanged: (v) {
              if (v != null) setState(() => _type = v);
            },
          ),
          const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24
          Text(
            'MODE',
            style: TextStyle(
              fontSize: AppFontSizes.tab,
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.sm), // Replaced AppLayout.vGap8
          SbDropdown<MeetingMode>(
            value: _mode,
            items: MeetingMode.values,
            itemLabelBuilder: (e) => e.name.toUpperCase(),
            onChanged: (v) {
              if (v != null) setState(() => _mode = v);
            },
          ),
          const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24
          SbInput(
            controller: _locationController,
            label: 'Location / Link',
            hint: 'Where is it happening?',
          ),
          const SizedBox(height: AppSpacing.md), // Replaced AppLayout.vGap16
          SbInput(
            controller: _participantsController,
            label: 'Participants',
            hint: 'Comma separated names',
          ),
          const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24
          // Date Picker
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DATE',
                      style: TextStyle(
                        fontSize: AppFontSizes.tab,
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm), // Replaced AppLayout.vGap8
                    Text(
                      _date == null
                          ? 'Not set'
                          : _date!.toLocal().toString().split(' ').first,
                      style: const TextStyle(fontSize: AppFontSizes.subtitle),
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
          const SizedBox(height: AppSpacing.md), // Replaced AppLayout.vGap16
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
              const SizedBox(width: AppSpacing.md), // Replaced AppLayout.hGap16
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
          const SizedBox(height: AppSpacing.lg), // Buffer
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
          style: TextStyle(
            fontSize: AppFontSizes.tab,
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.sm), // Replaced AppLayout.vGap8
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: 10,
            ),
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
                const SizedBox(width: AppSpacing.sm), // Replaced AppLayout.hGap8
                Expanded(
                  child: Text(
                    value,
                    style: const TextStyle(fontSize: AppFontSizes.subtitle),
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
