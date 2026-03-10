import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/widgets/app_card.dart';
import 'package:site_buddy/core/widgets/app_number_field.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/utils/validation_helper.dart';

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

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'INPUT PARAMETERS',
            style: SbTextStyles.title(context).copyWith(
              color: const Color(0xFF2563EB),

              letterSpacing: 1.1,
            ),
          ),
          AppLayout.vGap16,
          Row(
            children: [
              Expanded(
                child: AppNumberField(
                  controller: dController,
                  label: 'Eff. Depth (d) [mm]',
                  suffixIcon: SbIcons.layers,
                  validator: (v) =>
                      ValidationHelper.validatePositive(v, 'Depth'),
                ),
              ),
              const SizedBox(width: AppLayout.pMedium),
              Expanded(
                child: AppNumberField(
                  controller: bController,
                  label: 'Width (b) [mm]',
                  suffixIcon: SbIcons.ruler,
                  validator: (v) =>
                      ValidationHelper.validatePositive(v, 'Width'),
                ),
              ),
            ],
          ),
          AppLayout.vGap16,
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
              const SizedBox(width: AppLayout.pMedium),
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
          AppLayout.vGap16,
          AppNumberField(
            controller: vuController,
            label: 'Shear Force (Vu) [kN]',
            suffixIcon: Icons.vertical_align_bottom,
            validator: (v) =>
                ValidationHelper.validatePositive(v, 'Shear Force'),
          ),
          AppLayout.vGap16,
          AppNumberField(
            controller: ptController,
            label: 'Steel Per. (pt) [%]',
            suffixIcon: SbIcons.percent,
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
          style: SbTextStyles.caption(context).copyWith(color: const Color(0xFF94A3B8)),
        ),
        const SizedBox(height: AppLayout.xs),
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
