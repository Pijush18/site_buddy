import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/features/work/domain/repositories/work_repository.dart';
import 'package:site_buddy/features/work/data/repositories/mock_work_repository.dart';
import 'package:site_buddy/features/work/domain/usecases/get_work_items_usecase.dart';
import 'package:site_buddy/features/work/domain/usecases/task_usecases.dart';
import 'package:site_buddy/features/work/domain/usecases/meeting_usecases.dart';

final workRepositoryProvider = Provider<WorkRepository>((ref) {
  return MockWorkRepository();
});

final getWorkItemsUseCaseProvider = Provider((ref) {
  final repo = ref.watch(workRepositoryProvider);
  return GetWorkItemsUseCase(repository: repo);
});

final createTaskUseCaseProvider = Provider((ref) {
  final repo = ref.watch(workRepositoryProvider);
  return CreateTaskUseCase(repo);
});

final updateTaskUseCaseProvider = Provider((ref) {
  final repo = ref.watch(workRepositoryProvider);
  return UpdateTaskUseCase(repo);
});

final createMeetingUseCaseProvider = Provider((ref) {
  final repo = ref.watch(workRepositoryProvider);
  return CreateMeetingUseCase(repo);
});

final updateMeetingUseCaseProvider = Provider((ref) {
  final repo = ref.watch(workRepositoryProvider);
  return UpdateMeetingUseCase(repo);
});
