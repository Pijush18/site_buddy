import 'package:site_buddy/core/theme/app_text_styles.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';

import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/features/design/application/controllers/beam_design_controller.dart';
import 'package:site_buddy/features/design/presentation/widgets/smart_suggestions_card.dart';
import 'package:site_buddy/features/design/presentation/widgets/engineering_diagrams/beam_cross_section_diagram.dart';
import 'package:site_buddy/features/design/presentation/widgets/engineering_diagrams/design_result_card.dart';
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

    return AppScreenWrapper(
      title: 'Reinforcement',
      actions: const [EducationalToggle()],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Step 4 of 5: Steel Detailing',
            style: AppTextStyles.screenTitle(context).copyWith(
            color: colorScheme.primary,
          ),
          ),
          const SizedBox(height: AppSpacing.md),

          // DETALLING PREVIEW
          const SbSectionHeader(
            title: 'Cross-Section Arrangement',
            padding: EdgeInsets.zero,
          ),

          BeamCrossSectionDiagram(
            width: state.width,
            depth: state.overallDepth,
            numBars: state.numBars,
            barDia: state.mainBarDia,
            stirrupSpacing: state.stirrupSpacing,
          ),
          const SizedBox(height: AppSpacing.md),

          // SMART SUGGESTIONS
          if (state.suggestions.isNotEmpty) ...[
            SmartSuggestionsCard(
              suggestions: state.suggestions,
              onOptimize: () => notifier.optimize(),
            ),
            const SizedBox(height: AppSpacing.md),
          ],

          // Detailing Controls Card
          SbCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SbSectionHeader(
                  title: 'Steel Specification',
                  padding: EdgeInsets.zero,
                ),

                Text(
                  'Main Bar Diameter',
                  style: AppTextStyles.cardTitle(context),
                ),
                const SizedBox(height: AppSpacing.sm),
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
          const SizedBox(height: AppSpacing.md),

          if (ref.watch(educationalModeProvider))
            const CodeReferenceCard(
              reference: IS456References.tensionReinforcement,
            ),

          const SizedBox(height: AppSpacing.md),

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
          const SizedBox(height: AppSpacing.md),

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
          const SizedBox(height: AppSpacing.lg),

          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SbButton.primary(
                label: 'Next: Safety Checks',
                icon: Icons.verified_user_outlined,
                onPressed: () {
                  context.push('/beam/safety');
                },
                width: double.infinity,
              ),
              const SizedBox(height: AppSpacing.sm),
              SbButton.ghost(
                label: 'Back',
                onPressed: () => context.pop(),
                width: double.infinity,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}
