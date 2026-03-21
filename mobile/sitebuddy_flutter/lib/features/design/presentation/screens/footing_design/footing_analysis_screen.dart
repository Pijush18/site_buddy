import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/shared/domain/models/design/footing_type.dart';
import 'package:site_buddy/features/design/application/controllers/footing_design_controller.dart';
import 'package:site_buddy/features/design/presentation/widgets/engineering_diagrams/design_result_card.dart';

/// SCREEN: FootingAnalysisScreen
/// PURPOSE: Bearing pressure and area analysis (Step 4).
class FootingAnalysisScreen extends ConsumerWidget {
  const FootingAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(footingDesignControllerProvider);

    return SbPage.form(
      title: 'Soil Analysis',
      primaryAction: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PrimaryCTA(
            label: 'Next: Reinforcement',
            icon: Icons.grid_view_outlined,
            onPressed: () => context.push('/footing/reinforcement'),
          ),
          const SizedBox(height: SbSpacing.sm),
          GhostButton(
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
              'Step 4 of 6: Pressure Distribution',
              style: Theme.of(context).textTheme.titleLarge!,
            ),
          ),

          // ── AREA COMPARISON ──
          SbSection(
            title: 'Bearing Area',
            child: DesignResultCard(
              title: 'Verification',
              isSafe: state.isAreaSafe,
              items: [
                DesignResultItem(
                  label: 'Required Area',
                  value: state.requiredArea.toStringAsFixed(2),
                  unit: 'm²',
                  subtitle: 'Includes 10% self-weight',
                ),
                DesignResultItem(
                  label: 'Provided Area',
                  value: state.providedArea.toStringAsFixed(2),
                  unit: 'm²',
                  isCritical: true,
                ),
              ],
            ),
          ),

          // ── PRESSURE ANALYSIS ──
          SbSection(
            title: 'Soil Pressure',
            child: DesignResultCard(
              title: 'Pressure Check',
              isSafe: state.maxSoilPressure <= state.sbc,
              items: [
                DesignResultItem(
                  label: 'Max. Pressure (q_max)',
                  value: state.maxSoilPressure.toStringAsFixed(2),
                  unit: 'kN/m²',
                  isCritical: true,
                ),
                DesignResultItem(
                  label: 'Min. Pressure (q_min)',
                  value: state.minSoilPressure.toStringAsFixed(2),
                  unit: 'kN/m²',
                ),
                DesignResultItem(
                  label: 'Allowable (SBC)',
                  value: state.sbc.toStringAsFixed(2),
                  unit: 'kN/m²',
                  subtitle: 'Serviceability Limit State',
                ),
              ],
            ),
          ),

          // ── DISTRIBUTION DETAILS ──
          SbSection(
            title: 'Distribution Details',
            child: SbCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SbListItemTile(
                    title: 'Eccentricity (ex)',
                    onTap: () {}, // Detail view entry
                    trailing: Text(
                      '${state.eccentricityX.toStringAsFixed(1)} mm',
                      style: Theme.of(context).textTheme.labelLarge!,
                    ),
                  ),
                  if (state.type == FootingType.pile) ...[
                    const SizedBox(height: SbSpacing.sm),
                    SbListItemTile(
                      title: 'Piles Required',
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










