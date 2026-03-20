

import 'package:site_buddy/features/work/domain/entities/meeting.dart';
import 'package:site_buddy/features/work/domain/repositories/work_repository.dart';

class CreateMeetingUseCase {
  final WorkRepository repository;

  const CreateMeetingUseCase({required this.repository});

  Future<void> call(Meeting meeting) async {
    await repository.createMeeting(meeting);
  }
}



