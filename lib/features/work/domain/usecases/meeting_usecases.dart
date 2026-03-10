import 'package:site_buddy/features/work/domain/entities/meeting.dart';
import 'package:site_buddy/features/work/domain/repositories/work_repository.dart';

class CreateMeetingUseCase {
  final WorkRepository repository;
  const CreateMeetingUseCase(this.repository);
  Future<void> execute(Meeting meeting) => repository.createMeeting(meeting);
}

class UpdateMeetingUseCase {
  final WorkRepository repository;
  const UpdateMeetingUseCase(this.repository);
  Future<void> execute(Meeting meeting) => repository.updateMeeting(meeting);
}
