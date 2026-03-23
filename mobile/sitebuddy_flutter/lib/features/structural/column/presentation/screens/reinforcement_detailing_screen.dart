import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/localization/l10n_extension.dart';

import 'package:site_buddy/features/structural/column/application/column_design_controller.dart';
import 'package:site_buddy/features/structural/shared/presentation/widgets/engineering_diagrams/rebar_layout_diagram.dart';
import 'package:site_buddy/features/structural/shared/presentation/widgets/engineering_diagrams/design_result_card.dart';

/// SCREEN: ReinforcementDetailingScreen
/// PURPOSE: Bar arrangement and ties (Step 5).
class ReinforcementDetailingScreen extends ConsumerWidget {
  const ReinforcementDetailingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final state = ref.watch(columnDesignControllerProvider);
    final notifier = ref.read(columnDesignControllerProvider.notifier);

    return SbPage.form(
      title: l10n.titleReinforcement,
      primaryAction: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PrimaryCTA(
            label: l10n.actionCalculate,
            onPressed: () {
              context.push('/column/safety');
            },
            icon: Icons.calculate_outlined,
          ),
          const SizedBox(height: AppSpacing.sm),
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
              l10n.labelStep5Detailing,
              style: Theme.of(context).textTheme.titleLarge!,
            ),
          ),

          // ── REBAR LAYOUT SECTION ──
          SbSection(
            title: l10n.labelDetails,
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
            title: l10n.labelMainBars,
            child: SbCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
            title: l10n.labelResults,
            child: DesignResultCard(
              title: l10n.labelVerification,
              isSafe: state.astProvided >= state.astRequired,
              items: [
                DesignResultItem(
                  label: l10n.labelNumberOfBars,
                  value: '${state.numBars}',
                  unit: 'Nos',
                ),
                DesignResultItem(
                  label: l10n.labelAstRequiredUnit,
                  value: state.astRequired.toStringAsFixed(0),
                ),
                DesignResultItem(
                  label: l10n.labelAstProvidedUnit,
                  value: state.astProvided.toStringAsFixed(0),
                  isCritical: true,
                ),
              ],
            ),
          ),

          // ── TRANSVERSE TIES ──
          SbSection(
            title: l10n.labelLateralTies,
            child: DesignResultCard(
              title: l10n.labelDetails,
              isSafe: true,
              items: [
                DesignResultItem(
                  label: l10n.labelTieDiaMinUnit,
                  value: state.tieDia.toStringAsFixed(0),
                ),
                DesignResultItem(
                  label: l10n.labelSpacingSUnit,
                  value: state.tieSpacing.toStringAsFixed(0),
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












