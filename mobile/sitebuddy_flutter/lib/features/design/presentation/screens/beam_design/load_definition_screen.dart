import 'package:site_buddy/core/design_system/sb_icons.dart';

import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';

import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



import 'package:site_buddy/core/utils/validation_helper.dart';
import 'package:site_buddy/features/design/application/controllers/beam_design_controller.dart';
import 'package:site_buddy/features/design/application/services/beam_validator.dart';

/// SCREEN: LoadDefinitionScreen
/// PURPOSE: Input for Dead, Live, and Point loads (Step 2).
class LoadDefinitionScreen extends ConsumerStatefulWidget {
  const LoadDefinitionScreen({super.key});

  @override
  ConsumerState<LoadDefinitionScreen> createState() =>
      _LoadDefinitionScreenState();
}

class _LoadDefinitionScreenState extends ConsumerState<LoadDefinitionScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _dlController;
  late final TextEditingController _llController;
  late final TextEditingController _plController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(beamDesignControllerProvider);
    _dlController = TextEditingController(
      text: state.deadLoad > 0 ? state.deadLoad.toString() : '',
    );
    _llController = TextEditingController(
      text: state.liveLoad > 0 ? state.liveLoad.toString() : '',
    );
    _plController = TextEditingController(
      text: state.pointLoad > 0 ? state.pointLoad.toString() : '',
    );
  }

  @override
  void dispose() {
    _dlController.dispose();
    _llController.dispose();
    _plController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (!_formKey.currentState!.validate()) return;

    final dl = double.tryParse(_dlController.text) ?? 0;
    final ll = double.tryParse(_llController.text) ?? 0;

    final error = BeamValidator.validateLoads(deadLoad: dl, liveLoad: ll);
    if (error != null) {
      SbFeedback.showToast(context: context, message: error, isError: true);
      return;
    }

    ref
        .read(beamDesignControllerProvider.notifier)
        .updateLoads(
          dl: dl,
          ll: ll,
          pl: _plController.text.isNotEmpty
              ? (double.tryParse(_plController.text) ?? 0)
              : 0,
        );

    ref.read(beamDesignControllerProvider.notifier).calculateAnalysis();

    context.push('/beam/analysis');
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(beamDesignControllerProvider);

    return SbPage.form(
      title: 'Loads',
      primaryAction: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PrimaryCTA(
            label: 'Calculate',
            onPressed: _onNext,
            icon: SbIcons.analytics,
          ),
          const SizedBox(height: SbSpacing.sm),
          GhostButton(
            label: 'Back',
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
                'Step 2: Loads',
                style: Theme.of(context).textTheme.titleLarge!,
              ),
            ),

            // ── LOADS SECTION ──
            SbSection(
              title: 'Vertical Loads',
              child: SbCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SbInput(
                      controller: _dlController,
                      label: 'Dead Load (kN/m)',
                      validator: (v) =>
                          ValidationHelper.validatePositive(v, 'Dead Load'),
                    ),
                    const SizedBox(height: SbSpacing.lg),
                    SbInput(
                      controller: _llController,
                      label: 'Live Load (kN/m)',
                      validator: (v) =>
                          ValidationHelper.validatePositive(v, 'Live Load'),
                    ),
                    const SizedBox(height: SbSpacing.lg),
                    SbInput(
                      controller: _plController,
                      label: 'Point Load (kN)',
                    ),
                  ],
                ),
              ),
            ),

            // ── LIMIT STATE SECTION ──
            SbSection(
              title: 'Limit State',
              child: SbCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.isULS ? 'ULS' : 'SLS',
                          style: Theme.of(context).textTheme.labelMedium!,
                        ),
                      ],
                    ),
                    SbSwitch(
                      value: state.isULS,
                      onChanged: (v) {
                        ref
                            .read(beamDesignControllerProvider.notifier)
                            .updateLoads(isULS: v);
                      },
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








