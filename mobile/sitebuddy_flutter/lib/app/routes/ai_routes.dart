import 'package:go_router/go_router.dart';
import 'package:site_buddy/core/navigation/app_transitions.dart';
import 'package:site_buddy/features/ai/presentation/screens/ai_assistant_screen.dart';
import 'package:site_buddy/features/ai/presentation/screens/ai_history_screen.dart';
import 'package:site_buddy/features/ai/presentation/screens/ai_share_preview_screen.dart';
import 'package:site_buddy/features/unit_converter/presentation/screens/unit_converter_screen.dart';
import 'package:site_buddy/features/currency/presentation/screens/currency_converter_screen.dart';

import 'package:site_buddy/features/ai/presentation/screens/ai_chat_screen.dart';

final aiRoutes = [
      GoRoute(
        path: 'ai/interaction',
        pageBuilder: (context, state) => AppTransitions.fadeSlide(
          state: state,
          child: const AiChatScreen(),
        ),
      ),
      GoRoute(
        path: 'ai/chat',
        pageBuilder: (context, state) => AppTransitions.fadeSlide(
          state: state,
          child: const AiAssistantScreen(),
        ),
      ),
      GoRoute(
        path: 'ai/topic',
        pageBuilder: (context, state) {
          final topicTitle = state.extra as String;
          return AppTransitions.fadeSlide(
            state: state,
            child: AiAssistantScreen(initialTopic: topicTitle),
          );
        },
      ),
      GoRoute(
        path: 'ai-history',
        pageBuilder: (context, state) => AppTransitions.fadeSlide(
          state: state,
          child: const AiHistoryScreen(),
        ),
      ),
      GoRoute(
        path: 'ai/share',
        pageBuilder: (context, state) => AppTransitions.fadeSlide(
          state: state,
          child: const AiSharePreviewScreen(),
        ),
      ),
      GoRoute(
        path: 'converter',
        pageBuilder: (context, state) => AppTransitions.fadeSlide(
          state: state,
          child: const UnitConverterScreen(),
        ),
      ),
      GoRoute(
        path: 'currency',
        pageBuilder: (context, state) => AppTransitions.fadeSlide(
          state: state,
          child: const CurrencyConverterScreen(),
        ),
      ),
];



