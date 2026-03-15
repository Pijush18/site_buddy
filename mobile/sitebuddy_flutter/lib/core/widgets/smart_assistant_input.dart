import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/ui/app_decorations.dart';

/// WIDGET: SmartAssistantInput
/// PURPOSE: Standardized input for the AI assistant with a fixed action button.
/// DESIGN: Uses AppDecorations.sbInputDecoration for consistent visual language.
class SmartAssistantInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final String hintText;

  const SmartAssistantInput({
    super.key,
    required this.controller,
    required this.onSend,
    this.hintText = 'Ask anything...',
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: AppDecorations.sbInputDecoration(context),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onSubmitted: (_) => onSend(),
              textInputAction: TextInputAction.send,
              style: SbTextStyles.body(context).copyWith(
                color: colorScheme.onPrimary,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintMaxLines: 2,
                hintStyle: SbTextStyles.body(context).copyWith(
                  color: colorScheme.onPrimary.withValues(alpha: 0.6),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppLayout.pMedium,
                  vertical: 14,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
              ),
            ),
          ),
          AppLayout.hGap12,
          IconButton(
            icon: Icon(SbIcons.send, color: colorScheme.onPrimary),
            onPressed: onSend,
            tooltip: 'Send message',
          ),
          AppLayout.hGap16,
        ],
      ),
    );
  }
}