import 'package:site_buddy/features/structural/shared/domain/repositories/structural_repository.dart';

class GetProjectStructuralCalculationsUseCase {
  final StructuralRepository repository;

  GetProjectStructuralCalculationsUseCase(this.repository);

  Map<String, List<dynamic>> execute(String projectId) {
    return {
      'columns': repository.getColumnsForProject(projectId),
      'beams': repository.getBeamsForProject(projectId),
      'slabs': repository.getSlabsForProject(projectId),
      'footings': repository.getFootingsForProject(projectId),
    };
  }
}




