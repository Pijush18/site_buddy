
import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/design_system/sb_radius.dart';
import 'package:site_buddy/core/widgets/app_icon_button.dart';

import 'package:flutter/material.dart';
import 'package:site_buddy/core/theme/app_colors.dart';
import 'package:site_buddy/core/theme/app_border.dart';


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
                  style: textTheme.labelLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
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
          const SizedBox(height: SbSpacing.sm),

        ],
        Container(
          height: maxLines == 1 ? 44.0 : null,

          padding: const EdgeInsets.symmetric(horizontal: SbSpacing.md),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: SbRadius.borderMd,
            border: Border.all(
              color: errorText != null 
                  ? colorScheme.error 
                  : context.colors.outline,
              width: AppBorder.width,
            ),
          ),
          alignment: maxLines == 1 ? Alignment.center : Alignment.topLeft,
          child: Row(
            crossAxisAlignment: maxLines == 1 ? CrossAxisAlignment.center : CrossAxisAlignment.start,
            children: [
              if (prefixIcon != null) ...[
                Padding(
                  padding: EdgeInsets.only(
                    right: SbSpacing.sm,
                    top: maxLines == 1 ? 0 : SbSpacing.sm,
                  ),
                  child: prefixIcon,
                ),
              ],
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: maxLines == 1 ? 0 : SbSpacing.sm,
                  ),
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      if (hint != null && (controller?.text.isEmpty ?? initialValue == null))
                        Text(
                          hint!,
                          style: textTheme.bodyLarge?.copyWith(
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
                        style: textTheme.bodyLarge,
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
                    left: SbSpacing.sm,
                    top: maxLines == 1 ? 0 : SbSpacing.sm,
                  ),
                  child: suffixIcon,
                ),
              ],
            ],
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: SbSpacing.sm),
          Text(
            errorText!,
            style: textTheme.labelSmall?.copyWith(
              color: colorScheme.error,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}






