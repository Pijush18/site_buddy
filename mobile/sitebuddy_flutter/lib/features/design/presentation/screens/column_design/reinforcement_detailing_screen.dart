import 'package:site_buddy/core/design_system/sb_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/widgets/app_card.dart';
import 'package:site_buddy/features/design/application/controllers/column_design_controller.dart';
import 'package:site_buddy/features/design/presentation/widgets/engineering_diagrams/rebar_layout_diagram.dart';
import 'package:site_buddy/features/design/presentation/widgets/engineering_diagrams/design_result_card.dart';
import 'package:site_buddy/shared/widgets/action_buttons_group.dart';

/// SCREEN: ReinforcementDetailingScreen
/// PURPOSE: Bar arrangement and ties (Step 5).
class ReinforcementDetailingScreen extends ConsumerWidget {
  const ReinforcementDetailingScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(columnDesignControllerProvider);
    final notifier = ref.read(columnDesignControllerProvider.notifier);

    return SbPage.detail(
      title: 'Reinforcement Detailing',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Step 5 of 6: Steel Arrangement',
            style: SbTextStyles.caption(context).copyWith(color: Colors.grey),
          ),
          const SizedBox(height: AppLayout.sectionGap),
          RebarLayoutDiagram(
            type: state.type,
            width: state.b,
            depth: state.d,
            numBars: state.numBars,
            mainBarDia: state.mainBarDia,
            ast: state.astProvided,
          ),
          const SizedBox(height: AppLayout.sectionGap),
          AppCard(
            padding: const EdgeInsets.all(AppLayout.cardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Main Longitudinal Bars',
                  style: SbTextStyles.body(context),
                ),
                const SizedBox(height: AppLayout.md),
                Text(
                  'Select Bar Diameter',
                  style: SbTextStyles.caption(context).copyWith(color: Colors.grey),
                ),
                const SizedBox(height: AppLayout.xs),
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
          const SizedBox(height: AppLayout.elementGap),
          DesignResultCard(
            title: 'Longitudinal Results',
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
          const SizedBox(height: AppLayout.elementGap),
          DesignResultCard(
            title: 'Transverse Ties (Links)',
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
          const SizedBox(height: AppLayout.sectionGap),
          ActionButtonsGroup(
            children: [
              SbButton.primary(
                label: 'Next: Safety Checks',
                onPressed: () {
                  context.push('/column/safety');
                },
              ),
              SbButton.primary(
                label: 'Back',
                onPressed: () => context.pop(),
              ),
            ],
          ),
          const SizedBox(height: AppLayout.sectionGap),
        ],
      ),
    );
  }
}
