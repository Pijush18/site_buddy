import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/theme/app_font_sizes.dart';
import 'package:site_buddy/core/widgets/app_screen_wrapper.dart';
import 'package:site_buddy/core/widgets/components/sb_button.dart';
import 'package:site_buddy/core/widgets/components/sb_card.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/features/design/application/controllers/slab_design_controller.dart';
import 'package:site_buddy/features/design/presentation/widgets/engineering_diagrams/design_result_card.dart';
import 'package:site_buddy/features/design/presentation/widgets/design_advisor/design_advisor_card.dart';
import 'package:site_buddy/features/design/presentation/widgets/optimization/optimization_list.dart';
import 'package:site_buddy/features/design/presentation/providers/design_providers.dart';
import 'package:site_buddy/core/services/design_advisor_service.dart';

class SlabSafetyScreen extends ConsumerWidget {
  const SlabSafetyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(slabDesignControllerProvider);
    final colorScheme = Theme.of(context).colorScheme;

    if (state.result == null) {
      return const AppScreenWrapper(
        title: 'Safety Check',
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final optimizationResult = ref.watch(slabOptimizationProvider);
    final advisorResult = ref.read(designAdvisorServiceProvider).advise(
      category: 'slab',
      optimizationResult: optimizationResult,
    );

    return AppScreenWrapper(
      title: 'Safety Check',
      actions: [
        IconButton(
          icon: const Icon(Icons.share_outlined),
          tooltip: 'Share Report',
          onPressed: () => ref.read(slabDesignControllerProvider.notifier).generateReport(),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Final Step: Engineering Validation',
            style: TextStyle(
              fontSize: AppFontSizes.title,
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24

          DesignResultCard(
            title: 'Critical Safety Status',
            isSafe: state.result!.isDeflectionSafe && state.result!.isShearSafe,
            items: [
              DesignResultItem(
                label: 'Deflection Check',
                value: state.result!.isDeflectionSafe ? 'SAFE' : 'ACTION REQUIRED',
                isCritical: !state.result!.isDeflectionSafe,
              ),
              DesignResultItem(
                label: 'Shear Check',
                value: state.result!.isShearSafe ? 'PASS' : 'FAIL',
              ),
              DesignResultItem(
                label: 'Cracking Limit',
                value: state.result!.isCrackingSafe ? 'OK' : 'FAIL',
              ),
            ],
            codeReference: 'IS 456 Cl. 23.2.1',
          ),
          const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24

          DesignAdvisorCard(advisorResult: advisorResult),
          const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24

          if (optimizationResult.options.isNotEmpty) ...[
            const Text(
              'ECONOMICAL ALTERNATIVES',
              style: TextStyle(
                fontSize: AppFontSizes.title,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.md), // Replaced AppLayout.vGap16
            OptimizationList(
              options: optimizationResult.options,
              onOptionSelected: (opt) {
                final thickness = opt.parameters['thickness'] as double;
                ref.read(slabDesignControllerProvider.notifier).updateDepth(thickness);
                ref.read(slabDesignControllerProvider.notifier).calculate();
              },
            ),
            const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24
          ],

          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SBButton.primary(
                label: 'Export PDF Design Report',
                onPressed: () => ref.read(slabDesignControllerProvider.notifier).generateReport(),
                icon: Icons.picture_as_pdf_outlined,
                fullWidth: true,
              ),
              const SizedBox(height: AppSpacing.sm),
              SBButton.secondary(
                label: 'Back',
                onPressed: () => Navigator.of(context).pop(),
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
