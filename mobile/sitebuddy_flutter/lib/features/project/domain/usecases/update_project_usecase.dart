import 'package:site_buddy/shared/domain/repositories/project_repository.dart';
import 'package:site_buddy/features/project/domain/models/project.dart';

class UpdateProjectUseCase {
  final ProjectRepository repository;

  UpdateProjectUseCase(this.repository);

  Future<Project> execute(Project project) {
    return repository.updateProject(project);
  }
}




