import 'package:site_buddy/core/design_system/sb_radius.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/theme/app_border.dart';

/// WIDGET: SmartAssistantInput
/// PURPOSE: Premium input component for the AI assistant.
/// REFINEMENT: Elevating the "form-like" input into a floating, high-contrast entry point.
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
      height: 40, // Compact (Rule 40)
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: SbRadius.borderMedium,
        border: Border.all(
          color: colorScheme.outline,
          width: AppBorder.width,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: SbSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: SbSpacing.sm),
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  ValueListenableBuilder<TextEditingValue>(
                    valueListenable: controller,
                    builder: (context, value, _) {
                      if (value.text.isEmpty) {
                        return Text(
                          hintText,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  TextField(
                    controller: controller,
                    onSubmitted: (_) => onSend(),
                    textInputAction: TextInputAction.send,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: null, // BARE ENGINE
                    cursorColor: colorScheme.primary,
                  ),
                ],
              ),
            ),
          ),
          // Premium action button anchoring
          Padding(
            padding: const EdgeInsets.symmetric(vertical: SbSpacing.xs),
            child: Material(
              color: colorScheme.primary,
              borderRadius: SbRadius.borderMd,
              child: InkWell(
                onTap: onSend,
                borderRadius: SbRadius.borderMd,
                child: Container(
                  width: 32,
                  height: 32,
                  alignment: Alignment.center,
                  child: Icon(
                    SbIcons.send,
                    color: colorScheme.onPrimary,
                    size: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
