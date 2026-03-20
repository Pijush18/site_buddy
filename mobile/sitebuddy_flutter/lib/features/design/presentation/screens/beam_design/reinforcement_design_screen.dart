import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/features/design/application/controllers/beam_design_controller.dart';
import 'package:site_buddy/features/design/presentation/widgets/smart_suggestions_card.dart';
import 'package:site_buddy/features/design/presentation/widgets/engineering_diagrams/beam_cross_section_diagram.dart';
import 'package:site_buddy/features/design/presentation/widgets/engineering_diagrams/design_result_card.dart';
import 'package:site_buddy/core/widgets/code_reference_card.dart';
import 'package:site_buddy/core/data/code_references/is_456_references.dart';
import 'package:site_buddy/core/services/educational_mode_service.dart';

/// SCREEN: ReinforcementDesignScreen
/// PURPOSE: Reinforcement calculation and arrangement (Step 4).
class ReinforcementDesignScreen extends ConsumerWidget {
  const ReinforcementDesignScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(beamDesignControllerProvider);
    final notifier = ref.read(beamDesignControllerProvider.notifier);

    return SbPage.form(
      title: 'Reinforcement',
      appBarActions: const [EducationalToggle()],
      primaryAction: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SbButton.primary(
            label: 'Next: Safety Checks',
            icon: Icons.verified_user_outlined,
            onPressed: () {
              context.push('/beam/safety');
            },
          ),
          const SizedBox(height: SbSpacing.sm),
          SbButton.ghost(
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
              'Step 4 of 5: Steel Detailing',
              style: Theme.of(context).textTheme.titleLarge!,
            ),
          ),

          // ── DETAILING PREVIEW ──
          SbSection(
            title: 'Cross-Section Arrangement',
            child: BeamCrossSectionDiagram(
              width: state.width,
              depth: state.overallDepth,
              numBars: state.numBars,
              barDia: state.mainBarDia,
              stirrupSpacing: state.stirrupSpacing,
            ),
          ),

          // ── SMART SUGGESTIONS ──
          if (state.suggestions.isNotEmpty)
            SbSection(
              title: 'Design Insights',
              child: SmartSuggestionsCard(
                suggestions: state.suggestions,
                onOptimize: () => notifier.optimize(),
              ),
            ),

          // ── STEEL SPECIFICATION ──
          SbSection(
            title: 'Steel Specification',
            child: SbCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Main Bar Diameter',
                    style: Theme.of(context).textTheme.labelLarge!,
                  ),
                  const SizedBox(height: SbSpacing.sm),
                  SbDropdown<double>(
                    value: state.mainBarDia,
                    items: const [12, 16, 20, 25, 32],
                    itemLabelBuilder: (d) => '${d.toInt()} mm',
                    onChanged: (v) {
                      if (v != null) {
                        notifier.updateReinforcement(dia: v);
                        notifier.calculateReinforcement();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),

          // ── CODE REFERENCE ──
          if (ref.watch(educationalModeProvider))
            const SbSection(
              child: CodeReferenceCard(
                reference: IS456References.tensionReinforcement,
              ),
            ),

          // ── RESULTS: FLEXURE ──
          SbSection(
            title: 'Flexural Analysis',
            child: DesignResultCard(
              title: 'Verification',
              isSafe: state.isFlexureSafe,
              items: [
                DesignResultItem(
                  label: 'Ast Required',
                  value: '${state.astRequired.toInt()} mm²',
                ),
                DesignResultItem(
                  label: 'Ast Provided',
                  value: '${state.astProvided.toInt()} mm²',
                  isCritical: true,
                ),
                DesignResultItem(
                  label: 'xu / xu,max',
                  value: '${state.xu.toInt()} / ${state.xuMax.toInt()} mm',
                ),
              ],
              codeReference: 'IS 456 Annex G',
            ),
          ),

          // ── RESULTS: SHEAR ──
          SbSection(
            title: 'Shear Reinforcement',
            child: DesignResultCard(
              title: 'Verification',
              isSafe: state.isShearSafe,
              items: [
                DesignResultItem(
                  label: 'Shear Force (Vu)',
                  value: '${state.vu.toStringAsFixed(1)} kN',
                ),
                DesignResultItem(
                  label: 'Shear Stress (τv)',
                  value: '${state.tv.toStringAsFixed(2)} N/mm²',
                ),
                DesignResultItem(
                  label: 'Stirrup Spacing',
                  value: '${state.stirrupSpacing.toInt()} mm c/c',
                  isCritical: true,
                ),
              ],
              codeReference: 'IS 456 Cl. 40',
            ),
          ),
        ],
      ),
    );
  }
}




