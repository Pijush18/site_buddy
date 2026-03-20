import 'package:site_buddy/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/widgets/app_number_field.dart';
import 'package:site_buddy/core/utils/validation_helper.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';

class ShearInputSection extends StatelessWidget {
  final TextEditingController dController;
  final TextEditingController bController;
  final TextEditingController vuController;
  final TextEditingController ptController;
  final String selectedConcrete;
  final String selectedSteel;
  final ValueChanged<String?> onConcreteChanged;
  final ValueChanged<String?> onSteelChanged;

  const ShearInputSection({
    super.key,
    required this.dController,
    required this.bController,
    required this.vuController,
    required this.ptController,
    required this.selectedConcrete,
    required this.selectedSteel,
    required this.onConcreteChanged,
    required this.onSteelChanged,
  });

  @override
  Widget build(BuildContext context) {
    const concreteGrades = ['M20', 'M25', 'M30', 'M35', 'M40'];
    const steelGrades = ['Fe415', 'Fe500'];

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
                    controller: bController,
                    label: 'Width (b) [mm]',
                    suffixIcon: SbIcons.ruler,
                    validator: (v) => ValidationHelper.validatePositive(v, 'Width'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: _buildLabelledDropdown(
                    context,
                    'Concrete',
                    selectedConcrete,
                    concreteGrades,
                    onConcreteChanged,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _buildLabelledDropdown(
                    context,
                    'Steel',
                    selectedSteel,
                    steelGrades,
                    onSteelChanged,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            AppNumberField(
              controller: vuController,
              label: 'Shear Force (Vu) [kN]',
              suffixIcon: Icons.vertical_align_bottom,
              validator: (v) => ValidationHelper.validatePositive(v, 'Shear Force'),
            ),
            const SizedBox(height: AppSpacing.md),
            AppNumberField(
              controller: ptController,
              label: 'Steel Per. (pt) [%]',
              suffixIcon: SbIcons.percent,
              validator: (v) => ValidationHelper.validatePercentage(v, 'Percentage'),
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
          style: AppTextStyles.caption(context).copyWith(
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
