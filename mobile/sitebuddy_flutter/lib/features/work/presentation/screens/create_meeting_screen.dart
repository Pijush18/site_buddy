import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_radius.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/design_system/sb_typography.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/theme/app_border.dart';

import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/core/widgets/sb_widgets.dart';

import 'package:site_buddy/features/work/application/controllers/create_meeting_controller.dart';
import 'package:site_buddy/features/work/domain/entities/meeting.dart';

/// SCREEN: CreateMeetingScreen
/// 
/// [REFACTORED] - This screen is now purely declarative.
/// All business logic has been moved to CreateMeetingNotifier.
/// 
/// VIOLATIONS FIXED:
/// - ✅ Removed setState for form state (now in Notifier)
/// - ✅ Removed setState for saving state (now in Notifier)
/// - ✅ Removed business logic from UI (now in Notifier)
/// - ✅ UI converted from ConsumerStatefulWidget to ConsumerWidget
class CreateMeetingScreen extends ConsumerWidget {
  const CreateMeetingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createMeetingControllerProvider);
    final notifier = ref.read(createMeetingControllerProvider.notifier);

    return SbPage.form(
      title: 'New Meeting',
      primaryAction: PrimaryCTA(
        label: 'Schedule',
        icon: SbIcons.calendar,
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
                  borderRadius: BorderRadius.circular(SbRadius.standard),
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
                  hint: 'Meeting title',
                  onChanged: notifier.updateTitle,
                ),
                const SizedBox(height: SbSpacing.md),
                SbInput(
                  label: 'Description',
                  hint: 'Brief agenda or summary',
                  maxLines: 3,
                  onChanged: notifier.updateDescription,
                ),
                const SizedBox(height: SbSpacing.md),
                SbInput(
                  label: 'Project',
                  hint: 'Associated project',
                  onChanged: notifier.updateProjectId,
                ),
                const SizedBox(height: SbSpacing.xl),
                Text(
                  'Type',
                  style: SbTypography.label,
                ),
                const SizedBox(height: SbSpacing.sm),
                SbDropdown<MeetingType>(
                  value: state.type,
                  items: MeetingType.values,
                  itemLabelBuilder: (e) => e.name.toUpperCase(),
                  onChanged: (v) {
                    if (v != null) notifier.updateType(v);
                  },
                ),
                const SizedBox(height: SbSpacing.xl),
                Text(
                  'Mode',
                  style: SbTypography.label,
                ),
                const SizedBox(height: SbSpacing.sm),
                SbDropdown<MeetingMode>(
                  value: state.mode,
                  items: MeetingMode.values,
                  itemLabelBuilder: (e) => e.name.toUpperCase(),
                  onChanged: (v) {
                    if (v != null) notifier.updateMode(v);
                  },
                ),
                const SizedBox(height: SbSpacing.xl),
                SbInput(
                  label: 'Location',
                  hint: 'Where is it happening?',
                  onChanged: notifier.updateLocation,
                ),
                const SizedBox(height: SbSpacing.md),
                SbInput(
                  label: 'Participants',
                  hint: 'Comma separated names',
                  onChanged: notifier.updateParticipants,
                ),
                const SizedBox(height: SbSpacing.xl),
                // Date Picker
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Date',
                            style: SbTypography.label,
                          ),
                          const SizedBox(height: SbSpacing.sm),
                          Text(
                            state.date == null
                                ? 'Not set'
                                : state.date!.toLocal().toString().split(' ').first,
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
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          notifier.updateDate(picked);
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: SbSpacing.md),
                // Time Pickers
                Row(
                  children: [
                    Expanded(
                      child: _TimePickerField(
                        label: 'Start',
                        value: state.startTime,
                        onTap: () async {
                          final t = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (t != null) {
                            notifier.updateStartTime(t);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: SbSpacing.md),
                    Expanded(
                      child: _TimePickerField(
                        label: 'End',
                        value: state.endTime,
                        onTap: () async {
                          final t = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (t != null) {
                            notifier.updateEndTime(t);
                          }
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
}

/// Internal widget for time picker field
class _TimePickerField extends StatelessWidget {
  final String label;
  final TimeOfDay? value;
  final VoidCallback onTap;

  const _TimePickerField({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: SbTypography.label,
        ),
        const SizedBox(height: SbSpacing.sm),
        InkWell(
          onTap: onTap,
          borderRadius: SbRadius.borderSmall,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: SbSpacing.md,
              vertical: SbSpacing.sm,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.outline,
                width: AppBorder.width,
              ),
              borderRadius: SbRadius.borderMd,
            ),
            child: Row(
              children: [
                Icon(
                  SbIcons.time,
                  size: 20,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: SbSpacing.sm),
                Expanded(
                  child: Text(
                    value == null ? 'Not set' : value!.format(context),
                    style: SbTypography.body,
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
