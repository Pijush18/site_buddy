import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/localization/l10n_extension.dart';
import 'package:site_buddy/core/navigation/app_routes.dart';

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
    final l10n = context.l10n;
    final state = ref.watch(columnDesignControllerProvider);
    final notifier = ref.read(columnDesignControllerProvider.notifier);

    return SbPage.form(
      title: l10n.titleDesignCalculation,
      appBarActions: const [EducationalToggle()],
      primaryAction: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PrimaryCTA(
            label: l10n.actionNext,
            onPressed: () {
              context.push(AppRoutes.columnDetailing);
            },
            icon: Icons.navigate_next,
          ),
          const SizedBox(height: SbSpacing.sm),
          GhostButton(
            label: l10n.actionBack,
            onPressed: () => context.pop(),
          ),
        ],
      ),
      body: SbSectionList(
        sections: [
          // ── STEP HEADER ──
          SbSection(
            child: Text(
              l10n.labelStep4StructuralDesign,
              style: Theme.of(context).textTheme.titleLarge!,
            ),
          ),

          // ── SECTION PROPERTIES ──
          SbSection(
            title: l10n.labelSectionProperties,
            child: DesignResultCard(
              title: l10n.labelVerification,
              isSafe: true,
              items: [
                DesignResultItem(
                  label: l10n.labelGrossAreaAgUnit,
                  value: state.ag.toInt().toString(),
                ),
                DesignResultItem(
                  label: l10n.labelTargetSteelPercentUnit,
                  value: state.steelPercentage.toStringAsFixed(2),
                ),
              ],
            ),
          ),

          // ── DESIGN CONFIGURATION ──
          SbSection(
            title: l10n.labelDesignConfiguration,
            child: SbCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.labelDesignMethod,
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
                              l10n.labelAutoCalculateSteel,
                              style: Theme.of(context).textTheme.labelLarge!,
                            ),
                            Text(
                              l10n.labelAutoSteelDescription,
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
                      label: l10n.labelManualSteelUnit,
                      hint: l10n.hintSteelRatio,
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
            title: l10n.labelReinforcementRequirement,
            child: DesignResultCard(
              title: l10n.labelVerification,
              isSafe: state.astRequired > 0,
              items: [
                DesignResultItem(
                  label: l10n.labelRequiredSteelAreaAscUnit,
                  value: state.astRequired.toInt().toString(),
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
