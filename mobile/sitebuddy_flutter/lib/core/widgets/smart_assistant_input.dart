import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/ui/app_decorations.dart';

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
      decoration: AppDecorations.sbInputDecoration(context).copyWith(
        color: colorScheme.surface.withValues(alpha: 0.6), // Slightly clearer on hero
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4), // Internal shift
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onSubmitted: (_) => onSend(),
              textInputAction: TextInputAction.send,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface, // 👈 High contrast for neutral hero
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintMaxLines: 1,
                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
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
              color: colorScheme.primary, // 👈 Branding accent
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