import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';

import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/core/widgets/main_navigation_wrapper.dart';
import 'package:site_buddy/core/design_system/sb_text_styles.dart';
import 'package:site_buddy/features/design/application/controllers/footing_design_controller.dart';

import 'package:site_buddy/features/design/presentation/widgets/engineering_diagrams/footing_reinforcement_diagram.dart';
import 'package:site_buddy/features/design/presentation/widgets/engineering_diagrams/design_result_card.dart';
import 'package:site_buddy/core/optimization/optimization_engine.dart';
import 'package:site_buddy/features/design/presentation/widgets/optimization/optimization_list.dart';
import 'package:site_buddy/core/services/design_advisor_service.dart';
import 'package:site_buddy/features/design/presentation/widgets/design_advisor/design_advisor_card.dart';
import 'package:site_buddy/features/design/presentation/widgets/optimization/optimization_graph.dart';
import 'package:site_buddy/core/widgets/educational_toggle.dart';
import 'package:site_buddy/core/widgets/code_reference_card.dart';
import 'package:site_buddy/core/data/code_references/is_456_references.dart';
import 'package:site_buddy/core/services/educational_mode_service.dart';

/// SCREEN: FootingReinforcementScreen
/// PURPOSE: Reinforcement design and detailing (Step 5).
class FootingReinforcementScreen extends ConsumerWidget {
  const FootingReinforcementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(footingDesignControllerProvider);
    final notifier = ref.read(footingDesignControllerProvider.notifier);
    final optimizationEngine = OptimizationEngine();

    // Generate Optimization Suggestions
    final optimizationResult = optimizationEngine.optimizeFootingSize(
      columnLoad: state.columnLoad,
      sbc: state.sbc,
      concreteGrade: state.concreteGrade,
      steelGrade: state.steelGrade,
      momentX: state.momentX,
      momentY: state.momentY,
    );

    final advisorResult = ref
        .read(designAdvisorServiceProvider)
        .advise(category: 'footing', optimizationResult: optimizationResult);

    return MainNavigationWrapper(
      child: SbPage.detail(
        title: 'Reinforcement',
        appBarActions: const [EducationalToggle()],
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Step 5 of 6: Steel Detailing',
              style: SbTextStyles.caption(context).copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            AppLayout.vGap24,

            // Requirement Card
            DesignResultCard(
              title: 'Steel Requirement',
              isSafe: state.astProvidedX >= state.astRequiredX,
              items: [
                DesignResultItem(
                  label: 'Min. Required Ast',
                  value: state.astRequiredX.toStringAsFixed(0),
                  unit: 'mm²',
                  subtitle: 'Based on Bending Moment analysis',
                ),
                DesignResultItem(
                  label: 'Provided Ast',
                  value: state.astProvidedX.toStringAsFixed(0),
                  unit: 'mm²',
                  isCritical: true,
                ),
              ],
            ),

            if (ref.watch(educationalModeProvider))
              const CodeReferenceCard(reference: IS456References.soilPressure),

            AppLayout.vGap16,

            // Visualization
            FootingReinforcementDiagram(
              length: state.footingLength,
              width: state.footingWidth,
              thickness: state.footingThickness,
              colA: state.colA,
              colB: state.colB,
              sbc: state.sbc.toStringAsFixed(0),
              qu: state.maxSoilPressure.toStringAsFixed(1),
              rebarX:
                  'T${state.mainBarDia.toInt()} @ ${state.mainBarSpacing.toInt()} c/c',
              rebarY:
                  'T${state.crossBarDia.toInt()} @ ${state.crossBarSpacing.toInt()} c/c',
            ),

            AppLayout.vGap32,

            // Recommended Design Options
            Text(
              'RECOMMENDED DESIGN OPTIONS',
              style: SbTextStyles.caption(context).copyWith(
                color: Theme.of(context).colorScheme.primary,
                letterSpacing: 1.2,
                fontWeight: FontWeight.bold,
              ),
            ),
            AppLayout.vGap16,
            OptimizationList(
              options: optimizationResult.options,
              onOptionSelected: (option) {
                final l = option.parameters['length'] as double;
                final w = option.parameters['width'] as double;
                final t = option.parameters['thickness'] as double;
                notifier.updateGeometry(length: l, width: w, thickness: t);

                SbFeedback.showToast(
                  context: context,
                  message:
                      'Footing updated to ${l.toInt()}x${w.toInt()}x${t.toInt()} mm',
                );
              },
            ),
            AppLayout.vGap16,
            OptimizationGraph(options: optimizationResult.options),
            AppLayout.vGap16,

            if (optimizationResult.options.isNotEmpty)
              DesignAdvisorCard(advisorResult: advisorResult),

            AppLayout.vGap32,

            // Detailing Card
            SbCard(
              padding: const EdgeInsets.all(AppLayout.pMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bar Detailing',
                    style: SbTextStyles.title(context),
                  ),
                  AppLayout.vGap16,
                  Text(
                    'Main Reinforcement (X-Direction)',
                    style: SbTextStyles.caption(context).copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  AppLayout.vGap8,
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
                      AppLayout.hGap16,
                      Expanded(
                        child: SbDropdown<double>(
                          value: state.mainBarSpacing,
                          items: const [100, 125, 150, 175, 200, 225, 250],
                          itemLabelBuilder: (d) => '${d.toInt()} c/c',
                          onChanged: (v) {
                            if (v != null) {
                              notifier.updateReinforcement(mainSpacing: v);
                            }
                          },
                        ),
                      ),
                    ],
                  ),

                  AppLayout.vGap24,
                  Text(
                    'Distribution Steel (Y-Direction)',
                    style: SbTextStyles.caption(context).copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  AppLayout.vGap8,
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
                      AppLayout.hGap16,
                      Expanded(
                        child: SbDropdown<double>(
                          value: state.crossBarSpacing,
                          items: const [100, 125, 150, 175, 200, 225, 250],
                          itemLabelBuilder: (d) => '${d.toInt()} c/c',
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

            if (ref.watch(educationalModeProvider))
              const CodeReferenceCard(
                reference: IS456References.footingMinReinforcement,
              ),

            AppLayout.vGap16,
            SbButton.primary(
              label: 'Next: Final Safety Checks',
              onPressed: () => context.push('/footing/safety'),
            ),
            AppLayout.vGap24,
          ],
        ),
      ),
    );
  }
}
