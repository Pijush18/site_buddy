

/// Priority levels for a task.
enum TaskPriority { low, medium, high, critical }

/// Current status of a task.
enum TaskStatus { pending, inProgress, completed }

class Task {
  final String id;
  final String projectId;
  final String title;
  final String description;
  final TaskPriority priority;
  final TaskStatus status;
  final String assignedTo;
  final DateTime startDate;
  final DateTime dueDate;
  final DateTime? completionDate;
  final String? originMeetingId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Task({
    required this.id,
    required this.projectId,
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    required this.assignedTo,
    required this.startDate,
    required this.dueDate,
    this.completionDate,
    this.originMeetingId,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Derived property to check if task is overdue.
  bool get isOverdue {
    final now = DateTime.now();
    return status != TaskStatus.completed && dueDate.isBefore(now);
  }

  Task copyWith({
    String? id,
    String? projectId,
    String? title,
    String? description,
    TaskPriority? priority,
    TaskStatus? status,
    String? assignedTo,
    DateTime? startDate,
    DateTime? dueDate,
    DateTime? completionDate,
    String? originMeetingId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Task(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      assignedTo: assignedTo ?? this.assignedTo,
      startDate: startDate ?? this.startDate,
      dueDate: dueDate ?? this.dueDate,
      completionDate: completionDate ?? this.completionDate,
      originMeetingId: originMeetingId ?? this.originMeetingId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}



