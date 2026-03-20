import 'package:go_router/go_router.dart';
import 'package:site_buddy/features/ai/presentation/screens/ai_assistant_screen.dart';
import 'package:site_buddy/features/ai/presentation/screens/ai_history_screen.dart';
import 'package:site_buddy/features/ai/presentation/screens/ai_share_preview_screen.dart';
import 'package:site_buddy/features/unit_converter/presentation/screens/unit_converter_screen.dart';
import 'package:site_buddy/features/currency/presentation/screens/currency_converter_screen.dart';

import 'package:site_buddy/features/ai/presentation/screens/ai_chat_screen.dart';

final aiRoutes = [
  GoRoute(
    path: 'ai/interaction',
    builder: (context, state) => const AiChatScreen(),
  ),
  GoRoute(
    path: 'ai/chat',
    builder: (context, state) => const AiAssistantScreen(),
  ),
  GoRoute(
    path: 'ai/topic',
    builder: (context, state) {
      final topicTitle = state.extra as String;
      return AiAssistantScreen(initialTopic: topicTitle);
    },
  ),
  GoRoute(
    path: 'ai-history',
    builder: (context, state) => const AiHistoryScreen(),
  ),
  GoRoute(
    path: 'ai/share',
    builder: (context, state) => const AiSharePreviewScreen(),
  ),
  GoRoute(
    path: 'converter',
    builder: (context, state) => const UnitConverterScreen(),
  ),
  GoRoute(
    path: 'currency',
    builder: (context, state) => const CurrencyConverterScreen(),
  ),
];



