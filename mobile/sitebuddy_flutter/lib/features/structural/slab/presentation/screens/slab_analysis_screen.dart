import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/localization/l10n_extension.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/features/structural/slab/application/slab_design_controller.dart';
import 'package:site_buddy/features/structural/shared/presentation/widgets/engineering_diagrams/design_result_card.dart';

class SlabAnalysisScreen extends ConsumerWidget {
  const SlabAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(slabDesignControllerProvider);
    final colorScheme = Theme.of(context).colorScheme;

    if (state.result == null) {
      return SbPage.scaffold(
        title: context.l10n.titleAnalysis,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final totalLoad = (state.deadLoad + state.liveLoad) * 1.5;

    final l10n = context.l10n;

    return SbPage.form(
      title: l10n.titleAnalysis,
      primaryAction: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PrimaryCTA(
            label: l10n.actionNext,
            onPressed: () => context.push('/slab/reinforcement'),
            icon: Icons.engineering_outlined,
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
            child: Text(
              l10n.labelStep3Analysis,
              style: Theme.of(context).textTheme.titleLarge!,
            ),
          ),

          // ── ANALYSIS RESULTS ──
          SbSection(
            title: l10n.labelResults,
            child: DesignResultCard(
              title: l10n.labelVerification,
              isSafe: true,
              items: [
                DesignResultItem(
                  label: l10n.labelTotalLoad,
                  value: '${totalLoad.toStringAsFixed(2)} kN/m²',
                ),
                DesignResultItem(
                  label: l10n.labelMomentMu,
                  value:
                      '${state.result!.bendingMoment.toStringAsFixed(2)} kNm/m',
                  isCritical: true,
                ),
                DesignResultItem(
                  label: l10n.labelType,
                  value: state.type.label,
                ),
              ],
              codeReference: 'IS 456 Annex D',
            ),
          ),

          // ── INSIGHTS ──
          SbSection(
            title: l10n.labelInsights,
            child: SbCard(
              child: Column(
                children: [
                  Icon(
                    Icons.analytics_outlined,
                    size: 64,
                    color: colorScheme.primary.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    l10n.labelSlabMomentInsight,
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












