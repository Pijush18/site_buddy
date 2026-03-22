import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/localization/l10n_extension.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/features/design/application/controllers/slab_design_controller.dart';
import 'package:site_buddy/features/design/application/controllers/slab_safety_controller.dart';
import 'package:site_buddy/features/design/presentation/widgets/engineering_diagrams/design_result_card.dart';
import 'package:site_buddy/features/design/presentation/widgets/design_advisor/design_advisor_card.dart';
import 'package:site_buddy/features/design/presentation/widgets/optimization/optimization_list.dart';
import 'package:site_buddy/features/design/presentation/providers/design_providers.dart';
import 'package:site_buddy/core/services/design_advisor_service.dart';


class SlabSafetyScreen extends ConsumerStatefulWidget {
  const SlabSafetyScreen({super.key});

  @override
  ConsumerState<SlabSafetyScreen> createState() => _SlabSafetyScreenState();
}

class _SlabSafetyScreenState extends ConsumerState<SlabSafetyScreen> {

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(slabDesignControllerProvider);

    if (state.result == null) {
      return SbPage.scaffold(
        title: context.l10n.titleSafetyCheck,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final optimizationResult = ref.watch(slabOptimizationProvider);
    final advisorResult = ref.read(designAdvisorServiceProvider).advise(
      category: 'slab',
      optimizationResult: optimizationResult,
    );

    final l10n = context.l10n;

    return SbPage.form(
      title: l10n.titleSafetyCheck,
      primaryAction: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PrimaryCTA(
            label: l10n.actionExportPdf,
            onPressed: () async {
              debugPrint('CTA CLICKED: Export PDF');
              
              final safetyState = ref.read(slabSafetyControllerProvider);
              if (optimizationResult.options.isNotEmpty && safetyState.selectedOption == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.snackbarSelectOption)),
                );
                return;
              }

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.snackbarGeneratingReport)),
              );
              try {
                await ref.read(slabDesignControllerProvider.notifier).generateReport();
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error generating report: $e'), backgroundColor: Colors.red),
                  );
                }
              }
            },
            icon: Icons.picture_as_pdf_outlined,
          ),
          const SizedBox(height: SbSpacing.md),
          GhostButton(
            label: l10n.actionBack,
            onPressed: () => context.pop(),
          ),
        ],
      ),
      appBarActions: [
        IconButton(
          icon: const Icon(Icons.share_outlined),
          tooltip: l10n.labelShareReport,
          onPressed: () async {
            final safetyState = ref.read(slabSafetyControllerProvider);
            if (optimizationResult.options.isNotEmpty && safetyState.selectedOption == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.snackbarSelectOption)),
              );
              return;
            }
            try {
              await ref.read(slabDesignControllerProvider.notifier).generateReport();
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error generating report: $e'), backgroundColor: Colors.red),
                );
              }
            }
          },
        ),
      ],
      body: SbSectionList(
        sections: [
          // ── STEP HEADER ──
          SbSection(
            child: Text(
              l10n.labelStepValidation,
              style: Theme.of(context).textTheme.titleLarge!,
            ),
          ),

          // ── SAFETY STATUS ──
          SbSection(
            title: l10n.labelCriticalSafetyStatus,
            child: DesignResultCard(
              title: l10n.labelDetails,
              isSafe:
                  state.result!.isDeflectionSafe && state.result!.isShearSafe,
              items: [
                DesignResultItem(
                  label: l10n.labelDeflection,
                  value: state.result!.isDeflectionSafe
                      ? l10n.labelSafeCaps
                      : l10n.labelActionRequired,
                  isCritical: !state.result!.isDeflectionSafe,
                ),
                DesignResultItem(
                  label: l10n.labelShear,
                  value: state.result!.isShearSafe ? l10n.labelPass : l10n.labelFail,
                ),
                DesignResultItem(
                  label: l10n.labelCracking,
                  value: state.result!.isCrackingSafe ? l10n.labelOk : l10n.labelFail,
                ),
              ],
              codeReference: 'IS 456 Cl. 23.2.1',
            ),
          ),

          // ── ADVISOR ──
          SbSection(
            title: l10n.labelDesignAdvisorService,
            child: DesignAdvisorCard(advisorResult: advisorResult),
          ),

          // ── OPTIMIZATION ──
          if (optimizationResult.options.isNotEmpty)
            SbSection(
              title: l10n.labelEconomicalAlternatives,
              child: OptimizationList(
                options: optimizationResult.options,
                onOptionSelected: (opt) {
                  debugPrint('OPTION CLICKED: Select Option ($opt)');
                  ref.read(slabSafetyControllerProvider.notifier).selectOption(opt);
                  
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











