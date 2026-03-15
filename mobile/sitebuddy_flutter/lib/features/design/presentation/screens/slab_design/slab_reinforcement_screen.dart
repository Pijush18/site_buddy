import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
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

    return SbPage.detail(
      title: 'Reinforcement Details',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Step 4 of 5: Steel Detailing',
            style: SbTextStyles.title(context).copyWith(color: colorScheme.primary),
          ),
          AppLayout.vGap24,

          DesignResultCard(
            title: 'Steel Area Check',
            isSafe: state.result!.astProvided >= state.result!.astRequired,
            items: [
              DesignResultItem(
                label: 'Required Ast',
                value: '${state.result!.astRequired.toStringAsFixed(0)} mm²/m',
              ),
              DesignResultItem(
                label: 'Provided Ast',
                value: '${state.result!.astProvided.toStringAsFixed(0)} mm²/m',
              ),
            ],
            codeReference: 'IS 456 Cl. 26.5.2.1',
          ),
          AppLayout.vGap24,

          DesignResultCard(
            title: 'Practical Detailing',
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
          AppLayout.vGap24,

          SbCard(
            child: Column(
              children: [
                Icon(SbIcons.rebar, size: 64, color: colorScheme.secondary.withValues(alpha: 0.5)),
                AppLayout.vGap8,
                Text(
                   'Rebar spacing should not exceed 3d or 300mm for main rebar.',
                   style: SbTextStyles.caption(context),
                   textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          AppLayout.vGap32,

          SbButton.primary(
            label: 'Next: Safety Check',
            onPressed: () => context.push('/slab/safety'),
            icon: SbIcons.shield,
          ),
        ],
      ),
    );
  }
}
