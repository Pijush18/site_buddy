import 'package:flutter/material.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
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
                  controller: spanController,
                  label: 'Span (L) [mm]',
                  suffixIcon: const Icon(SbIcons.level),
                  validator: (v) =>
                      ValidationHelper.validatePositive(v, 'Span'),
                ),
              ),
            ],
          ),
          SizedBox(height: SbSpacing.lg),
          _buildLabelledDropdown(
            context,
            'Span Type',
            selectedSpanType,
            spanTypes,
            onSpanTypeChanged,
          ),
          SizedBox(height: SbSpacing.lg),
          Row(
            children: [
              Expanded(
                child: SbInput(
                  controller: ptController,
                  label: 'Tension Steel (pt) [%]',
                  suffixIcon: const Icon(SbIcons.percent),
                  validator: (v) =>
                      ValidationHelper.validatePercentage(v, 'Tension Steel'),
                ),
              ),
              const SizedBox(width: SbSpacing.lg),
              Expanded(
                child: SbInput(
                  controller: pcController,
                  label: 'Comp. Steel (pc) [%]',
                  suffixIcon: const Icon(SbIcons.percent),
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
        SizedBox(height: SbSpacing.sm),
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




