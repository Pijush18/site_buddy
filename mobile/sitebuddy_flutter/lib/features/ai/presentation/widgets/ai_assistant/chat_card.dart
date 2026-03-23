import 'package:site_buddy/core/design_system/sb_icons.dart';

import 'package:site_buddy/core/theme/app_spacing.dart';
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
      case AiIntent.concreteQuantity:
      case AiIntent.brickQuantity:
      case AiIntent.steelWeight:
      case AiIntent.excavationVolume:
      case AiIntent.shutteringArea:
      case AiIntent.slabDesign:
      case AiIntent.beamDesign:
      case AiIntent.columnDesign:
      case AiIntent.footingDesign:
        return 'Navigated to specialized tool.';
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
            padding: const EdgeInsets.all(AppSpacing.sm),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    chat.query,
                    style: Theme.of(context).textTheme.labelLarge!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  _formatTime(),
                  style: Theme.of(context).textTheme.bodyMedium!,
                ),
              ],
            ),
          ),

          // Body: Response snippet
          Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Text(
              _getPreviewText(),
              style: Theme.of(context).textTheme.bodyLarge!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Actions
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
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
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        'Saved to Project',
                        style: Theme.of(context).textTheme.labelMedium!,
                      ),
                    ],
                  )
                else
                  SecondaryButton(isOutlined: true, 
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









