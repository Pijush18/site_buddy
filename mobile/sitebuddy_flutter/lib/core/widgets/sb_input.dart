
import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/design_system/sb_radius.dart';
import 'package:site_buddy/core/widgets/app_icon_button.dart';

import 'package:flutter/material.dart';

/// WIDGET: SbInput
/// PURPOSE: Standardized text input for SiteBuddy.
class SbInput extends StatelessWidget {
  final String? initialValue;
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onFieldSubmitted;
  final int? maxLines;
  final int? minLines;
  final bool enabled;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;

  final String? errorText;
  final VoidCallback? onInfoPressed;

  const SbInput({
    super.key,
    this.initialValue,
    this.controller,
    this.label,
    this.hint,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.maxLines = 1,
    this.minLines,
    this.enabled = true,
    this.textInputAction,
    this.focusNode,
    this.errorText,
    this.onInfoPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Row(
            children: [
              Expanded(
                child: Text(
                  label!,
                  style: textTheme.labelMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (onInfoPressed != null)
                AppIconButton(
                  icon: SbIcons.info,
                  onPressed: onInfoPressed,
                  compact: true,
                ),
            ],
          ),
          const SizedBox(height: SbSpacing.xs), // Compact
        ],
        Container(
          height: maxLines == 1 ? 40.0 : null, // Compact height

          padding: const EdgeInsets.symmetric(horizontal: SbSpacing.sm),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(SbRadius.standard),
            border: Border.all(
              color: colorScheme.outlineVariant,
              width: 1.0,
            ),
          ),
          alignment: maxLines == 1 ? Alignment.center : Alignment.topLeft,
          child: Row(
            crossAxisAlignment: maxLines == 1 ? CrossAxisAlignment.center : CrossAxisAlignment.start,
            children: [
              if (prefixIcon != null) ...[
                Padding(
                  padding: EdgeInsets.only(
                    right: SbSpacing.xs,
                    top: maxLines == 1 ? 0 : SbSpacing.xs,
                  ),
                  child: prefixIcon,
                ),
              ],
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: maxLines == 1 ? 0 : SbSpacing.xs,
                  ),
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      if (hint != null && (controller?.text.isEmpty ?? initialValue == null))
                        Text(
                          hint!,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      TextField(
                        controller: controller,
                        onChanged: onChanged,
                        obscureText: obscureText,
                        keyboardType: keyboardType,
                        textInputAction: textInputAction,
                        focusNode: focusNode,
                        maxLines: maxLines,
                        minLines: minLines,
                        enabled: enabled,
                        style: textTheme.bodyMedium,
                        decoration: null, // BARE ENGINE
                        cursorColor: colorScheme.primary,
                        textAlignVertical: TextAlignVertical.center,
                      ),
                    ],
                  ),
                ),
              ),
              if (suffixIcon != null) ...[
                Padding(
                  padding: EdgeInsets.only(
                    left: SbSpacing.xs,
                    top: maxLines == 1 ? 0 : SbSpacing.xs,
                  ),
                  child: suffixIcon,
                ),
              ],
            ],
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: SbSpacing.xs),
          Text(
            errorText!,
            style: textTheme.labelSmall?.copyWith(
              color: colorScheme.error,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }
}






