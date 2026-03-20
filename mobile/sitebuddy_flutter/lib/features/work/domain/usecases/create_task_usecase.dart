

import 'package:site_buddy/features/work/domain/entities/task.dart';
import 'package:site_buddy/features/work/domain/repositories/work_repository.dart';

class CreateTaskUseCase {
  final WorkRepository repository;

  const CreateTaskUseCase({required this.repository});

  Future<void> call(Task task) async {
    await repository.createTask(task);
  }
}



