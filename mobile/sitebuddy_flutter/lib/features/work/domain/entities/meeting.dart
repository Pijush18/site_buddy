

/// Types of meetings commonly held on site.
enum MeetingType {
  siteInspection,
  clientMeeting,
  consultantReview,
  contractorMeeting,
  authorityMeeting,
  progressReview,
  boqDiscussion,
  safetyMeeting,
  other,
}

/// Meeting modes.
enum MeetingMode { physical, online }

/// Status of a meeting.
enum MeetingStatus { scheduled, completed, cancelled }

class Meeting {
  final String id;
  final String projectId;
  final String title;
  final String description;
  final MeetingType meetingType;
  final MeetingMode mode;
  final String locationOrLink;
  final List<String> participants;
  final DateTime meetingDate;
  final DateTime startTime;
  final DateTime endTime;
  final MeetingStatus status;
  final String? minutesOfMeeting;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Meeting({
    required this.id,
    required this.projectId,
    required this.title,
    required this.description,
    required this.meetingType,
    required this.mode,
    required this.locationOrLink,
    required this.participants,
    required this.meetingDate,
    required this.startTime,
    required this.endTime,
    required this.status,
    this.minutesOfMeeting,
    required this.createdAt,
    required this.updatedAt,
  });

  Meeting copyWith({
    String? id,
    String? projectId,
    String? title,
    String? description,
    MeetingType? meetingType,
    MeetingMode? mode,
    String? locationOrLink,
    List<String>? participants,
    DateTime? meetingDate,
    DateTime? startTime,
    DateTime? endTime,
    MeetingStatus? status,
    String? minutesOfMeeting,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Meeting(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      title: title ?? this.title,
      description: description ?? this.description,
      meetingType: meetingType ?? this.meetingType,
      mode: mode ?? this.mode,
      locationOrLink: locationOrLink ?? this.locationOrLink,
      participants: participants ?? this.participants,
      meetingDate: meetingDate ?? this.meetingDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
      minutesOfMeeting: minutesOfMeeting ?? this.minutesOfMeeting,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}



