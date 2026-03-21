import 'package:site_buddy/core/design_system/sb_icons.dart';

import 'package:site_buddy/core/design_system/sb_spacing.dart';
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

    return SbPage.form(
      title: 'Meeting Details',
      primaryAction: PrimaryCTA(
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
        width: double.infinity,
      ),
      body: SbSectionList(
        sections: [
          SbSection(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  m.title,
                  style: Theme.of(context).textTheme.titleLarge!,
                ),
                const SizedBox(height: SbSpacing.lg),
                SbCard(
                  child: Column(
                    children: [
                      SbListItemTile(
                        title: 'Project',
                        onTap: () {}, // Detail view entry
                        trailing: Text(
                          m.projectId,
                          style: Theme.of(context).textTheme.bodyLarge!,
                        ),
                      ),
                      SbListItemTile(
                        title: 'Type',
                        onTap: () {}, // Detail view entry
                        trailing: Text(
                          m.meetingType.name.toUpperCase(),
                          style: Theme.of(context).textTheme.bodyLarge!,
                        ),
                      ),
                      SbListItemTile(
                        title: 'Mode',
                        onTap: () {}, // Detail view entry
                        trailing: Text(
                          m.mode.name.toUpperCase(),
                          style: Theme.of(context).textTheme.bodyLarge!,
                        ),
                      ),
                      SbListItemTile(
                        title: 'Date',
                        onTap: () {}, // Detail view entry
                        trailing: Text(
                          m.meetingDate.toLocal().toString().split(' ').first,
                          style: Theme.of(context).textTheme.bodyLarge!,
                        ),
                      ),
                      SbListItemTile(
                        title: 'Time',
                        onTap: () {}, // Detail view entry
                        trailing: Text(
                          '${m.startTime.toLocal().hour.toString().padLeft(2, '0')}:${m.startTime.toLocal().minute.toString().padLeft(2, '0')} - ${m.endTime.toLocal().hour.toString().padLeft(2, '0')}:${m.endTime.toLocal().minute.toString().padLeft(2, '0')}',
                          style: Theme.of(context).textTheme.bodyLarge!,
                        ),
                      ),
                      SbListItemTile(
                        title: 'Participants',
                        onTap: () {}, // Detail view entry
                        trailing: Text(
                          m.participants.join(', '),
                          style: Theme.of(context).textTheme.bodyLarge!,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: SbSpacing.xxl),
                Text(
                  'DESCRIPTION',
                  style: Theme.of(context).textTheme.labelLarge!,
                ),
                const SizedBox(height: SbSpacing.sm / 2),
                Text(
                  m.description.isEmpty
                      ? 'No description provided.'
                      : m.description,
                  style: Theme.of(context).textTheme.bodyLarge!,
                ),
                const SizedBox(height: SbSpacing.xxl),
                SbInput(
                  controller: _minutesController,
                  label: 'Minutes of Meeting',
                  hint: 'Record key points...',
                  maxLines: 5,
                  onChanged: (v) {},
                ),
                const SizedBox(height: SbSpacing.xxl),
              ],
            ),
          ),
        ],
      ),
    );
  }
}









