import 'package:site_buddy/shared/domain/repositories/project_repository.dart';
import 'package:site_buddy/shared/domain/models/project.dart';

class CreateProjectUseCase {
  final ProjectRepository repository;

  CreateProjectUseCase(this.repository);

  Future<Project> execute(Project project) {
    return repository.createProject(project);
  }
}



