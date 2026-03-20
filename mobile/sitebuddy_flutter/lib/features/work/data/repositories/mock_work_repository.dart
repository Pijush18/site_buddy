

import 'dart:async';

import 'package:site_buddy/features/work/domain/entities/task.dart';
import 'package:site_buddy/features/work/domain/entities/meeting.dart';
import 'package:site_buddy/features/work/domain/repositories/work_repository.dart';

class MockWorkRepository implements WorkRepository {
  final List<Task> _tasks = [];
  final List<Meeting> _meetings = [];

  MockWorkRepository() {
    // preload sample data
    final now = DateTime.now();
    _tasks.addAll([
      Task(
        id: 't1',
        projectId: 'p1',
        title: 'Excavation',
        description: 'Excavate foundation area',
        priority: TaskPriority.high,
        status: TaskStatus.pending,
        assignedTo: 'worker1',
        startDate: now.subtract(const Duration(days: 3)),
        dueDate: now.add(const Duration(days: 4)),
        createdAt: now.subtract(const Duration(days: 4)),
        updatedAt: now.subtract(const Duration(days: 3)),
      ),
      Task(
        id: 't2',
        projectId: 'p2',
        title: 'Formwork',
        description: 'Prepare formwork for slab',
        priority: TaskPriority.medium,
        status: TaskStatus.inProgress,
        assignedTo: 'worker2',
        startDate: now.subtract(const Duration(days: 1)),
        dueDate: now.add(const Duration(days: 6)),
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
    ]);

    _meetings.addAll([
      Meeting(
        id: 'm1',
        projectId: 'p1',
        title: 'Site Inspection',
        description: 'Inspect excavation progress',
        meetingType: MeetingType.siteInspection,
        mode: MeetingMode.physical,
        locationOrLink: 'Site Office',
        participants: ['manager1', 'engineer1'],
        meetingDate: now.add(const Duration(days: 1)),
        startTime: now.add(const Duration(days: 1, hours: 9)),
        endTime: now.add(const Duration(days: 1, hours: 10)),
        status: MeetingStatus.scheduled,
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
      Meeting(
        id: 'm2',
        projectId: 'p2',
        title: 'Client Meeting',
        description: 'Discuss project changes',
        meetingType: MeetingType.clientMeeting,
        mode: MeetingMode.online,
        locationOrLink: 'https://meet.link',
        participants: ['client1', 'pm1'],
        meetingDate: now.add(const Duration(days: 2)),
        startTime: now.add(const Duration(days: 2, hours: 14)),
        endTime: now.add(const Duration(days: 2, hours: 15)),
        status: MeetingStatus.scheduled,
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now.subtract(const Duration(days: 2)),
      ),
    ]);
  }

  @override
  Future<void> createMeeting(Meeting meeting) async {
    _meetings.add(meeting);
  }

  @override
  Future<void> createTask(Task task) async {
    _tasks.add(task);
  }

  @override
  Future<List<Meeting>> getMeetings() async {
    // return copy
    return List.unmodifiable(_meetings);
  }

  @override
  Future<List<Task>> getTasks() async {
    return List.unmodifiable(_tasks);
  }

  @override
  Future<void> updateMeeting(Meeting meeting) async {
    final idx = _meetings.indexWhere((m) => m.id == meeting.id);
    if (idx != -1) {
      _meetings[idx] = meeting;
    }
  }

  @override
  Future<void> updateTask(Task task) async {
    final idx = _tasks.indexWhere((t) => t.id == task.id);
    if (idx != -1) {
      _tasks[idx] = task;
    }
  }
}



