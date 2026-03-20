import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/features/ai/presentation/widgets/ai_assistant/save_to_project_dialog.dart';
import 'package:site_buddy/features/ai/application/controllers/ai_history_controller.dart';
import 'package:site_buddy/core/utils/share_formatter.dart';
import 'package:site_buddy/core/utils/pdf_generator.dart';
import 'package:site_buddy/features/ai/application/controllers/ai_assistant_state.dart';

class AiActionHandlers {
  static void handleSaveToProject(
    BuildContext context,
    WidgetRef ref,
    AiState state,
  ) {
    if (state.latestChatId == null) return;
    SbFeedback.showDialog(
      context: context,
      title: 'Save to Project',
      content: SaveToProjectDialog(
        onProjectSelected: (project) {
          ref
              .read(aiHistoryControllerProvider.notifier)
              .linkToProject(state.latestChatId!, project.id);
          SbFeedback.showToast(
            context: context,
            message: 'Linked to ${project.name}',
          );
        },
      ),
    );
  }

  static void handleShare(
    BuildContext context,
    AiState state,
    String currentProjectName,
  ) {
    if (state.response == null) return;
    context.push(
      '/ai/share',
      extra: {
        'question': state.query,
        'answer':
            state.response!.knowledge?.definition ??
            state.response!.conversion?.mainValue.toString() ??
            'Calculation Result',
        'projectName': currentProjectName,
      },
    );
  }

  static void handleCopy(
    BuildContext context,
    AiState state,
    String currentProjectName,
  ) {
    if (state.response == null) return;
    final question = state.query;
    final answer =
        state.response!.knowledge?.definition ??
        state.response!.conversion?.mainValue.toString() ??
        'Calculation Result';

    Clipboard.setData(
      ClipboardData(
        text: ShareFormatter.format(
          question: question,
          answer: answer,
          projectName: currentProjectName,
        ),
      ),
    );
    SbFeedback.showToast(context: context, message: 'Copied to clipboard!');
  }

  static void handleExportPdf(AiState state, String currentProjectName) {
    if (state.response == null) return;
    PdfGenerator.generateAndSharePdf(
      question: state.query,
      answer:
          state.response!.knowledge?.definition ??
          state.response!.conversion?.mainValue.toString() ??
          'Calculation Result',
      projectName: currentProjectName,
    );
  }
}



