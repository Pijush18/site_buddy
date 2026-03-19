import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/design_system/sb_text_styles.dart';
/// FILE HEADER
/// ----------------------------------------------
/// File: app_number_field.dart
/// Feature: core
/// Layer: presentation
///
/// PURPOSE:
/// Standard Numeric Input Field strictly for engineering inputs.
///
/// RESPONSIBILITIES:
/// - Enforces numeric-only keyboards with decimals.
/// - Standardizes form field aesthetics across all screens.
///
/// DEPENDENCIES:
/// - Core design constants (AppColors).
///
/// FUTURE IMPROVEMENTS:
/// - Could add min/max validation rules or regex masks.
///
/// ----------------------------------------------

import 'package:flutter/material.dart';

/// CLASS: AppNumberField
/// PURPOSE: A tailored `TextField` ensuring numerical input collection is uniform.
/// WHY: Prevents engineers on site from battling the soft-keyboard by triggering numeric mode instantly.
/// LOGIC: Applies global typography constraints enforcing consistent engineering standards.
class AppNumberField extends StatelessWidget {
  final String label;
  final String? hint;
  final IconData? suffixIcon;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final String? initialValue;
  final String? Function(String?)? validator;
  final String? errorText;
  final VoidCallback? onInfoPressed;

  const AppNumberField({
    super.key,
    required this.label,
    this.hint,
    this.suffixIcon,
    this.controller,
    this.initialValue,
    this.onChanged,
    this.validator,
    this.errorText,
    this.onInfoPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: AppSpacing.xs, bottom: AppSpacing.sm),
          child: Row(
            children: [
              Text(
                label,
                style: SbTextStyles.caption(context).copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              if (onInfoPressed != null) ...[
                const SizedBox(width: AppSpacing.xs),
                GestureDetector(
                  onTap: onInfoPressed,
                  child: Icon(
                    Icons.info_outline,
                    size: 14,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ],
          ),
        ),
        TextFormField(
          controller: controller,
          initialValue: initialValue,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: onChanged,
          validator: validator,
          style: SbTextStyles.title(context).copyWith(
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            hintText: hint ?? '0.00',
            errorText: errorText,
            suffixIcon: suffixIcon != null
                ? Icon(suffixIcon, color: colorScheme.onSurfaceVariant)
                : null,
          ),
        ),
      ],
    );
  }
}