import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/theme/app_font_sizes.dart';
import 'package:site_buddy/core/widgets/app_screen_wrapper.dart';
import 'package:site_buddy/core/widgets/components/sb_button.dart';
import 'package:site_buddy/core/widgets/components/sb_card.dart';
import 'package:site_buddy/features/design/application/controllers/slab_design_controller.dart';
import 'package:site_buddy/features/design/presentation/widgets/engineering_diagrams/design_result_card.dart';

class SlabReinforcementScreen extends ConsumerWidget {
  const SlabReinforcementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(slabDesignControllerProvider);
    final colorScheme = Theme.of(context).colorScheme;

    if (state.result == null) {
      return const AppScreenWrapper(
        title: 'Reinforcement Design',
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return AppScreenWrapper(
      title: 'Reinforcement Details',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Step 4 of 5: Steel Detailing',
            style: TextStyle(
              fontSize: AppFontSizes.title,
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24

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
          const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24

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
          const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24

          SBCard(
            child: Column(
              children: [
                Icon(Icons.layers_outlined,
                    size: 64, color: colorScheme.secondary.withValues(alpha: 0.5)),
                const SizedBox(height: AppSpacing.sm),
                const Text(
                  'Rebar spacing should not exceed 3d or 300mm for main rebar.',
                  style: TextStyle(fontSize: AppFontSizes.tab),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap32 (closest standard)

          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SBButton.primary(
                label: 'Next: Safety Check',
                onPressed: () => context.push('/slab/safety'),
                icon: Icons.security_outlined,
                fullWidth: true,
              ),
              const SizedBox(height: AppSpacing.sm),
              SBButton.secondary(
                label: 'Back',
                onPressed: () => context.pop(),
                fullWidth: true,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg), // Added for bottom padding consistency
        ],
      ),
    );
  }
}
