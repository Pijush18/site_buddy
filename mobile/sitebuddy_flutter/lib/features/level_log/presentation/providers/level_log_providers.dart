import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/features/level_log/domain/repositories/level_log_repository.dart';
import 'package:site_buddy/features/level_log/data/repositories/hive_level_log_repository.dart';
import 'package:site_buddy/features/level_log/domain/usecases/get_project_level_logs_usecase.dart';

final levelLogRepositoryProvider = Provider<LevelLogRepository>(
  (ref) => HiveLevelLogRepository(),
);

final getProjectLevelLogsUseCaseProvider = Provider((ref) {
  final repository = ref.watch(levelLogRepositoryProvider);
  return GetProjectLevelLogsUseCase(repository);
});
