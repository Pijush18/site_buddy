import 'package:site_buddy/features/project/domain/repositories/project_repository.dart';
import 'package:site_buddy/shared/domain/models/project.dart';

class GetProjectsUseCase {
  final ProjectRepository repository;

  GetProjectsUseCase(this.repository);

  Future<List<Project>> execute() {
    return repository.getProjects();
  }
}
