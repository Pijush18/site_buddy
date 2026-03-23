import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/features/work/domain/entities/meeting.dart';
import 'package:site_buddy/features/work/application/controllers/work_controller.dart';

/// STATE: CreateMeetingState
/// Holds all state for the create meeting screen.
class CreateMeetingState {
  final String title;
  final String description;
  final String projectId;
  final String location;
  final List<String> participants;
  final MeetingType type;
  final MeetingMode mode;
  final DateTime? date;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final bool isSaving;
  final String? error;

  const CreateMeetingState({
    this.title = '',
    this.description = '',
    this.projectId = '',
    this.location = '',
    this.participants = const [],
    this.type = MeetingType.other,
    this.mode = MeetingMode.physical,
    this.date,
    this.startTime,
    this.endTime,
    this.isSaving = false,
    this.error,
  });

  CreateMeetingState copyWith({
    String? title,
    String? description,
    String? projectId,
    String? location,
    List<String>? participants,
    MeetingType? type,
    MeetingMode? mode,
    DateTime? date,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    bool? isSaving,
    String? error,
    bool clearDate = false,
    bool clearStartTime = false,
    bool clearEndTime = false,
    bool clearError = false,
  }) {
    return CreateMeetingState(
      title: title ?? this.title,
      description: description ?? this.description,
      projectId: projectId ?? this.projectId,
      location: location ?? this.location,
      participants: participants ?? this.participants,
      type: type ?? this.type,
      mode: mode ?? this.mode,
      date: clearDate ? null : (date ?? this.date),
      startTime: clearStartTime ? null : (startTime ?? this.startTime),
      endTime: clearEndTime ? null : (endTime ?? this.endTime),
      isSaving: isSaving ?? this.isSaving,
      error: clearError ? null : (error ?? this.error),
    );
  }

  /// Returns true if form is valid for submission
  bool get isValid => title.trim().isNotEmpty;
}

/// NOTIFIER: CreateMeetingNotifier
/// Manages create meeting form state and submission.
/// All business logic is centralized here - UI is purely declarative.
class CreateMeetingNotifier extends Notifier<CreateMeetingState> {
  @override
  CreateMeetingState build() {
    return const CreateMeetingState();
  }

  void updateTitle(String value) {
    state = state.copyWith(title: value, clearError: true);
  }

  void updateDescription(String value) {
    state = state.copyWith(description: value);
  }

  void updateProjectId(String value) {
    state = state.copyWith(projectId: value);
  }

  void updateLocation(String value) {
    state = state.copyWith(location: value);
  }

  void updateParticipants(String value) {
    final participants = value
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    state = state.copyWith(participants: participants);
  }

  void updateType(MeetingType type) {
    state = state.copyWith(type: type);
  }

  void updateMode(MeetingMode mode) {
    state = state.copyWith(mode: mode);
  }

  void updateDate(DateTime? date) {
    if (date == null) {
      state = state.copyWith(clearDate: true);
    } else {
      state = state.copyWith(date: date);
    }
  }

  void updateStartTime(TimeOfDay? time) {
    if (time == null) {
      state = state.copyWith(clearStartTime: true);
    } else {
      state = state.copyWith(startTime: time);
    }
  }

  void updateEndTime(TimeOfDay? time) {
    if (time == null) {
      state = state.copyWith(clearEndTime: true);
    } else {
      state = state.copyWith(endTime: time);
    }
  }

  /// Submit the meeting - handles all business logic
  Future<bool> submit(WidgetRef ref) async {
    if (!state.isValid) {
      state = state.copyWith(error: 'Please enter a title');
      return false;
    }

    state = state.copyWith(isSaving: true, clearError: true);

    try {
      final id = DateTime.now().millisecondsSinceEpoch.toString();
      final now = DateTime.now();

      final meeting = Meeting(
        id: id,
        projectId: state.projectId,
        title: state.title.trim(),
        description: state.description.trim(),
        meetingType: state.type,
        mode: state.mode,
        locationOrLink: state.location.trim(),
        participants: state.participants,
        meetingDate: state.date ?? now,
        startTime: state.startTime != null
            ? DateTime(now.year, now.month, now.day, state.startTime!.hour, state.startTime!.minute)
            : now,
        endTime: state.endTime != null
            ? DateTime(now.year, now.month, now.day, state.endTime!.hour, state.endTime!.minute)
            : now,
        status: MeetingStatus.scheduled,
        createdAt: now,
        updatedAt: now,
      );

      // Create via work controller
      await ref.read(workControllerProvider.notifier).createMeeting(meeting);

      state = state.copyWith(isSaving: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: 'Failed to create meeting: ${e.toString()}',
      );
      return false;
    }
  }

  void reset() {
    state = const CreateMeetingState();
  }
}

/// Provider for CreateMeetingNotifier
final createMeetingControllerProvider =
    NotifierProvider<CreateMeetingNotifier, CreateMeetingState>(
  CreateMeetingNotifier.new,
);
