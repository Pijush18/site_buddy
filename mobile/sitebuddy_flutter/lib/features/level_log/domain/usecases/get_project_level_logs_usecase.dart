import 'package:site_buddy/features/level_log/domain/entities/level_log_session.dart';
import 'package:site_buddy/features/level_log/domain/repositories/level_log_repository.dart';

class GetProjectLevelLogsUseCase {
  final LevelLogRepository repository;

  GetProjectLevelLogsUseCase(this.repository);

  List<LevelLogSession> execute(String projectId) {
    return repository.getLevelLogsForProject(projectId);
  }
}
