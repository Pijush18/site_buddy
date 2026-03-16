import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/theme/app_font_sizes.dart';
import 'package:site_buddy/core/widgets/app_screen_wrapper.dart';
import 'package:site_buddy/core/widgets/components/sb_button.dart';
import 'package:site_buddy/core/widgets/components/sb_card.dart';
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
      return const AppScreenWrapper(
        title: 'Analysis Summary',
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final totalLoad = (state.deadLoad + state.liveLoad) * 1.5;

    return AppScreenWrapper(
      title: 'Analysis Summary',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Step 3 of 5: Bending Capacity',
            style: TextStyle(
              fontSize: AppFontSizes.title,
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24

          DesignResultCard(
            title: 'Analysis Results',
            isSafe: true, 
            items: [
              DesignResultItem(
                label: 'Total Factored Load (wu)',
                value: '${totalLoad.toStringAsFixed(2)} kN/m²',
              ),
              DesignResultItem(
                label: 'Factored Moment (Mu)',
                value: '${state.result!.bendingMoment.toStringAsFixed(2)} kNm/m',
                isCritical: true,
              ),
              DesignResultItem(
                label: 'Slab behavior',
                value: state.type.label,
              ),
            ],
            codeReference: 'IS 456 Annex D',
          ),
          const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24

          SBCard(
            child: Column(
              children: [
                Icon(Icons.analytics_outlined,
                    size: 64, color: colorScheme.primary.withValues(alpha: 0.5)),
                const SizedBox(height: AppSpacing.sm),
                const Text(
                  'Maximum moment occurs at the midspan for a simply supported slab.',
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
                label: 'Next: Reinforcement Design',
                onPressed: () => context.push('/slab/reinforcement'),
                icon: Icons.engineering_outlined,
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
