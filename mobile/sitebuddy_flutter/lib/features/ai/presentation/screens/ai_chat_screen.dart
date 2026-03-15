/// FILE HEADER
/// ----------------------------------------------
/// File: ai_chat_screen.dart
/// Feature: ai
/// Layer: presentation
///
/// PURPOSE:
/// The primary interactive fullscreen chat interface.
///
/// RESPONSIBILITIES:
/// - Renders the continuous message list.
/// - Manages keyboard-safe scrolling behavior.
/// - Glues the `AiMessageBubble` to the `AiInputBar`.
/// ----------------------------------------------
library;

import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
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

    return SbPage.detail(
      title: 'Smart Assistant',
      // We overwrite default padding to edge-to-edge for true chat UI layout
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              // Chat History View
              Expanded(
                child: ListView.builder(
                  reverse:
                      false, // Messages are strictly appended to the end of array
                  padding: const EdgeInsets.all(AppLayout.md),
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
          );
        },
      ),
    );
  }
}
