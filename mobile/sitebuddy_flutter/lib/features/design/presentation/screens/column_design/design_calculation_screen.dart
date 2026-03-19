import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/theme/app_font_sizes.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';

import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/core/widgets/app_number_field.dart';
import 'package:site_buddy/features/design/application/controllers/column_design_controller.dart';
import 'package:site_buddy/shared/domain/models/design/column_enums.dart';
import 'package:site_buddy/features/design/presentation/widgets/engineering_diagrams/design_result_card.dart';
import 'package:site_buddy/core/widgets/educational_toggle.dart';
import 'package:site_buddy/core/widgets/code_reference_card.dart';
import 'package:site_buddy/core/data/code_references/is_456_references.dart';
import 'package:site_buddy/core/services/educational_mode_service.dart';

/// SCREEN: DesignCalculationScreen
/// PURPOSE: Reinforcement calculation (Step 4).
class DesignCalculationScreen extends ConsumerStatefulWidget {
  const DesignCalculationScreen({super.key});

  @override
  ConsumerState<DesignCalculationScreen> createState() =>
      _DesignCalculationScreenState();
}

class _DesignCalculationScreenState
    extends ConsumerState<DesignCalculationScreen> {
  late final TextEditingController _steelPercentageController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(columnDesignControllerProvider);
    _steelPercentageController = TextEditingController(
      text: state.steelPercentage.toString(),
    );
  }

  @override
  void dispose() {
    _steelPercentageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = ref.watch(columnDesignControllerProvider);
    final notifier = ref.read(columnDesignControllerProvider.notifier);

    return AppScreenWrapper(
      title: 'Design Calculation',
      actions: const [EducationalToggle()],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Step 4 of 6: Structural Design',
            style: TextStyle(
              fontSize: AppFontSizes.title,
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24

          // Design Settings & Properties
          DesignResultCard(
            title: 'Section Properties',
            isSafe: true,
            items: [
              DesignResultItem(
                label: 'Gross Area (Ag)',
                value: state.ag.toInt().toString(),
                unit: 'mm²',
              ),
              DesignResultItem(
                label: 'Target Steel %',
                value: state.steelPercentage.toStringAsFixed(2),
                unit: '%',
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md), // Replaced AppLayout.vGap16

          // Design Controls Card
          SbCard(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Design Configuration',
                  style: TextStyle(
                    fontSize: AppFontSizes.title,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm), // Replaced AppLayout.vGap12 (closest standard)
                Text(
                  'Design Method',
                  style: TextStyle(
                    fontSize: AppFontSizes.tab,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm), // Replaced AppLayout.vGap8
                SbCard(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    children: [
                      SbDropdown<DesignMethod>(
                        value: state.designMethod,
                        items: DesignMethod.values,
                        itemLabelBuilder: (m) => m.label,
                        onChanged: (v) =>
                            v != null ? notifier.updateDesignMethod(v) : null,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Auto-calculate Steel %',
                            style: TextStyle(
                              fontSize: AppFontSizes.subtitle,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'Automatically find minimum steel',
                            style: TextStyle(
                              fontSize: AppFontSizes.tab,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SbSwitch(
                      value: state.isAutoSteel,
                      onChanged: (v) =>
                          notifier.updateReinforcement(isAutoSteel: v),
                    ),
                  ],
                ),
                if (!state.isAutoSteel) ...[
                  const SizedBox(height: AppSpacing.md), // Replaced AppLayout.vGap16
                  AppNumberField(
                    label: 'Manual Steel (%)',
                    hint: 'e.g. 1.20',
                    controller: _steelPercentageController,
                    onChanged: (v) {
                      final p = double.tryParse(v);
                      if (p != null) {
                        notifier.updateReinforcement(steelPercentage: p);
                      }
                    },
                  ),
                ],
              ],
            ),
          ),

          if (ref.watch(educationalModeProvider))
            const CodeReferenceCard(
              reference: IS456References.minReinforcementColumn,
            ),

          const SizedBox(height: AppSpacing.md), // Replaced AppLayout.vGap16

          // Required Steel Area (Asc)
          DesignResultCard(
            title: 'Reinforcement Requirement',
            isSafe: state.astRequired > 0,
            items: [
              DesignResultItem(
                label: 'Required Steel Area (Asc)',
                value: state.astRequired.toInt().toString(),
                unit: 'mm²',
                isCritical: true,
              ),
            ],
            codeReference: state.designMethod == DesignMethod.analytical
                ? 'IS 456 Cl. 39.3'
                : 'IS 456 Annex B',
          ),

          const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24

          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SbButton.primary(
                label: 'Next: Detailing',
                onPressed: () {
                  context.push('/column/detailing');
                },
                width: double.infinity,
              ),
              const SizedBox(height: AppSpacing.sm),
              SbButton.secondary(
                label: 'Back',
                onPressed: () => context.pop(),
                width: double.infinity,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg), // Added for bottom padding consistency
        ],
      ),
    );
  }
}
