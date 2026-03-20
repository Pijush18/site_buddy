import 'package:site_buddy/core/theme/app_text_styles.dart';
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

import 'package:flutter/material.dart';

import 'package:site_buddy/core/theme/app_layout.dart';
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
    final textColor = isUser
        ? Theme.of(context).colorScheme.onPrimary
        : Theme.of(context).colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppLayout.md),
      child: Column(
        crossAxisAlignment: align,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.8,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppLayout.pMedium,
              vertical: AppLayout.pSmall,
            ),
            

            child: Text(
              message.text,
              style: AppTextStyles.body(context).copyWith(color: textColor),
            ),
          ),
          AppLayout.vGap4,
          Text(
            _formatTime(message.timestamp),
            style: AppTextStyles.caption(context).copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}