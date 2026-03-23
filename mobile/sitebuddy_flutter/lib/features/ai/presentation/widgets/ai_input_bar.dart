import 'package:site_buddy/core/design_system/sb_icons.dart';
/// FILE HEADER
/// ----------------------------------------------
/// File: ai_input_bar.dart
/// Feature: ai
/// Layer: presentation
///
/// PURPOSE:
/// The anchored bottom bar handling user raw text commands dynamically updating the Chat view.
///
/// RESPONSIBILITIES:
/// - Secure keyboard-safe input zone.
/// - Passes requests directly to `AiController.sendMessage()`.
/// ----------------------------------------------

import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/core/theme/app_spacing.dart';

import 'package:site_buddy/features/ai/application/controllers/ai_controller.dart';

/// CLASS: AiInputBar
class AiInputBar extends ConsumerStatefulWidget {
  const AiInputBar({super.key});

  @override
  ConsumerState<AiInputBar> createState() => _AiInputBarState();
}

class _AiInputBarState extends ConsumerState<AiInputBar> {
  final TextEditingController _controller = TextEditingController();

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    // Orchestrate with riverpod provider
    ref.read(aiProvider.notifier).sendMessage(text);
    _controller.clear();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;
    final isLoading = ref.watch(aiProvider).isLoading;
    return SbCard(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.sm,
        bottom:
            AppSpacing.sm +
            MediaQuery.of(context).padding.bottom, // Safe zone
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: SbCard(
              child: SbInput(
                controller: _controller,
                maxLines: 4,
                minLines: 1,
                textInputAction: TextInputAction.send,
                hint: 'Type an engineering query...',
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          SizedBox(
            width: 48,
            height: 48,

            child: AppIconButton(
              icon: isLoading ? SbIcons.hourglass : SbIcons.arrowUp,
              onPressed: isLoading ? null : _send,
              isLoading: isLoading,
            ),
          ),
        ],
      ),
    );
  }
}





