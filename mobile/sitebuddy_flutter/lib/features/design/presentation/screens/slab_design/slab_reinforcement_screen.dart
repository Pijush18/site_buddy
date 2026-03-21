import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/features/design/application/controllers/slab_design_controller.dart';
import 'package:site_buddy/features/design/presentation/widgets/engineering_diagrams/design_result_card.dart';

class SlabReinforcementScreen extends ConsumerWidget {
  const SlabReinforcementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(slabDesignControllerProvider);
    final colorScheme = Theme.of(context).colorScheme;

    if (state.result == null) {
      return const SbPage.scaffold(
        title: 'Reinforcement Design',
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return SbPage.form(
      title: 'Reinforcement Details',
      primaryAction: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PrimaryCTA(
            label: 'Next: Safety Check',
            onPressed: () => context.push('/slab/safety'),
            icon: Icons.security_outlined,
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
              'Step 4 of 5: Steel Detailing',
              style: Theme.of(context).textTheme.titleLarge!,
            ),
          ),

          // ── STEEL AREA CHECK ──
          SbSection(
            title: 'Steel Area Check',
            child: DesignResultCard(
              title: 'Verification',
              isSafe: state.result!.astProvided >= state.result!.astRequired,
              items: [
                DesignResultItem(
                  label: 'Required Ast',
                  value:
                      '${state.result!.astRequired.toStringAsFixed(0)} mm²/m',
                ),
                DesignResultItem(
                  label: 'Provided Ast',
                  value:
                      '${state.result!.astProvided.toStringAsFixed(0)} mm²/m',
                ),
              ],
              codeReference: 'IS 456 Cl. 26.5.2.1',
            ),
          ),

          // ── PRACTICAL DETAILING ──
          SbSection(
            title: 'Practical Detailing',
            child: DesignResultCard(
              title: 'Layout Strategy',
              isSafe: true,
              items: [
                DesignResultItem(
                  label: 'Main Rebar',
                  value: state.result!.mainRebar,
                  isCritical: true,
                ),
                DesignResultItem(
                  label: 'Distribution Steel',
                  value: state.result!.distributionSteel,
                ),
              ],
            ),
          ),

          // ── INSIGHTS ──
          SbSection(
            title: 'Detailing Rules',
            child: SbCard(
              child: Column(
                children: [
                  Icon(
                    Icons.layers_outlined,
                    size: 64,
                    color: colorScheme.secondary.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: SbSpacing.sm),
                  Text(
                    'Rebar spacing should not exceed 3d or 300mm for main rebar.',
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











