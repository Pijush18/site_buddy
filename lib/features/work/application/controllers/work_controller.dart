
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/features/work/domain/entities/task.dart';
import 'package:site_buddy/features/work/domain/entities/meeting.dart';
import 'package:site_buddy/features/work/presentation/providers/work_providers.dart';

/// Tabs available in work dashboard.
enum WorkTab { all, tasks, meetings, calendar }

class WorkState {
  final List<Task> tasks;
  final List<Meeting> meetings;
  final WorkTab selectedTab;
  final bool isLoading;
  final String? error;

  const WorkState({
    this.tasks = const [],
    this.meetings = const [],
    this.selectedTab = WorkTab.all,
    this.isLoading = false,
    this.error,
  });

  WorkState copyWith({
    List<Task>? tasks,
    List<Meeting>? meetings,
    WorkTab? selectedTab,
    bool? isLoading,
    String? error,
  }) {
    return WorkState(
      tasks: tasks ?? this.tasks,
      meetings: meetings ?? this.meetings,
      selectedTab: selectedTab ?? this.selectedTab,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

final workControllerProvider = NotifierProvider<WorkController, WorkState>(
  WorkController.new,
);

class WorkController extends Notifier<WorkState> {
  @override
  WorkState build() {
    // Proactively load on build
    Future.microtask(() => loadAll());
    return const WorkState();
  }

  Future<void> loadAll() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final getUseCase = ref.read(getWorkItemsUseCaseProvider);
      final tasks = await getUseCase.getTasks();
      final meetings = await getUseCase.getMeetings();
      state = state.copyWith(
        tasks: tasks,
        meetings: meetings,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void selectTab(WorkTab tab) {
    state = state.copyWith(selectedTab: tab);
  }

  Future<void> createTask(Task task) async {
    await ref.read(createTaskUseCaseProvider).execute(task);
    await loadAll();
  }

  Future<void> createMeeting(Meeting meeting) async {
    await ref.read(createMeetingUseCaseProvider).execute(meeting);
    await loadAll();
  }

  Future<void> updateTask(Task task) async {
    await ref.read(updateTaskUseCaseProvider).execute(task);
    await loadAll();
  }

  Future<void> updateMeeting(Meeting meeting) async {
    await ref.read(updateMeetingUseCaseProvider).execute(meeting);
    await loadAll();
  }

  // Derived lists
  List<Task> get overdueTasks => state.tasks.where((t) => t.isOverdue).toList();

  List<Task> get pendingTasks =>
      state.tasks.where((t) => t.status == TaskStatus.pending).toList();

  List<Meeting> get scheduledMeetings =>
      state.meetings.where((m) => m.status == MeetingStatus.scheduled).toList();
}
