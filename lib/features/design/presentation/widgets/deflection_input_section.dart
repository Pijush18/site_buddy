import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/widgets/app_card.dart';
import 'package:site_buddy/core/widgets/app_number_field.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/utils/validation_helper.dart';

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
              const SizedBox(width: AppLayout.lg),
              Expanded(
                child: AppNumberField(
                  controller: spanController,
                  label: 'Span (L) [mm]',
                  suffixIcon: SbIcons.level,
                  validator: (v) =>
                      ValidationHelper.validatePositive(v, 'Span'),
                ),
              ),
            ],
          ),
          AppLayout.vGap16,
          Text(
            'Span Type',
            style: SbTextStyles.caption(context).copyWith(color: const Color(0xFF94A3B8)),
          ),
          const SizedBox(height: AppLayout.xs),
          SbDropdown<String>(
            value: selectedSpanType,
            items: spanTypes,
            itemLabelBuilder: (s) => s,
            onChanged: onSpanTypeChanged,
          ),
          AppLayout.vGap16,
          Row(
            children: [
              Expanded(
                child: AppNumberField(
                  controller: ptController,
                  label: 'Tension Steel (pt) [%]',
                  suffixIcon: SbIcons.percent,
                  validator: (v) =>
                      ValidationHelper.validatePercentage(v, 'Tension Steel'),
                ),
              ),
              const SizedBox(width: AppLayout.pMedium),
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
    );
  }
}
