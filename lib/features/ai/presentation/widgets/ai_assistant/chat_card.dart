import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/shared/domain/models/ai_chat.dart';
import 'package:site_buddy/shared/domain/models/ai_intent.dart';

class ChatCard extends StatelessWidget {
  final AiChat chat;
  final VoidCallback onSaveToProject;

  const ChatCard({
    super.key,
    required this.chat,
    required this.onSaveToProject,
  });

  String _getPreviewText() {
    if (chat.response.error != null) {
      return chat.response.error!;
    }
    switch (chat.response.intent) {
      case AiIntent.knowledge:
        return chat.response.knowledge?.definition ?? 'Knowledge retrieved';
      case AiIntent.conversion:
        final mainVal = chat.response.conversion?.mainValue.toStringAsFixed(2);
        return 'Result: $mainVal ${chat.response.conversionToTitle}';
      case AiIntent.calculation:
      case AiIntent.calculateConcrete:
        return 'Requires: ${chat.response.calculation?.cementBags} Cement Bags';
      case AiIntent.createProject:
      case AiIntent.addToProject:
      case AiIntent.fetchProject:
      case AiIntent.leveling:
      case AiIntent.unknown:
        return 'Interaction logged.';
    }
  }

  String _formatTime() {
    final hour = chat.timestamp.hour.toString().padLeft(2, '0');
    final minute = chat.timestamp.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final bool isLinked = chat.projectId != null;

    return SbCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header: User Query + Timestamp
          Container(
            padding: const EdgeInsets.all(AppLayout.pSmall),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    chat.query,
                    style: SbTextStyles.title(context).copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                AppLayout.hGap8,
                Text(
                  _formatTime(),
                  style: SbTextStyles.bodySecondary(context),
                ),
              ],
            ),
          ),

          // Body: Response snippet
          Padding(
            padding: const EdgeInsets.all(AppLayout.pSmall),
            child: Text(
              _getPreviewText(),
              style: SbTextStyles.body(context).copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Actions
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppLayout.md,
              vertical: AppLayout.pSmall,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (isLinked)
                  Row(
                    children: [
                      Icon(
                        SbIcons.checkFilled,
                        size: 20,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      AppLayout.hGap8,
                      Text(
                        'Saved to Project',
                        style: SbTextStyles.caption(context).copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  )
                else
                  SbButton.outline(
                    label: 'Save to Project',
                    icon: SbIcons.bookmarkAdd,
                    onPressed: onSaveToProject,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
