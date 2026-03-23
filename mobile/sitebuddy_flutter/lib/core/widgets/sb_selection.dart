import 'package:site_buddy/core/design_system/sb_radius.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';

/// WIDGET: SbCheckbox
/// PURPOSE: Standardized checkbox with consistent spacing, radius, and typography.
class SbCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final String? label;

  const SbCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final checkbox = Checkbox(
      value: value,
      onChanged: onChanged,
      activeColor: colorScheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: SbRadius.borderSmall, // keep small for checkbox
      ),
    );

    if (label == null) return checkbox;

    return InkWell(
      onTap: onChanged != null ? () => onChanged!(!value) : null,
      borderRadius: SbRadius.borderMedium,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.xs,
          horizontal: AppSpacing.lg,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            checkbox,
            const SizedBox(width: AppSpacing.sm),

            /// 🔥 Better semantic typography
            Text(label!, style: textTheme.labelLarge!),
          ],
        ),
      ),
    );
  }
}

/// WIDGET: SbSwitch
/// PURPOSE: Premium, standardized switch toggle with consistent interaction and layout.
class SbSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;

  const SbSwitch({super.key, required this.value, this.onChanged, this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final toggle = Switch.adaptive(
      value: value,
      onChanged: onChanged,
      activeThumbColor: colorScheme.primary,
      activeTrackColor: colorScheme.primary.withValues(alpha: 0.5),
    );

    if (label == null) return toggle;

    return InkWell(
      onTap: onChanged != null ? () => onChanged!(!value) : null,
      borderRadius: SbRadius.borderMedium,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.xs,
          horizontal: AppSpacing.lg,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label!, style: textTheme.labelLarge!),
            toggle,
          ],
        ),
      ),
    );
  }
}
