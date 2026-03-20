
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';

import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    return AppScreenWrapper(
      title: 'Reinforcement',
      actions: const [EducationalToggle()],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Step 5 of 6: Steel Detailing',
            style: Theme.of(context).textTheme.labelMedium!,
          ),
          const SizedBox(height: SbSpacing.xxl), // Replaced AppLayout.vGap24

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

          const SizedBox(height: SbSpacing.lg), // Replaced const SizedBox(height: SbSpacing.lg)

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

          const SizedBox(height: SbSpacing.xxl), // Replaced AppLayout.vGap32

          // Detailing Card
          const SbSectionHeader(title: 'Bar Detailing'),
          SbCard(
            padding: const EdgeInsets.all(SbSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Main Reinforcement (X-Direction)',
                  style: Theme.of(context).textTheme.labelMedium!,
                ),
                const SizedBox(height: SbSpacing.sm), // Replaced const SizedBox(height: SbSpacing.sm)
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
                    const SizedBox(width: SbSpacing.lg), // Replaced const SizedBox(width: SbSpacing.lg)
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

                const SizedBox(height: SbSpacing.xxl), // Replaced AppLayout.vGap24
                Text(
                  'Distribution Steel (Y-Direction)',
                  style: Theme.of(context).textTheme.labelMedium!,
                ),
                const SizedBox(height: SbSpacing.sm), // Replaced const SizedBox(height: SbSpacing.sm)
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
                    const SizedBox(width: SbSpacing.lg), // Replaced const SizedBox(width: SbSpacing.lg)
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

          const SizedBox(height: SbSpacing.lg), // Replaced const SizedBox(height: SbSpacing.lg)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SbButton.primary(
                label: 'Next: Final Safety Checks',
                onPressed: () => context.push('/footing/safety'),
                width: double.infinity,
              ),
              const SizedBox(height: SbSpacing.sm),
              SbButton.secondary(
                label: 'Back',
                onPressed: () => context.pop(),
                width: double.infinity,
              ),
            ],
          ),
          const SizedBox(height: SbSpacing.xxl), // Replaced AppLayout.vGap24
        ],
      ),
    );
  }
}










