import 'package:site_buddy/features/level_log/domain/entities/level_log_session.dart';

abstract class LevelLogRepository {
  Future<void> init();
  Future<void> saveSession(LevelLogSession session);
  List<LevelLogSession> getLevelLogsForProject(String projectId);
  Future<void> deleteSession(String id);
}
