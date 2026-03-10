

import 'package:site_buddy/features/work/domain/entities/task.dart';
import 'package:site_buddy/features/work/domain/entities/meeting.dart';

abstract class WorkRepository {
  Future<List<Task>> getTasks();
  Future<List<Meeting>> getMeetings();
  Future<void> createTask(Task task);
  Future<void> updateTask(Task task);
  Future<void> createMeeting(Meeting meeting);
  Future<void> updateMeeting(Meeting meeting);
}
