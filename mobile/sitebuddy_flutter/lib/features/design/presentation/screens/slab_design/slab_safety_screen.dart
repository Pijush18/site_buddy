import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/features/design/application/controllers/slab_design_controller.dart';
import 'package:site_buddy/features/design/presentation/widgets/engineering_diagrams/design_result_card.dart';
import 'package:site_buddy/features/design/presentation/widgets/design_advisor/design_advisor_card.dart';
import 'package:site_buddy/features/design/presentation/widgets/optimization/optimization_list.dart';
import 'package:site_buddy/features/design/presentation/providers/design_providers.dart';
import 'package:site_buddy/core/services/design_advisor_service.dart';
// Remove optimization_result import if unused, it is often matched by design_providers.dart in this file context

class SlabSafetyScreen extends ConsumerWidget {
  const SlabSafetyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(slabDesignControllerProvider);
    final colorScheme = Theme.of(context).colorScheme;

    if (state.result == null) {
      return const SbPage.scaffold(
        title: 'Safety Check',
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final optimizationResult = ref.watch(slabOptimizationProvider);
    final advisorResult = ref.read(designAdvisorServiceProvider).advise(
      category: 'slab',
      optimizationResult: optimizationResult,
    );

    return SbPage.detail(
      title: 'Safety Check',
      appBarActions: [
        SbButton.icon(
          icon: SbIcons.share,
          tooltip: 'Share Report',
          onPressed: () => ref.read(slabDesignControllerProvider.notifier).generateReport(),
        ),
      ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Final Step: Engineering Validation',
            style: SbTextStyles.title(context).copyWith(color: colorScheme.primary),
          ),
          AppLayout.vGap24,

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
          AppLayout.vGap24,

          DesignAdvisorCard(advisorResult: advisorResult),
          AppLayout.vGap24,

          if (optimizationResult.options.isNotEmpty) ...[
            Text('ECONOMICAL ALTERNATIVES', style: SbTextStyles.title(context)),
            AppLayout.vGap16,
            OptimizationList(
              options: optimizationResult.options,
              onOptionSelected: (opt) {
                final thickness = opt.parameters['thickness'] as double;
                ref.read(slabDesignControllerProvider.notifier).updateDepth(thickness);
                ref.read(slabDesignControllerProvider.notifier).calculate();
              },
            ),
            AppLayout.vGap24,
          ],

          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SbButton.primary(
                label: 'Export PDF Design Report',
                onPressed: () => ref.read(slabDesignControllerProvider.notifier).generateReport(),
                icon: SbIcons.pdf,
              ),
              AppLayout.vGap12,
              SbButton.outline(
                label: 'Back',
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          AppLayout.vGap24,
        ],
      ),
    );
  }
}
