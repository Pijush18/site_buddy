import 'package:site_buddy/core/theme/app_text_styles.dart';
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
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintMaxLines: 2,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        // Relying on global InputDecorationTheme from AppTheme
      ),
      validator: validator,
      keyboardType: keyboardType,
      obscureText: obscureText,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      onFieldSubmitted: onFieldSubmitted,
      maxLines: maxLines,
      minLines: minLines,
      enabled: enabled,
      textInputAction: textInputAction,
      focusNode: focusNode,
      style: AppTextStyles.body(context),
    );
  }
}
