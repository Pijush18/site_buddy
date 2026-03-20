import 'package:site_buddy/core/design_system/sb_spacing.dart';

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
          padding: const EdgeInsets.only(left: SbSpacing.xs, bottom: SbSpacing.sm),
          child: Row(
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.labelMedium!,
              ),
              if (onInfoPressed != null) ...[
                const SizedBox(width: SbSpacing.xs),
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
          style: Theme.of(context).textTheme.titleMedium!,
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







