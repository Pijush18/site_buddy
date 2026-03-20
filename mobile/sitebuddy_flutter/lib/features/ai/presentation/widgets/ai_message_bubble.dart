
/// FILE HEADER
/// ----------------------------------------------
/// File: ai_message_bubble.dart
/// Feature: ai
/// Layer: presentation
///
/// PURPOSE:
/// Singular UI tile for rendering a chat history component safely within strict dimension arrays.
///
/// RESPONSIBILITIES:
/// - Determines distinct alignment/color structures per role.
/// - Wraps text rigorously preventing layout overflows.
/// ----------------------------------------------
library;

import 'package:flutter/material.dart';

import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/features/ai/domain/entities/ai_message.dart';

/// CLASS: AiMessageBubble
class AiMessageBubble extends StatelessWidget {
  final AiMessage message;

  const AiMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    // Role-dependent alignments
    final isUser = message.isUser;
    final align = isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;

    return Padding(
      padding: const EdgeInsets.only(bottom: SbSpacing.lg),
      child: Column(
        crossAxisAlignment: align,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.8,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: SbSpacing.lg,
              vertical: SbSpacing.sm,
            ),
            

            child: Text(
              message.text,
              style: Theme.of(context).textTheme.bodyLarge!,
            ),
          ),
          const SizedBox(height: SbSpacing.xs),
          Text(
            _formatTime(message.timestamp),
            style: Theme.of(context).textTheme.labelMedium!,
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}








