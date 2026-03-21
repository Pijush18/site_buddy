import 'package:go_router/go_router.dart';
import 'package:site_buddy/core/navigation/app_transitions.dart';
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
        pageBuilder: (context, state) => AppTransitions.fadeSlide(
          state: state,
          child: const WorkDashboardScreen(),
        ),
      ),
      GoRoute(
        path: '/tasks/detail',
        name: 'taskDetail',
        pageBuilder: (context, state) {
          final task = state.extra as Task;
          return AppTransitions.fadeSlide(
            state: state,
            child: TaskDetailScreen(task: task),
          );
        },
      ),
      GoRoute(
        path: '/tasks/create',
        name: 'createTask',
        pageBuilder: (context, state) => AppTransitions.fadeSlide(
          state: state,
          child: const CreateTaskScreen(),
        ),
      ),
      GoRoute(
        path: '/meetings/detail',
        name: 'meetingDetail',
        pageBuilder: (context, state) {
          final meeting = state.extra as Meeting;
          return AppTransitions.fadeSlide(
            state: state,
            child: MeetingDetailScreen(meeting: meeting),
          );
        },
      ),
      GoRoute(
        path: '/meetings/create',
        name: 'createMeeting',
        pageBuilder: (context, state) => AppTransitions.fadeSlide(
          state: state,
          child: const CreateMeetingScreen(),
        ),
      ),
];



