import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/widgets/app_card.dart';
import 'package:site_buddy/core/widgets/app_number_field.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/utils/validation_helper.dart';

class CrackingInputSection extends StatelessWidget {
  final TextEditingController spacingController;
  final TextEditingController coverController;
  final TextEditingController fsController;
  final String selectedConcrete;
  final String selectedSteel;
  final List<String> concreteGrades;
  final List<String> steelGrades;
  final Function(String, String) onDropdownChanged;

  const CrackingInputSection({
    super.key,
    required this.spacingController,
    required this.coverController,
    required this.fsController,
    required this.selectedConcrete,
    required this.selectedSteel,
    required this.concreteGrades,
    required this.steelGrades,
    required this.onDropdownChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'INPUT PARAMETERS',
            style: SbTextStyles.caption(context).copyWith(
              color: const Color(0xFF2563EB),

              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: AppLayout.md),
          Row(
            children: [
              Expanded(
                child: AppNumberField(
                  controller: spacingController,
                  label: 'Spacing (s) [mm]',
                  suffixIcon: Icons.space_bar,
                  validator: (v) =>
                      ValidationHelper.validatePositive(v, 'Spacing'),
                ),
              ),
              const SizedBox(width: AppLayout.md),
              Expanded(
                child: AppNumberField(
                  controller: coverController,
                  label: 'Cover [mm]',
                  suffixIcon: SbIcons.layers,
                  validator: (v) =>
                      ValidationHelper.validatePositive(v, 'Cover'),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppLayout.md),
          AppNumberField(
            controller: fsController,
            label: 'Steel Stress (fs) [MPa]',
            suffixIcon: Icons.speed,
            validator: (v) => ValidationHelper.validatePositive(v, 'Stress'),
          ),
          const SizedBox(height: AppLayout.md),
          Row(
            children: [
              Expanded(
                child: _buildLabelledDropdown(
                  context,
                  'Concrete',
                  selectedConcrete,
                  concreteGrades,
                ),
              ),
              const SizedBox(width: AppLayout.md),
              Expanded(
                child: _buildLabelledDropdown(
                  context,
                  'Steel',
                  selectedSteel,
                  steelGrades,
                ),
              ),
            ],
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
          onChanged: (v) {
            if (v != null) onDropdownChanged(label, v);
          },
        ),
      ],
    );
  }
}
