

import 'package:site_buddy/features/work/domain/entities/task.dart';
import 'package:site_buddy/features/work/domain/entities/meeting.dart';
import 'package:site_buddy/features/work/domain/repositories/work_repository.dart';

class GetWorkItemsUseCase {
  final WorkRepository repository;

  const GetWorkItemsUseCase({required this.repository});

  Future<List<Task>> getTasks() async {
    return repository.getTasks();
  }

  Future<List<Meeting>> getMeetings() async {
    return repository.getMeetings();
  }
}



