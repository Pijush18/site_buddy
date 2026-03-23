import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:site_buddy/features/work/domain/entities/task.dart';
import 'package:site_buddy/features/work/application/controllers/work_controller.dart';

/// STATE: CreateTaskState
/// Holds all state for the create task screen.
class CreateTaskState {
  final String title;
  final String description;
  final String projectId;
  final String assignedTo;
  final TaskPriority priority;
  final DateTime? dueDate;
  final bool isSaving;
  final String? error;

  const CreateTaskState({
    this.title = '',
    this.description = '',
    this.projectId = '',
    this.assignedTo = '',
    this.priority = TaskPriority.low,
    this.dueDate,
    this.isSaving = false,
    this.error,
  });

  CreateTaskState copyWith({
    String? title,
    String? description,
    String? projectId,
    String? assignedTo,
    TaskPriority? priority,
    DateTime? dueDate,
    bool? isSaving,
    String? error,
    bool clearDueDate = false,
    bool clearError = false,
  }) {
    return CreateTaskState(
      title: title ?? this.title,
      description: description ?? this.description,
      projectId: projectId ?? this.projectId,
      assignedTo: assignedTo ?? this.assignedTo,
      priority: priority ?? this.priority,
      dueDate: clearDueDate ? null : (dueDate ?? this.dueDate),
      isSaving: isSaving ?? this.isSaving,
      error: clearError ? null : (error ?? this.error),
    );
  }

  /// Returns true if form is valid for submission
  bool get isValid => title.trim().isNotEmpty;
}

/// NOTIFIER: CreateTaskNotifier
/// Manages create task form state and submission.
/// All business logic is centralized here - UI is purely declarative.
class CreateTaskNotifier extends Notifier<CreateTaskState> {
  @override
  CreateTaskState build() {
    return const CreateTaskState();
  }

  void updateTitle(String value) {
    state = state.copyWith(title: value, clearError: true);
  }

  void updateDescription(String value) {
    state = state.copyWith(description: value);
  }

  void updateProjectId(String value) {
    state = state.copyWith(projectId: value);
  }

  void updateAssignedTo(String value) {
    state = state.copyWith(assignedTo: value);
  }

  void updatePriority(TaskPriority priority) {
    state = state.copyWith(priority: priority);
  }

  void updateDueDate(DateTime? date) {
    if (date == null) {
      state = state.copyWith(clearDueDate: true);
    } else {
      state = state.copyWith(dueDate: date);
    }
  }

  /// Submit the task - handles all business logic
  Future<bool> submit(WidgetRef ref) async {
    if (!state.isValid) {
      state = state.copyWith(error: 'Please enter a title');
      return false;
    }

    state = state.copyWith(isSaving: true, clearError: true);

    try {
      final id = DateTime.now().millisecondsSinceEpoch.toString();
      final now = DateTime.now();

      final task = Task(
        id: id,
        projectId: state.projectId,
        title: state.title.trim(),
        description: state.description.trim(),
        priority: state.priority,
        status: TaskStatus.pending,
        assignedTo: state.assignedTo.trim(),
        startDate: now,
        dueDate: state.dueDate ?? now,
        createdAt: now,
        updatedAt: now,
      );

      // Create via work controller
      await ref.read(workControllerProvider.notifier).createTask(task);

      state = state.copyWith(isSaving: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: 'Failed to create task: ${e.toString()}',
      );
      return false;
    }
  }

  void reset() {
    state = const CreateTaskState();
  }
}

/// Provider for CreateTaskNotifier
final createTaskControllerProvider =
    NotifierProvider<CreateTaskNotifier, CreateTaskState>(
  CreateTaskNotifier.new,
);
