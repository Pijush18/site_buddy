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
