import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/localization/l10n_extension.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/features/structural/beam/application/beam_design_controller.dart';
import 'package:site_buddy/features/structural/shared/presentation/widgets/smart_suggestions_card.dart';
import 'package:site_buddy/features/structural/shared/presentation/widgets/engineering_diagrams/beam_cross_section_diagram.dart';
import 'package:site_buddy/features/structural/shared/presentation/widgets/engineering_diagrams/design_result_card.dart';
import 'package:site_buddy/core/data/code_references/is_456_references.dart';
import 'package:site_buddy/core/services/educational_mode_service.dart';

/// SCREEN: ReinforcementDesignScreen
/// PURPOSE: Reinforcement calculation and arrangement (Step 4).
/// 
/// IS 456:2000 Requirements:
/// - Tension reinforcement design (Clause 38.1)
/// - Shear reinforcement design (Clause 40.0)
/// - Minimum & maximum reinforcement limits (Clause 26.5.2)
class ReinforcementDesignScreen extends ConsumerWidget {
  const ReinforcementDesignScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final state = ref.watch(beamDesignControllerProvider);
    final notifier = ref.read(beamDesignControllerProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;

    return SbPage.form(
      title: l10n.titleReinforcement,
      appBarActions: const [EducationalToggle()],
      primaryAction: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PrimaryCTA(
            label: l10n.actionCalculate,
            onPressed: () {
              context.push('/beam/safety');
            },
            icon: Icons.calculate_outlined,
          ),
          const SizedBox(height: AppSpacing.md),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.labelStep4Reinforcement,
                  style: Theme.of(context).textTheme.titleLarge!,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'IS 456:2000 Clause 38.1 & 40',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),

          // ── DETAILING PREVIEW ──
          SbSection(
            title: l10n.labelCrossSection,
            child: BeamCrossSectionDiagram(
              width: state.width,
              depth: state.overallDepth,
              numBars: state.numBars,
              barDia: state.mainBarDia,
              stirrupSpacing: state.stirrupSpacing,
            ),
          ),

          // ── STEEL SPECIFICATION ──
          SbSection(
            title: l10n.labelSteelSpecs,
            child: SbCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.labelBarDia,
                    style: Theme.of(context).textTheme.labelLarge!,
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
                  const SizedBox(height: AppSpacing.sm),
                  _buildCodeHint(
                    context,
                    'ℹ️ ${state.numBars} bars of ${state.mainBarDia.toInt()} mm = ${state.astProvided.toInt()} mm²',
                  ),
                ],
              ),
            ),
          ),

          // ── SMART SUGGESTIONS ──
          if (state.suggestions.isNotEmpty)
            SbSection(
              title: l10n.labelInsights,
              child: SmartSuggestionsCard(
                suggestions: state.suggestions,
                onOptimize: () => notifier.optimize(),
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
            title: l10n.labelFlexure,
            child: DesignResultCard(
              title: l10n.labelVerification,
              isSafe: state.isFlexureSafe,
              items: [
                DesignResultItem(
                  label: l10n.labelAstRequired,
                  value: '${state.astRequired.toInt()} mm²',
                ),
                DesignResultItem(
                  label: l10n.labelAstProvided,
                  value: '${state.astProvided.toInt()} mm²',
                  isCritical: true,
                ),
                DesignResultItem(
                  label: 'xu / xu,max',
                  value: '${state.xu.toInt()} / ${state.xuMax.toInt()} mm',
                ),
                DesignResultItem(
                  label: 'Min Ast',
                  value: '${state.astMin.toInt()} mm²',
                ),
              ],
              codeReference: 'IS 456 Cl. 38.1',
            ),
          ),

          // ── RESULTS: SHEAR ──
          SbSection(
            title: l10n.labelShear,
            child: DesignResultCard(
              title: l10n.labelVerification,
              isSafe: state.isShearSafe,
              items: [
                DesignResultItem(
                  label: l10n.labelShearVu,
                  value: '${state.vu.toStringAsFixed(1)} kN',
                ),
                DesignResultItem(
                  label: 'τv (Shear Stress)',
                  value: '${state.tv.toStringAsFixed(2)} N/mm²',
                ),
                DesignResultItem(
                  label: 'τc (Concrete)',
                  value: '${state.tc.toStringAsFixed(2)} N/mm²',
                ),
                DesignResultItem(
                  label: l10n.labelSpacing,
                  value: '${state.stirrupSpacing.toInt()} mm c/c',
                  isCritical: true,
                ),
              ],
              codeReference: 'IS 456 Cl. 40.0',
            ),
          ),

          // ── STEEL SUMMARY ──
          SbSection(
            title: 'Steel Summary',
            child: SbCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _SummaryRow(
                    icon: Icons.circle,
                    label: 'Main Bars',
                    value: '${state.numBars} × Ø${state.mainBarDia.toInt()}',
                    color: colorScheme.primary,
                  ),
                  const Divider(height: AppSpacing.lg),
                  _SummaryRow(
                    icon: Icons.lens_outlined,
                    label: 'Stirrups',
                    value: 'Ø${state.stirrupDia.toInt()} @ ${state.stirrupSpacing.toInt()} mm c/c',
                    color: colorScheme.tertiary,
                  ),
                  const Divider(height: AppSpacing.lg),
                  _SummaryRow(
                    icon: Icons.layers,
                    label: 'Ast Provided',
                    value: '${state.astProvided.toInt()} mm²',
                    color: colorScheme.secondary,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _buildCodeHint(
                    context,
                    'ℹ️ Steel % = ${((state.astProvided * 100) / (state.b * state.d)).toStringAsFixed(2)}% (Min 0.85/fy)',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build a small hint text styled as a code reference
  Widget _buildCodeHint(BuildContext context, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontFamily: 'monospace',
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _SummaryRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

