

import 'package:site_buddy/features/work/domain/entities/meeting.dart';
import 'package:site_buddy/features/work/domain/repositories/work_repository.dart';

class UpdateMeetingUseCase {
  final WorkRepository repository;

  const UpdateMeetingUseCase({required this.repository});

  Future<void> call(Meeting meeting) async {
    await repository.updateMeeting(meeting);
  }
}



