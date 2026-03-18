import 'package:flutter/material.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/widgets/app_number_field.dart';
import 'package:site_buddy/core/utils/validation_helper.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';

class DeflectionInputSection extends StatelessWidget {
  final TextEditingController dController;
  final TextEditingController spanController;
  final TextEditingController ptController;
  final TextEditingController pcController;
  final String selectedSpanType;
  final ValueChanged<String?> onSpanTypeChanged;

  const DeflectionInputSection({
    super.key,
    required this.dController,
    required this.spanController,
    required this.ptController,
    required this.pcController,
    required this.selectedSpanType,
    required this.onSpanTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    const spanTypes = ['Cantilever', 'Simply Supported', 'Continuous'];

    return SbSection(
      title: 'Input Parameters',
      child: SbCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: AppNumberField(
                    controller: dController,
                    label: 'Eff. Depth (d) [mm]',
                    suffixIcon: SbIcons.layers,
                    validator: (v) => ValidationHelper.validatePositive(v, 'Depth'),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: AppNumberField(
                    controller: spanController,
                    label: 'Span (L) [mm]',
                    suffixIcon: SbIcons.level,
                    validator: (v) => ValidationHelper.validatePositive(v, 'Span'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            _buildLabelledDropdown(
              context,
              'Span Type',
              selectedSpanType,
              spanTypes,
              onSpanTypeChanged,
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: AppNumberField(
                    controller: ptController,
                    label: 'Tension Steel (pt) [%]',
                    suffixIcon: SbIcons.percent,
                    validator: (v) => ValidationHelper.validatePercentage(v, 'Tension Steel'),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: AppNumberField(
                    controller: pcController,
                    label: 'Comp. Steel (pc) [%]',
                    suffixIcon: SbIcons.percent,
                    validator: (v) {
                      if (v == null || v.isEmpty) return null;
                      return ValidationHelper.validatePercentage(
                        v,
                        'Comp. Steel',
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabelledDropdown(
    BuildContext context,
    String label,
    String value,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SbDropdown<String>(
          value: value,
          items: items,
          itemLabelBuilder: (s) => s,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
