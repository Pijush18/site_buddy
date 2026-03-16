import 'package:site_buddy/core/design_system/sb_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';

import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/core/widgets/app_number_field.dart';
import 'package:site_buddy/features/design/application/controllers/column_design_controller.dart';
import 'package:site_buddy/shared/domain/models/design/column_enums.dart';
// import 'package:site_buddy/shared/widgets/action_buttons_group.dart';
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

    return SbPage.detail(
      title: 'Design Calculation',
      appBarActions: const [EducationalToggle()],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Step 4 of 6: Structural Design',
            style: SbTextStyles.title(context).copyWith(
              color: colorScheme.primary,
            ),
          ),
          AppLayout.vGap24,

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

          AppLayout.vGap16,

          // Design Controls Card
          SbCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Design Configuration',
                  style: SbTextStyles.title(context),
                ),
                AppLayout.vGap12,
                Text(
                  'Design Method',
                  style: SbTextStyles.caption(context).copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                AppLayout.vGap8,
                SbDropdown<DesignMethod>(
                  value: state.designMethod,
                  items: DesignMethod.values,
                  itemLabelBuilder: (m) => m.label,
                  onChanged: (v) =>
                      v != null ? notifier.updateDesignMethod(v) : null,
                ),
                AppLayout.vGap24,
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Auto-calculate Steel %',
                            style: SbTextStyles.body(context),
                          ),
                          Text(
                            'Automatically find minimum steel',
                            style: SbTextStyles.caption(context).copyWith(
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
                  AppLayout.vGap16,
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

          AppLayout.vGap16,

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


          AppLayout.vGap24,

          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SbButton.primary(
                label: 'Next: Detailing',
                onPressed: () {
                  context.push('/column/detailing');
                },
              ),
              AppLayout.vGap12,
              SbButton.outline(
                label: 'Back',
                onPressed: () => context.pop(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
