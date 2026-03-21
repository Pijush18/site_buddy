
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';

import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import 'package:site_buddy/features/design/application/controllers/column_design_controller.dart';
import 'package:site_buddy/shared/domain/models/design/column_enums.dart';
import 'package:site_buddy/features/design/presentation/widgets/engineering_diagrams/design_result_card.dart';
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
    final state = ref.watch(columnDesignControllerProvider);
    final notifier = ref.read(columnDesignControllerProvider.notifier);

    return SbPage.form(
      title: 'Design Calculation',
      appBarActions: const [EducationalToggle()],
      primaryAction: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PrimaryCTA(
            label: 'Next: Detailing',
            onPressed: () {
              context.push('/column/detailing');
            },
          ),
          const SizedBox(height: SbSpacing.sm),
          GhostButton(
            label: 'Back',
            onPressed: () => context.pop(),
          ),
        ],
      ),
      body: SbSectionList(
        sections: [
          // ── STEP HEADER ──
          SbSection(
            child: Text(
              'Step 4 of 6: Structural Design',
              style: Theme.of(context).textTheme.titleLarge!,
            ),
          ),

          // ── SECTION PROPERTIES ──
          SbSection(
            title: 'Section Properties',
            child: DesignResultCard(
              title: 'Verification',
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
          ),

          // ── DESIGN CONFIGURATION ──
          SbSection(
            title: 'Design Configuration',
            child: SbCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Design Method',
                    style: Theme.of(context).textTheme.labelMedium!,
                  ),
                  const SizedBox(height: SbSpacing.sm),
                  SbDropdown<DesignMethod>(
                    value: state.designMethod,
                    items: DesignMethod.values,
                    itemLabelBuilder: (m) => m.label,
                    onChanged: (v) =>
                        v != null ? notifier.updateDesignMethod(v) : null,
                  ),
                  const SizedBox(height: SbSpacing.lg),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Auto-calculate Steel %',
                              style: Theme.of(context).textTheme.labelLarge!,
                            ),
                            Text(
                              'Automatically find minimum steel',
                              style: Theme.of(context).textTheme.labelMedium!,
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
                    const SizedBox(height: SbSpacing.lg),
                    SbInput(
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
          ),

          // ── CODE REFERENCE ──
          if (ref.watch(educationalModeProvider))
            const SbSection(
              child: CodeReferenceCard(
                reference: IS456References.minReinforcementColumn,
              ),
            ),

          // ── REINFORCEMENT REQUIREMENT ──
          SbSection(
            title: 'Reinforcement Requirement',
            child: DesignResultCard(
              title: 'Verification',
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
          ),
        ],
      ),
    );
  }
}











