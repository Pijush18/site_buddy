
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/features/design/application/controllers/column_design_controller.dart';
import 'package:site_buddy/features/design/presentation/widgets/engineering_diagrams/rebar_layout_diagram.dart';
import 'package:site_buddy/features/design/presentation/widgets/engineering_diagrams/design_result_card.dart';

/// SCREEN: ReinforcementDetailingScreen
/// PURPOSE: Bar arrangement and ties (Step 5).
class ReinforcementDetailingScreen extends ConsumerWidget {
  const ReinforcementDetailingScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(columnDesignControllerProvider);
    final notifier = ref.read(columnDesignControllerProvider.notifier);

    return SbPage.form(
      title: 'Reinforcement Detailing',
      primaryAction: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SbButton.primary(
            label: 'Next: Safety Checks',
            onPressed: () {
              context.push('/column/safety');
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
              'Step 5 of 6: Steel Arrangement',
              style: Theme.of(context).textTheme.titleLarge!,
            ),
          ),

          // ── REBAR LAYOUT SECTION ──
          SbSection(
            title: 'Sectional Arrangement',
            child: RebarLayoutDiagram(
              type: state.type,
              width: state.b,
              depth: state.d,
              numBars: state.numBars,
              mainBarDia: state.mainBarDia,
              ast: state.astProvided,
            ),
          ),

          // ── MAIN LONGITUDINAL BARS ──
          SbSection(
            title: 'Main Longitudinal Bars',
            child: SbCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bar Diameter',
                    style: Theme.of(context).textTheme.labelLarge!,
                  ),
                  const SizedBox(height: SbSpacing.sm),
                  SbDropdown<double>(
                    value: state.mainBarDia,
                    items: const [12, 16, 20, 25, 32],
                    itemLabelBuilder: (d) => '${d.toInt()} mm',
                    onChanged: (v) {
                      if (v != null) {
                        notifier.updateReinforcement(mainBarDia: v);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),

          // ── LONGITUDINAL RESULTS ──
          SbSection(
            title: 'Steel Area Provided',
            child: DesignResultCard(
              title: 'Verification',
              isSafe: state.astProvided >= state.astRequired,
              items: [
                DesignResultItem(
                  label: 'Number of Bars',
                  value: '${state.numBars}',
                  unit: 'Nos',
                ),
                DesignResultItem(
                  label: 'Required Ast',
                  value: state.astRequired.toStringAsFixed(0),
                  unit: 'mm²',
                ),
                DesignResultItem(
                  label: 'Provided Ast',
                  value: state.astProvided.toStringAsFixed(0),
                  unit: 'mm²',
                  isCritical: true,
                ),
              ],
            ),
          ),

          // ── TRANSVERSE TIES ──
          SbSection(
            title: 'Transverse Ties (Links)',
            child: DesignResultCard(
              title: 'Detailing',
              isSafe: true,
              items: [
                DesignResultItem(
                  label: 'Tie Diameter (min)',
                  value: state.tieDia.toStringAsFixed(0),
                  unit: 'mm',
                ),
                DesignResultItem(
                  label: 'Max Spacing (s)',
                  value: state.tieSpacing.toStringAsFixed(0),
                  unit: 'mm c/c',
                  isCritical: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}











