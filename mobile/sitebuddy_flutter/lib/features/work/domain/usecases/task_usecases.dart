import 'package:site_buddy/features/work/domain/entities/task.dart';
import 'package:site_buddy/features/work/domain/repositories/work_repository.dart';

class CreateTaskUseCase {
  final WorkRepository repository;
  const CreateTaskUseCase(this.repository);
  Future<void> execute(Task task) => repository.createTask(task);
}

class UpdateTaskUseCase {
  final WorkRepository repository;
  const UpdateTaskUseCase(this.repository);
  Future<void> execute(Task task) => repository.updateTask(task);
}



