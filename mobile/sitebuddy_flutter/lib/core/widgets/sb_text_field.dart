import 'package:flutter/material.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/design_system/sb_typography.dart';

/// WIDGET: SBTextField
/// PURPOSE: Standardized text input field component.
///
/// FEATURES:
/// - Label display
/// - Hint text
/// - Error state handling
/// - Prefix/suffix icons
/// - Consistent padding, border, radius
///
/// RULES:
/// - Uses SbSpacing for padding
/// - Uses AppRadius for border radius
/// - Uses theme colors for states
class SBTextField extends StatelessWidget {
  /// Optional initial value
  final String? initialValue;

  /// Controller for text input
  final TextEditingController? controller;

  /// Optional label text
  final String? label;

  /// Optional hint text
  final String? hint;

  /// Optional helper/error text
  final String? errorText;

  /// Optional helper text (non-error)
  final String? helperText;

  /// Field validation callback
  final String? Function(String?)? validator;

  /// Keyboard type
  final TextInputType? keyboardType;

  /// Whether to obscure text (for passwords)
  final bool obscureText;

  /// Leading icon widget
  final Widget? prefixIcon;

  /// Trailing icon widget
  final Widget? suffixIcon;

  /// Text change callback
  final ValueChanged<String>? onChanged;

  /// Submit callback
  final ValueChanged<String>? onSubmitted;

  /// Maximum lines (default 1 for single line)
  final int maxLines;

  /// Minimum lines
  final int? minLines;

  /// Whether field is enabled
  final bool enabled;

  /// Text input action
  final TextInputAction? textInputAction;

  /// Focus node
  final FocusNode? focusNode;

  /// Whether to autofocus
  final bool autofocus;

  const SBTextField({
    super.key,
    this.initialValue,
    this.controller,
    this.label,
    this.hint,
    this.errorText,
    this.helperText,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.onSubmitted,
    this.maxLines = 1,
    this.minLines,
    this.enabled = true,
    this.textInputAction,
    this.focusNode,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hasError = errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label
        if (label != null) ...[
          Text(
            label!,
            style: SbTypography.label.copyWith(
              color: hasError
                  ? colorScheme.error
                  : colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: SbSpacing.xs),
        ],

        // Input container
        Container(
          height: maxLines == 1 ? 44.0 : null,
          padding: const EdgeInsets.symmetric(horizontal: SbSpacing.sm),
          decoration: BoxDecoration(
            color: enabled
                ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.3)
                : colorScheme.surfaceContainerHighest.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: hasError
                  ? colorScheme.error
                  : colorScheme.outlineVariant,
              width: hasError ? 1.5 : 1.0,
            ),
          ),
          alignment: maxLines == 1 ? Alignment.center : Alignment.topLeft,
          child: Row(
            crossAxisAlignment:
                maxLines == 1 ? CrossAxisAlignment.center : CrossAxisAlignment.start,
            children: [
              // Prefix icon
              if (prefixIcon != null) ...[
                Padding(
                  padding: EdgeInsets.only(
                    right: SbSpacing.xs,
                    top: maxLines == 1 ? 0 : SbSpacing.xs,
                  ),
                  child: prefixIcon,
                ),
              ],

              // Text field
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: maxLines == 1 ? 0 : SbSpacing.xs,
                  ),
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      // Hint text (shows when empty)
                      if (hint != null &&
                          (controller?.text.isEmpty ?? initialValue == null))
                        Text(
                          hint!,
                          style: SbTypography.body.copyWith(
                            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                      // Actual text field
                      TextFormField(
                        controller: controller,
                        initialValue: controller == null ? initialValue : null,
                        onChanged: onChanged,
                        obscureText: obscureText,
                        keyboardType: keyboardType,
                        textInputAction: textInputAction,
                        focusNode: focusNode,
                        maxLines: maxLines,
                        minLines: minLines,
                        enabled: enabled,
                        autofocus: autofocus,
                        style: SbTypography.body.copyWith(
                          color: colorScheme.onSurface,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        cursorColor: colorScheme.primary,
                        textAlignVertical: TextAlignVertical.center,
                        validator: validator,
                        onFieldSubmitted: onSubmitted,
                      ),
                    ],
                  ),
                ),
              ),

              // Suffix icon
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

        // Error or helper text
        if (errorText != null || helperText != null) ...[
          const SizedBox(height: SbSpacing.xs),
          Text(
            errorText ?? helperText!,
            style: SbTypography.label.copyWith(
              color: hasError ? colorScheme.error : colorScheme.onSurfaceVariant,
              fontWeight: hasError ? FontWeight.w500 : FontWeight.w400,
            ),
            maxLines: hasError ? 1 : 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }
}