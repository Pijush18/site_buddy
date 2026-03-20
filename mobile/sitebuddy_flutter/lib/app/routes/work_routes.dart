import 'package:go_router/go_router.dart';
import 'package:site_buddy/features/work/presentation/screens/work_dashboard_screen.dart';
import 'package:site_buddy/features/work/presentation/screens/task_detail_screen.dart';
import 'package:site_buddy/features/work/presentation/screens/create_task_screen.dart';
import 'package:site_buddy/features/work/presentation/screens/meeting_detail_screen.dart';
import 'package:site_buddy/features/work/presentation/screens/create_meeting_screen.dart';
import 'package:site_buddy/features/work/domain/entities/task.dart';
import 'package:site_buddy/features/work/domain/entities/meeting.dart';

final workRoutes = [
  GoRoute(
    path: '/tasks',
    name: 'tasks',
    builder: (context, state) => const WorkDashboardScreen(),
  ),
  GoRoute(
    path: '/tasks/detail',
    name: 'taskDetail',
    builder: (context, state) {
      final task = state.extra as Task;
      return TaskDetailScreen(task: task);
    },
  ),
  GoRoute(
    path: '/tasks/create',
    name: 'createTask',
    builder: (context, state) => const CreateTaskScreen(),
  ),
  GoRoute(
    path: '/meetings/detail',
    name: 'meetingDetail',
    builder: (context, state) {
      final meeting = state.extra as Meeting;
      return MeetingDetailScreen(meeting: meeting);
    },
  ),
  GoRoute(
    path: '/meetings/create',
    name: 'createMeeting',
    builder: (context, state) => const CreateMeetingScreen(),
  ),
];



