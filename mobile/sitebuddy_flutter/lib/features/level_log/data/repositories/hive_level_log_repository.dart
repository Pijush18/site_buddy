import 'package:hive_flutter/hive_flutter.dart';
import 'package:site_buddy/features/level_log/domain/entities/level_log_session.dart';
import 'package:site_buddy/features/level_log/data/models/level_log_session_model.dart';
import 'package:site_buddy/features/level_log/domain/repositories/level_log_repository.dart';

class HiveLevelLogRepository implements LevelLogRepository {
  static const String sessionBoxName = 'level_log_sessions_v2';

  @override
  Future<void> init() async {
    if (!Hive.isBoxOpen(sessionBoxName)) {
      await Hive.openBox<LevelLogSessionModel>(sessionBoxName);
    }
  }

  @override
  Future<void> saveSession(LevelLogSession session) async {
    if (session.projectId == null) {
      throw StateError('Cannot save session without a projectId');
    }
    final box = Hive.box<LevelLogSessionModel>(sessionBoxName);
    final model = LevelLogSessionModel.fromEntity(session);
    await box.put(model.id, model);
  }

  @override
  List<LevelLogSession> getLevelLogsForProject(String projectId) {
    if (!Hive.isBoxOpen(sessionBoxName)) return [];
    final box = Hive.box<LevelLogSessionModel>(sessionBoxName);
    return box.values
        .where((s) => s.projectId == projectId)
        .map((m) => m.toEntity())
        .toList();
  }

  @override
  Future<void> deleteSession(String id) async {
    final box = Hive.box<LevelLogSessionModel>(sessionBoxName);
    await box.delete(id);
  }
}



