
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/localization/l10n_extension.dart';

import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/features/structural/footing/application/footing_design_controller.dart';

import 'package:site_buddy/features/structural/shared/presentation/widgets/engineering_diagrams/footing_reinforcement_diagram.dart';
import 'package:site_buddy/features/structural/shared/presentation/widgets/engineering_diagrams/design_result_card.dart';
import 'package:site_buddy/core/data/code_references/is_456_references.dart';
import 'package:site_buddy/core/services/educational_mode_service.dart';

/// SCREEN: FootingReinforcementScreen
/// PURPOSE: Reinforcement design and detailing (Step 5).
class FootingReinforcementScreen extends ConsumerWidget {
  const FootingReinforcementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final state = ref.watch(footingDesignControllerProvider);
    final notifier = ref.read(footingDesignControllerProvider.notifier);
    return SbPage.form(
      title: l10n.titleFootingDesign,
      appBarActions: const [EducationalToggle()],
      primaryAction: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PrimaryCTA(
            label: l10n.actionCalculate,
            onPressed: () => context.push('/footing/safety'),
            icon: Icons.calculate_outlined,
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
              l10n.labelStep5Reinforcement,
              style: Theme.of(context).textTheme.titleLarge!,
            ),
          ),

          // ── REQUIREMENT CARD ──
          SbSection(
            title: l10n.labelSteelRequirement,
            child: DesignResultCard(
              title: l10n.labelVerification,
              isSafe: state.astProvidedX >= state.astRequiredX,
              items: [
                DesignResultItem(
                  label: l10n.labelMinRequiredAst,
                  value: state.astRequiredX.toStringAsFixed(0),
                  unit: 'mm²',
                  subtitle: l10n.msgBendingMomentAnalysis,
                ),
                DesignResultItem(
                  label: l10n.labelProvidedAst,
                  value: state.astProvidedX.toStringAsFixed(0),
                  unit: 'mm²',
                  isCritical: true,
                ),
              ],
            ),
          ),

          if (ref.watch(educationalModeProvider))
            const SbSection(
              child: CodeReferenceCard(
                reference: IS456References.soilPressure,
              ),
            ),

          // ── VISUALIZATION ──
          SbSection(
            title: l10n.labelDesignVisualization,
            child: FootingReinforcementDiagram(
              length: state.footingLength,
              width: state.footingWidth,
              thickness: state.footingThickness,
              colA: state.colA,
              colB: state.colB,
              sbc: state.sbc.toStringAsFixed(0),
              qu: state.maxSoilPressure.toStringAsFixed(1),
              rebarX:
                  'T${state.mainBarDia.toInt()} @ ${state.mainBarSpacing.toInt()} ${l10n.unitCC}',
              rebarY:
                  'T${state.crossBarDia.toInt()} @ ${state.crossBarSpacing.toInt()} ${l10n.unitCC}',
            ),
          ),

          // ── DETAILING ──
          SbSection(
            title: l10n.labelBarDetailing,
            child: SbCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.labelMainReinforcementX,
                    style: Theme.of(context).textTheme.labelLarge!,
                  ),
                  const SizedBox(height: SbSpacing.sm),
                  Row(
                    children: [
                      Expanded(
                        child: SbDropdown<double>(
                          value: state.mainBarDia,
                          items: const [8, 10, 12, 16, 20],
                          itemLabelBuilder: (d) => '${d.toInt()} mm',
                          onChanged: (v) {
                            if (v != null) {
                              notifier.updateReinforcement(mainDia: v);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: SbSpacing.lg),
                      Expanded(
                        child: SbDropdown<double>(
                          value: state.mainBarSpacing,
                          items: const [
                            100,
                            125,
                            150,
                            175,
                            200,
                            225,
                            250,
                          ],
                          itemLabelBuilder: (d) => '${d.toInt()} ${l10n.unitCC}',
                          onChanged: (v) {
                            if (v != null) {
                              notifier.updateReinforcement(mainSpacing: v);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: SbSpacing.xxl),
                  Text(
                    l10n.labelDistributionSteelY,
                    style: Theme.of(context).textTheme.labelLarge!,
                  ),
                  const SizedBox(height: SbSpacing.sm),
                  Row(
                    children: [
                      Expanded(
                        child: SbDropdown<double>(
                          value: state.crossBarDia,
                          items: const [8, 10, 12, 16],
                          itemLabelBuilder: (d) => '${d.toInt()} mm',
                          onChanged: (v) {
                            if (v != null) {
                              notifier.updateReinforcement(crossDia: v);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: SbSpacing.lg),
                      Expanded(
                        child: SbDropdown<double>(
                          value: state.crossBarSpacing,
                          items: const [
                            100,
                            125,
                            150,
                            175,
                            200,
                            225,
                            250,
                          ],
                          itemLabelBuilder: (d) => '${d.toInt()} ${l10n.unitCC}',
                          onChanged: (v) {
                            if (v != null) {
                              notifier.updateReinforcement(crossSpacing: v);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          if (ref.watch(educationalModeProvider))
            const SbSection(
              child: CodeReferenceCard(
                reference: IS456References.footingMinReinforcement,
              ),
            ),
        ],
      ),
    );
  }
}











