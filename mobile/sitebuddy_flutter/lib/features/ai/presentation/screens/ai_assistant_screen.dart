import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:site_buddy/core/navigation/app_routes.dart';

import 'package:site_buddy/features/ai/application/controllers/ai_assistant_controller.dart';
import 'package:site_buddy/features/ai/presentation/widgets/ai_assistant/ai_input_bar.dart';
import 'package:site_buddy/features/ai/presentation/widgets/ai_assistant/ai_response_card.dart';
import 'package:site_buddy/features/ai/presentation/widgets/ai_assistant/ai_share_report_card.dart';

import 'package:site_buddy/features/ai/presentation/widgets/ai_assistant/assistant_guidance_widget.dart';
import 'package:site_buddy/features/ai/presentation/widgets/ai_assistant/onboarding_message.dart';
import 'package:site_buddy/features/ai/presentation/widgets/ai_assistant/ai_action_handlers.dart';
import 'package:site_buddy/features/ai/presentation/widgets/ai_assistant/ai_messages_widgets.dart';

class AiAssistantScreen extends ConsumerStatefulWidget {
  final String? initialTopic;
  const AiAssistantScreen({super.key, this.initialTopic});

  @override
  ConsumerState<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends ConsumerState<AiAssistantScreen> {
  bool _initialized = false;
  final GlobalKey _imageCaptureKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (widget.initialTopic != null && widget.initialTopic!.isNotEmpty) {
      Future.microtask(() {
        if (!mounted) return;
        ref
            .read(aiControllerProvider.notifier)
            .openKnowledgeTopic(context, widget.initialTopic!);
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final initialInput = GoRouterState.of(context).extra;
      if (initialInput is String &&
          initialInput.isNotEmpty &&
          widget.initialTopic == null) {
        Future.microtask(() {
          if (!mounted) return;
          ref
              .read(aiControllerProvider.notifier)
              .processInput(context, initialInput);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(aiControllerProvider);
    final controller = ref.read(aiControllerProvider.notifier);

    return SbPage.scaffold(
      title: 'AI Assistant',
      usePadding: false,
      appBarActions: [
        AppIconButton(
          icon: SbIcons.task,
          onPressed: () {
            final report = controller.generateReport();
            context.push(AppRoutes.reportPreview, extra: report);
          },
        ),
        AppIconButton(
          icon: SbIcons.settings,
          onPressed: () => context.push(AppRoutes.branding),
        ),
      ],
      body: Column(
        children: [
          if (state.response != null)
            Offstage(
              offstage: true,
              child: RepaintBoundary(
                key: _imageCaptureKey,
                child: Material(
                  child: AiShareReportCard(
                    question: state.query,
                    answer: state.response!.knowledge?.definition ??
                        state.response!.conversion?.mainValue.toString() ??
                        'Result',
                    projectName: controller.currentProjectName,
                  ),
                ),
              ),
            ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: SbSpacing.lg),
              physics: const BouncingScrollPhysics(),
              children: [
                if (state.isLoading)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: SbSpacing.xxl),
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                else if (state.response != null) ...[
                  UserMessageWidget(query: state.query),
                  if (state.assistantResponse != null) ...[
                    AssistantGuidanceWidget(response: state.assistantResponse!),
                    const SizedBox(height: SbSpacing.lg),
                  ],
                  AiResponseCard(
                    response: state.response!,
                    onSaveToProject: state.latestChatId == null
                        ? null
                        : () => AiActionHandlers.handleSaveToProject(
                              context,
                              ref,
                              state,
                            ),
                    onShare: () => AiActionHandlers.handleShare(
                      context,
                      state,
                      controller.currentProjectName,
                    ),
                    onCopy: () => AiActionHandlers.handleCopy(
                      context,
                      state,
                      controller.currentProjectName,
                    ),
                    onExportPdf: () => AiActionHandlers.handleExportPdf(
                      state,
                      controller.currentProjectName,
                    ),
                  ),
                ] else if (state.assistantResponse != null)
                  AssistantGuidanceWidget(response: state.assistantResponse!)
                else if (state.error != null)
                  AiErrorWidget(error: state.error!)
                else
                  Container(
                    padding: const EdgeInsets.all(SbSpacing.lg),
                    child: const OnboardingMessage(),
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(SbSpacing.lg),
            child: AiInputBar(
              onChanged: controller.updateInput,
              onSubmit: () => controller.processInput(context),
              isLoading: state.isLoading,
            ),
          ),
        ],
      ),
    );
  }
}
