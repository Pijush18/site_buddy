

import 'package:site_buddy/features/work/domain/entities/task.dart';
import 'package:site_buddy/features/work/domain/repositories/work_repository.dart';

class UpdateTaskUseCase {
  final WorkRepository repository;

  const UpdateTaskUseCase({required this.repository});

  Future<void> call(Task task) async {
    await repository.updateTask(task);
  }
}



