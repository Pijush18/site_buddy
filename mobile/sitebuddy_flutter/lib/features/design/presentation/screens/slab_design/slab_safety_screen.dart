import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:site_buddy/core/design_system/sb_spacing.dart';
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

    return SbPage.form(
      title: 'Safety Check',
      primaryAction: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PrimaryCTA(
            label: 'Export PDF Design Report',
            onPressed: () => ref
                .read(slabDesignControllerProvider.notifier)
                .generateReport(),
            icon: Icons.picture_as_pdf_outlined,
          ),
          const SizedBox(height: SbSpacing.sm),
          GhostButton(
            label: 'Back',
            onPressed: () => context.pop(),
          ),
        ],
      ),
      appBarActions: [
        IconButton(
          icon: const Icon(Icons.share_outlined),
          tooltip: 'Share Report',
          onPressed: () =>
              ref.read(slabDesignControllerProvider.notifier).generateReport(),
        ),
      ],
      body: SbSectionList(
        sections: [
          // ── STEP HEADER ──
          SbSection(
            child: Text(
              'Final Step: Engineering Validation',
              style: Theme.of(context).textTheme.titleLarge!,
            ),
          ),

          // ── SAFETY STATUS ──
          SbSection(
            title: 'Critical Safety Status',
            child: DesignResultCard(
              title: 'Verification Details',
              isSafe:
                  state.result!.isDeflectionSafe && state.result!.isShearSafe,
              items: [
                DesignResultItem(
                  label: 'Deflection Check',
                  value: state.result!.isDeflectionSafe
                      ? 'SAFE'
                      : 'ACTION REQUIRED',
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
          ),

          // ── ADVISOR ──
          SbSection(
            title: 'Design Advisor',
            child: DesignAdvisorCard(advisorResult: advisorResult),
          ),

          // ── OPTIMIZATION ──
          if (optimizationResult.options.isNotEmpty)
            SbSection(
              title: 'Economical Alternatives',
              child: OptimizationList(
                options: optimizationResult.options,
                onOptionSelected: (opt) {
                  final thickness = opt.parameters['thickness'] as double;
                  ref
                      .read(slabDesignControllerProvider.notifier)
                      .updateDepth(thickness);
                  ref.read(slabDesignControllerProvider.notifier).calculate();
                },
              ),
            ),
        ],
      ),
    );
  }
}











