import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/features/ai/application/controllers/ai_history_controller.dart';
import 'package:site_buddy/features/ai/presentation/widgets/ai_assistant/chat_card.dart';
import 'package:site_buddy/features/ai/presentation/widgets/ai_assistant/save_to_project_dialog.dart';

class AiHistoryScreen extends ConsumerWidget {
  const AiHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(aiHistoryControllerProvider);
    final controller = ref.read(aiHistoryControllerProvider.notifier);

    return AppScreenWrapper(
      title: 'AI Interaction History',
      isScrollable: false,
      child: _buildBody(context, ref, state, controller),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    state,
    AiHistoryController controller,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (state.isLoading && state.chats.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.chats.isEmpty) {
      return Center(
        child: Text(
          state.error!,
          style: TextStyle(color: colorScheme.error),
          textAlign: TextAlign.center,
        ),
      );
    }

    if (state.chats.isEmpty) {
      return const SbEmptyState(
        icon: SbIcons.history,
        title: 'No History Yet',
        subtitle: 'Your AI conversations will appear here automatically.',
      );
    }

    return ListView.separated(
      padding: EdgeInsets.zero,
      physics: const BouncingScrollPhysics(),
      itemCount: state.chats.length,
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppSpacing.md), // Replaced AppLayout.elementGap
      itemBuilder: (context, index) {
        final chat = state.chats[index];
        return ChatCard(
          chat: chat,
          onSaveToProject: () {
            SbFeedback.showDialog(
              context: context,
              title: 'Save to Project',
              content: SaveToProjectDialog(
                onProjectSelected: (project) {
                  controller.linkToProject(chat.id, project.id);
                  SbFeedback.showToast(
                    context: context,
                    message: 'Linked to ${project.name}',
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
