import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:site_buddy/core/navigation/app_routes.dart';

import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/localization/l10n_extension.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/utils/validation_helper.dart';
import 'package:site_buddy/features/structural/slab/application/slab_design_controller.dart';

class SlabLoadScreen extends ConsumerStatefulWidget {
  const SlabLoadScreen({super.key});

  @override
  ConsumerState<SlabLoadScreen> createState() => _SlabLoadScreenState();
}

class _SlabLoadScreenState extends ConsumerState<SlabLoadScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _dlController;
  late final TextEditingController _llController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(slabDesignControllerProvider);
    _dlController = TextEditingController(text: state.deadLoad.toString());
    _llController = TextEditingController(text: state.liveLoad.toString());
  }

  @override
  void dispose() {
    _dlController.dispose();
    _llController.dispose();
    super.dispose();
  }

  void _onCalculate() {
    if (!_formKey.currentState!.validate()) return;

    ref.read(slabDesignControllerProvider.notifier).updateLoads(
      dl: double.parse(_dlController.text),
      ll: double.parse(_llController.text),
    );

    // Trigger calculation
    ref.read(slabDesignControllerProvider.notifier).calculate();

    context.push(AppRoutes.slabAnalysis);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SbPage.form(
      title: l10n.titleSlab,
      primaryAction: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PrimaryCTA(
            label: l10n.actionNext,
            onPressed: _onCalculate,
            icon: Icons.calculate_outlined,
          ),
          const SizedBox(height: SbSpacing.md),
          GhostButton(
            label: l10n.actionBack,
            onPressed: () => context.pop(),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SbSectionList(
          sections: [
            // ── STEP HEADER ──
            SbSection(
              child: Text(
                l10n.labelStep2Loads,
                style: Theme.of(context).textTheme.titleLarge!,
              ),
            ),

            // ── LOADS SECTION ──
            SbSection(
              title: l10n.labelLoadsUnit,
              child: SbCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SbInput(
                      controller: _dlController,
                      label: l10n.labelDeadLoad,
                      validator: (v) =>
                          ValidationHelper.validatePositive(v, 'Dead Load'),
                    ),
                    const SizedBox(height: SbSpacing.md),
                    SbInput(
                      controller: _llController,
                      label: l10n.labelLiveLoad,
                      validator: (v) =>
                          ValidationHelper.validatePositive(v, 'Live Load'),
                    ),
                    const SizedBox(height: SbSpacing.sm),
                    Text(
                      l10n.labelFactorApplied,
                      style: Theme.of(context).textTheme.labelMedium!,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

