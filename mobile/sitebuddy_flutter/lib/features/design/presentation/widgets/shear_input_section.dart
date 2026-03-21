
import 'package:flutter/material.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
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

    return SbCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: SbInput(
                  controller: dController,
                  label: 'Eff. Depth (d) [mm]',
                  suffixIcon: const Icon(SbIcons.layers),
                  validator: (v) =>
                      ValidationHelper.validatePositive(v, 'Depth'),
                ),
              ),
              const SizedBox(width: SbSpacing.lg),
              Expanded(
                child: SbInput(
                  controller: bController,
                  label: 'Width (b) [mm]',
                  suffixIcon: const Icon(SbIcons.ruler),
                  validator: (v) =>
                      ValidationHelper.validatePositive(v, 'Width'),
                ),
              ),
            ],
          ),
          const SizedBox(height: SbSpacing.lg),
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
              const SizedBox(width: SbSpacing.lg),
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
          const SizedBox(height: SbSpacing.lg),
          SbInput(
            controller: vuController,
            label: 'Shear Force (Vu) [kN]',
            suffixIcon: const Icon(Icons.vertical_align_bottom),
            validator: (v) =>
                ValidationHelper.validatePositive(v, 'Shear Force'),
          ),
          const SizedBox(height: SbSpacing.lg),
          SbInput(
            controller: ptController,
            label: 'Steel Per. (pt) [%]',
            suffixIcon: const Icon(SbIcons.percent),
            validator: (v) =>
                ValidationHelper.validatePercentage(v, 'Percentage'),
          ),
        ],
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge!,
        ),
        const SizedBox(height: SbSpacing.sm),
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








