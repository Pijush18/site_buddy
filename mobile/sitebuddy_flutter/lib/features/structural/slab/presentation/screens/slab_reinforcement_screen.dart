import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/localization/l10n_extension.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/features/structural/slab/application/slab_design_controller.dart';
import 'package:site_buddy/features/structural/shared/presentation/widgets/engineering_diagrams/design_result_card.dart';

class SlabReinforcementScreen extends ConsumerWidget {
  const SlabReinforcementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(slabDesignControllerProvider);
    final colorScheme = Theme.of(context).colorScheme;

    if (state.result == null) {
      return SbPage.scaffold(
        title: context.l10n.titleReinforcement,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final l10n = context.l10n;

    return SbPage.form(
      title: l10n.titleReinforcement,
      primaryAction: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PrimaryCTA(
            label: l10n.actionCalculate,
            onPressed: () => context.push('/slab/safety'),
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
            child: Text(
              l10n.labelStep4Reinforcement,
              style: Theme.of(context).textTheme.titleLarge!,
            ),
          ),

          // ── STEEL AREA CHECK ──
          SbSection(
            title: l10n.labelSteelAreaCheck,
            child: DesignResultCard(
              title: l10n.labelVerification,
              isSafe: state.result!.astProvided >= state.result!.astRequired,
              items: [
                DesignResultItem(
                  label: l10n.labelRequiredAstUnit,
                  value:
                      '${state.result!.astRequired.toStringAsFixed(0)} mm²/m',
                ),
                DesignResultItem(
                  label: l10n.labelProvidedAstUnit,
                  value:
                      '${state.result!.astProvided.toStringAsFixed(0)} mm²/m',
                ),
              ],
              codeReference: 'IS 456 Cl. 26.5.2.1',
            ),
          ),

          // ── PRACTICAL DETAILING ──
          SbSection(
            title: l10n.labelPracticalDetailing,
            child: DesignResultCard(
              title: l10n.labelLayoutStrategy,
              isSafe: true,
              items: [
                DesignResultItem(
                  label: l10n.labelMainRebar,
                  value: state.result!.mainRebar,
                  isCritical: true,
                ),
                DesignResultItem(
                  label: l10n.labelDistributionSteel,
                  value: state.result!.distributionSteel,
                ),
              ],
            ),
          ),

          // ── INSIGHTS ──
          SbSection(
            title: l10n.labelDetailingRules,
            child: SbCard(
              child: Column(
                children: [
                  Icon(
                    Icons.layers_outlined,
                    size: 64,
                    color: colorScheme.secondary.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    l10n.labelSlabDetailingInsight,
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












