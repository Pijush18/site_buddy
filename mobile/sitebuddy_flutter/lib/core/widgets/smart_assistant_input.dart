import 'package:site_buddy/core/design_system/sb_radius.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/theme/app_colors.dart';
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
      height: 52,
      decoration: BoxDecoration(
        color: colorScheme.surface, // Pop against Hero background
        borderRadius: SbRadius.borderMedium,
        border: Border.all(
          color: context.colors.outline,
          width: AppBorder.width,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: SbSpacing.sm), 
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: SbSpacing.md),
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  ValueListenableBuilder<TextEditingValue>(
                    valueListenable: controller,
                    builder: (context, value, _) {
                      if (value.text.isEmpty) {
                        return Text(
                          hintText,
                          style: theme.textTheme.bodyLarge?.copyWith(
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
                    style: theme.textTheme.bodyLarge?.copyWith(
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
            padding: const EdgeInsets.only(right: SbSpacing.xs),
            child: Material(
              color: colorScheme.primary,
              borderRadius: SbRadius.borderMd,
              child: InkWell(
                onTap: onSend,
                borderRadius: SbRadius.borderMd,
                child: Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  child: Icon(
                    SbIcons.send, 
                    color: colorScheme.onPrimary, 
                    size: 20,
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
