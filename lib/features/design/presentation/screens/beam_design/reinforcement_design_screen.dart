import 'package:site_buddy/core/design_system/sb_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';

import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/features/design/application/controllers/beam_design_controller.dart';
import 'package:site_buddy/features/design/presentation/widgets/smart_suggestions_card.dart';
import 'package:site_buddy/features/design/presentation/widgets/engineering_diagrams/beam_cross_section_diagram.dart';
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

/// SCREEN: ReinforcementDesignScreen
/// PURPOSE: Reinforcement calculation and arrangement (Step 4).
class ReinforcementDesignScreen extends ConsumerWidget {
  const ReinforcementDesignScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = ref.watch(beamDesignControllerProvider);
    final notifier = ref.read(beamDesignControllerProvider.notifier);
    final optimizationEngine = OptimizationEngine();

    // Generate Optimization Suggestions
    final optimizationResult = optimizationEngine.optimizeBeamSection(
      span: state.span,
      deadLoad: state.deadLoad,
      liveLoad: state.liveLoad,
      concreteGrade: state.concreteGrade,
      steelGrade: state.steelGrade,
      type: state.type,
    );

    final advisorResult = ref
        .read(designAdvisorServiceProvider)
        .advise(category: 'beam', optimizationResult: optimizationResult);

    return SbPage.detail(
      title: 'Reinforcement',

      appBarActions: const [EducationalToggle()],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Step 4 of 5: Steel Detailing',
            style: SbTextStyles.title(context).copyWith(
              color: colorScheme.primary,
            ),
          ),
          AppLayout.vGap24,

          // DETALLING PREVIEW
          Text('Cross-Section Arrangement', style: SbTextStyles.title(context)),
          AppLayout.vGap16,
          BeamCrossSectionDiagram(
            width: state.width,
            depth: state.overallDepth,
            numBars: state.numBars,
            barDia: state.mainBarDia,
            stirrupSpacing: state.stirrupSpacing,
          ),
          AppLayout.vGap24,

          // SMART SUGGESTIONS
          if (state.suggestions.isNotEmpty) ...[
            SmartSuggestionsCard(
              suggestions: state.suggestions,
              onOptimize: () => notifier.optimize(),
            ),
            AppLayout.vGap24,
          ],

          // Recommended Design Options
          Text(
            'RECOMMENDED DESIGN OPTIONS',
            style: SbTextStyles.title(context).copyWith(
              color: colorScheme.primary,
              letterSpacing: 1.2,
            ),
          ),
          AppLayout.vGap16,
          OptimizationList(
            options: optimizationResult.options,
            onOptionSelected: (option) {
              final b = option.parameters['width'] as double;
              final d = option.parameters['depth'] as double;
              notifier.updateInputs(width: b, depth: d);

              SbFeedback.showToast(
                context: context,
                message: 'Section updated to ${b.toInt()}x${d.toInt()} mm',
              );
            },
          ),
          AppLayout.vGap16,
          OptimizationGraph(options: optimizationResult.options),
          AppLayout.vGap16,

          if (optimizationResult.options.isNotEmpty)
            DesignAdvisorCard(advisorResult: advisorResult),

          AppLayout.vGap24,

          // Detailing Controls Card
          SbCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Steel Specification', style: SbTextStyles.title(context)),
                AppLayout.vGap16,

                Text('Main Bar Diameter', style: SbTextStyles.title(context)),
                AppLayout.vGap8,
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

          if (ref.watch(educationalModeProvider))
            const CodeReferenceCard(
              reference: IS456References.tensionReinforcement,
            ),

          AppLayout.vGap16,

          // RESULTS: FLEXURE
          DesignResultCard(
            title: 'Flexural Analysis',
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
          AppLayout.vGap16,

          // RESULTS: SHEAR
          DesignResultCard(
            title: 'Shear Reinforcement',
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
          AppLayout.vGap32,

          SbButton.primary(
            label: 'Next: Safety Checks',
            icon: Icons.verified_user_outlined,
            onPressed: () {
              context.push('/beam/safety');
            },
          ),
          AppLayout.vGap16,
          SbButton.outline(label: 'Back', onPressed: () => context.pop()),
          AppLayout.vGap24,
        ],
      ),
    );
  }
}
