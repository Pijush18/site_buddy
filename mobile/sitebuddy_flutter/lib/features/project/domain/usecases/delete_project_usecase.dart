import 'package:site_buddy/shared/domain/repositories/project_repository.dart';

class DeleteProjectUseCase {
  final ProjectRepository repository;

  DeleteProjectUseCase(this.repository);

  Future<void> execute(String id) {
    return repository.deleteProject(id);
  }
}



