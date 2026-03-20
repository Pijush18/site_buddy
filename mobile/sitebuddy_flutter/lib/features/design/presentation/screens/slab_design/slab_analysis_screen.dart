import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/features/design/application/controllers/slab_design_controller.dart';
import 'package:site_buddy/features/design/presentation/widgets/engineering_diagrams/design_result_card.dart';

class SlabAnalysisScreen extends ConsumerWidget {
  const SlabAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(slabDesignControllerProvider);
    final colorScheme = Theme.of(context).colorScheme;

    if (state.result == null) {
      return const SbPage.scaffold(
        title: 'Analysis Summary',
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final totalLoad = (state.deadLoad + state.liveLoad) * 1.5;

    return SbPage.form(
      title: 'Analysis Summary',
      primaryAction: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SbButton.primary(
            label: 'Next: Reinforcement Design',
            onPressed: () => context.push('/slab/reinforcement'),
            icon: Icons.engineering_outlined,
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
              'Step 3 of 5: Bending Capacity',
              style: Theme.of(context).textTheme.titleLarge!,
            ),
          ),

          // ── ANALYSIS RESULTS ──
          SbSection(
            title: 'Analysis Results',
            child: DesignResultCard(
              title: 'Verification',
              isSafe: true,
              items: [
                DesignResultItem(
                  label: 'Total Factored Load (wu)',
                  value: '${totalLoad.toStringAsFixed(2)} kN/m²',
                ),
                DesignResultItem(
                  label: 'Factored Moment (Mu)',
                  value:
                      '${state.result!.bendingMoment.toStringAsFixed(2)} kNm/m',
                  isCritical: true,
                ),
                DesignResultItem(
                  label: 'Slab behavior',
                  value: state.type.label,
                ),
              ],
              codeReference: 'IS 456 Annex D',
            ),
          ),

          // ── INSIGHTS ──
          SbSection(
            title: 'Engineering Insights',
            child: SbCard(
              child: Column(
                children: [
                  Icon(
                    Icons.analytics_outlined,
                    size: 64,
                    color: colorScheme.primary.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: SbSpacing.sm),
                  Text(
                    'Maximum moment occurs at the midspan for a simply supported slab.',
                    style: Theme.of(context).textTheme.bodyLarge!,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}











