import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/theme/app_font_sizes.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/core/widgets/sb_widgets.dart';

import 'package:site_buddy/features/work/domain/entities/meeting.dart';
import 'package:site_buddy/features/work/application/controllers/work_controller.dart';

class MeetingDetailScreen extends ConsumerStatefulWidget {
  final Meeting meeting;
  const MeetingDetailScreen({required this.meeting, super.key});

  @override
  ConsumerState<MeetingDetailScreen> createState() =>
      _MeetingDetailScreenState();
}

class _MeetingDetailScreenState extends ConsumerState<MeetingDetailScreen> {
  late TextEditingController _minutesController;

  @override
  void initState() {
    super.initState();
    _minutesController = TextEditingController(
      text: widget.meeting.minutesOfMeeting,
    );
  }

  @override
  void dispose() {
    _minutesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final m = widget.meeting;
    final controller = ref.read(workControllerProvider.notifier);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppScreenWrapper(
      title: 'Meeting Details',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            m.title,
            style: TextStyle(
              fontSize: AppFontSizes.title,
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SbCard(
            child: Column(
              children: [
                SbListItemTile(
                  title: 'Project',
                  onTap: () {}, // Detail view entry
                  trailing: Text(
                    m.projectId,
                    style: const TextStyle(fontSize: AppFontSizes.subtitle),
                  ),
                ),
                SbListItemTile(
                  title: 'Type',
                  onTap: () {}, // Detail view entry
                  trailing: Text(
                    m.meetingType.name.toUpperCase(),
                    style: const TextStyle(fontSize: AppFontSizes.subtitle),
                  ),
                ),
                SbListItemTile(
                  title: 'Mode',
                  onTap: () {}, // Detail view entry
                  trailing: Text(
                    m.mode.name.toUpperCase(),
                    style: const TextStyle(fontSize: AppFontSizes.subtitle),
                  ),
                ),
                SbListItemTile(
                  title: 'Date',
                  onTap: () {}, // Detail view entry
                  trailing: Text(
                    m.meetingDate.toLocal().toString().split(' ').first,
                    style: const TextStyle(fontSize: AppFontSizes.subtitle),
                  ),
                ),
                SbListItemTile(
                  title: 'Time',
                  onTap: () {}, // Detail view entry
                  trailing: Text(
                    '${m.startTime.toLocal().hour.toString().padLeft(2, '0')}:${m.startTime.toLocal().minute.toString().padLeft(2, '0')} - ${m.endTime.toLocal().hour.toString().padLeft(2, '0')}:${m.endTime.toLocal().minute.toString().padLeft(2, '0')}',
                    style: const TextStyle(fontSize: AppFontSizes.subtitle),
                  ),
                ),
                SbListItemTile(
                  title: 'Participants',
                  onTap: () {}, // Detail view entry
                  trailing: Text(
                    m.participants.join(', '),
                    style: const TextStyle(fontSize: AppFontSizes.subtitle),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'DESCRIPTION',
            style: TextStyle(
              fontSize: AppFontSizes.tab,
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.sm / 2), // Replaced AppLayout.xs
          Text(
            m.description.isEmpty ? 'No description provided.' : m.description,
            style: const TextStyle(fontSize: AppFontSizes.subtitle),
          ),
          const SizedBox(height: AppSpacing.lg),
          SbInput(
            controller: _minutesController,
            label: 'Minutes of Meeting',
            hint: 'Record key points...',
            maxLines: 5,
          ),
          const SizedBox(height: AppSpacing.lg * 1.5),
          SbButton.primary(
            label: 'Save & Mark Completed',
            icon: SbIcons.check,
            onPressed: () async {
              final updated = m.copyWith(
                minutesOfMeeting: _minutesController.text,
                status: MeetingStatus.completed,
                updatedAt: DateTime.now(),
              );
              await controller.updateMeeting(updated);
              if (!context.mounted) return;
              context.pop();
            },
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}
