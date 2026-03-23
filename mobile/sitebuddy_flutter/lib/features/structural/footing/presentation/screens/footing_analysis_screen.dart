import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/localization/l10n_extension.dart';
import 'package:site_buddy/features/structural/footing/domain/footing_type.dart';
import 'package:site_buddy/features/structural/footing/application/footing_design_controller.dart';
import 'package:site_buddy/features/structural/shared/presentation/widgets/engineering_diagrams/design_result_card.dart';

/// SCREEN: FootingAnalysisScreen
/// PURPOSE: Bearing pressure and area analysis (Step 4).
class FootingAnalysisScreen extends ConsumerWidget {
  const FootingAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final state = ref.watch(footingDesignControllerProvider);

    return SbPage.form(
      title: l10n.titleAnalysis,
      primaryAction: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PrimaryCTA(
            label: l10n.actionNext,
            icon: Icons.grid_view_outlined,
            onPressed: () => context.push('/footing/reinforcement'),
          ),
          const SizedBox(height: SbSpacing.sm),
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
              l10n.labelStep4Analysis,
              style: Theme.of(context).textTheme.titleLarge!,
            ),
          ),

          // ── AREA COMPARISON ──
          SbSection(
            title: l10n.labelBearingArea,
            child: DesignResultCard(
              title: l10n.labelVerification,
              isSafe: state.isAreaSafe,
              items: [
                DesignResultItem(
                  label: l10n.labelAreaReq,
                  value: state.requiredArea.toStringAsFixed(2),
                  unit: 'm²',
                  subtitle: l10n.msgSelfWeightIncluded,
                ),
                DesignResultItem(
                  label: l10n.labelAreaProv,
                  value: state.providedArea.toStringAsFixed(2),
                  unit: 'm²',
                  isCritical: true,
                ),
              ],
            ),
          ),

          // ── PRESSURE ANALYSIS ──
          SbSection(
            title: l10n.labelSoilPressure,
            child: DesignResultCard(
              title: l10n.labelPressure,
              isSafe: state.maxSoilPressure <= state.sbc,
              items: [
                DesignResultItem(
                  label: l10n.labelMaxPressure,
                  value: state.maxSoilPressure.toStringAsFixed(2),
                  unit: 'kN/m²',
                  isCritical: true,
                ),
                DesignResultItem(
                  label: l10n.labelMinPressure,
                  value: state.minSoilPressure.toStringAsFixed(2),
                  unit: 'kN/m²',
                ),
                DesignResultItem(
                  label: l10n.labelAllowable,
                  value: state.sbc.toStringAsFixed(2),
                  unit: 'kN/m²',
                  subtitle: l10n.msgSlsLimit,
                ),
              ],
            ),
          ),

          // ── DISTRIBUTION DETAILS ──
          SbSection(
            title: l10n.labelDetails,
            child: SbCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SbListItemTile(
                    title: l10n.labelEccentricity,
                    onTap: () {}, // Detail view entry
                    trailing: Text(
                      '${state.eccentricityX.toStringAsFixed(1)} mm',
                      style: Theme.of(context).textTheme.labelLarge!,
                    ),
                  ),
                  if (state.type == FootingType.pile) ...[
                    const SizedBox(height: SbSpacing.sm),
                    SbListItemTile(
                      title: l10n.labelPilesRequired,
                      onTap: () {}, // Detail view entry
                      trailing: Text(
                        '${state.pileCount}',
                        style: Theme.of(context).textTheme.labelLarge!,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}











