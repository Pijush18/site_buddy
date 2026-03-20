import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:flutter/material.dart';

/// WIDGET: SmartAssistantInput
/// PURPOSE: Standardized input for the AI assistant with a fixed action button.
/// REFACTOR: Professional Color System (Contrast-checked for neutral hero).
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest, 
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colorScheme.outline, width: 1.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: SbSpacing.xs), 
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onSubmitted: (_) => onSend(),
              textInputAction: TextInputAction.send,
              style: theme.textTheme.bodyMedium!,
              decoration: InputDecoration(
                hintText: hintText,
                hintMaxLines: 1,
                hintStyle: theme.textTheme.bodyMedium!,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: SbSpacing.sm,
                  vertical: SbSpacing.sm,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              SbIcons.send, 
              color: colorScheme.primary, 
              size: 20,
            ),
            onPressed: onSend,
            tooltip: 'Send message',
          ),
        ],
      ),
    );
  }
}





