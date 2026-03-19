import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/design_system/sb_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';

/// WIDGET: SbCheckbox
/// PURPOSE: Standardized checkbox with project-specific radius and colors.
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
    final colorScheme = Theme.of(context).colorScheme;

    final checkbox = Checkbox(
      value: value,
      onChanged: onChanged,
      activeColor: colorScheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          4.0,
        ), // Specific small radius for checkbox
      ),
    );

    if (label == null) return checkbox;

    return InkWell(
      onTap: onChanged != null ? () => onChanged!(!value) : null,
      borderRadius: AppLayout.borderRadiusCard,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.xs,
          horizontal: AppLayout.pMedium,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            checkbox,
            const SizedBox(width: AppLayout.pSmall),
            Text(label!, style: SbTextStyles.body(context)),
          ],
        ),
      ),
    );
  }
}

/// WIDGET: SbSwitch
/// PURPOSE: Premium, standardized switch toggle.
class SbSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;

  const SbSwitch({super.key, required this.value, this.onChanged, this.label});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final toggle = Switch.adaptive(
      value: value,
      onChanged: onChanged,
      activeThumbColor: colorScheme.primary,
      activeTrackColor: colorScheme.primary.withValues(alpha: 0.5),
    );

    if (label == null) return toggle;

    return InkWell(
      onTap: onChanged != null ? () => onChanged!(!value) : null,
      borderRadius: AppLayout.borderRadiusCard,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.xs,
          horizontal: AppLayout.pMedium,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label!, style: SbTextStyles.body(context)),
            toggle,
          ],
        ),
      ),
    );
  }
}
