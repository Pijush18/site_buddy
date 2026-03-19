import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/widgets/app_screen_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/features/ai/application/controllers/ai_controller.dart';
import 'package:site_buddy/features/ai/presentation/widgets/ai_message_bubble.dart';
import 'package:site_buddy/features/ai/presentation/widgets/ai_input_bar.dart';

/// CLASS: AiChatScreen
class AiChatScreen extends ConsumerWidget {
  const AiChatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch full state block
    final state = ref.watch(aiProvider);
    final messages = state.messages;

    return AppScreenWrapper(
      title: 'Smart Assistant',
      isScrollable: false,
      usePadding: false,
      child: Column(
        children: [
          // Chat History View
          Expanded(
            child: ListView.builder(
              reverse: false, // Messages are strictly appended to the end of array
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return AiMessageBubble(message: message);
              },
            ),
          ),

          // Bottom Anchor
          const AiInputBar(),
        ],
      ),
    );
  }
}
