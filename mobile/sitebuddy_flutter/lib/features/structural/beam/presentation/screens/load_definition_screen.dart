import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/localization/l10n_extension.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';

import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



import 'package:site_buddy/core/utils/validation_helper.dart';
import 'package:site_buddy/features/structural/beam/application/beam_design_controller.dart';
import 'package:site_buddy/features/structural/beam/domain/beam_validator.dart';

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
    final l10n = context.l10n;
    final state = ref.watch(beamDesignControllerProvider);

    return SbPage.form(
      title: l10n.titleLoads,
      primaryAction: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PrimaryCTA(
            label: l10n.actionCalculate,
            onPressed: _onNext,
            icon: SbIcons.analytics,
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
              title: l10n.labelVerticalLoads,
              child: SbCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SbInput(
                      controller: _dlController,
                      label: l10n.labelDeadLoad,
                      validator: (v) =>
                          ValidationHelper.validatePositive(v, l10n.labelDeadLoad),
                    ),
                    const SizedBox(height: SbSpacing.md),
                    SbInput(
                      controller: _llController,
                      label: l10n.labelLiveLoad,
                      validator: (v) =>
                          ValidationHelper.validatePositive(v, l10n.labelLiveLoad),
                    ),
                    const SizedBox(height: SbSpacing.md),
                    SbInput(
                      controller: _plController,
                      label: l10n.labelPointLoad,
                    ),
                  ],
                ),
              ),
            ),

            // ── LIMIT STATE SECTION ──
            SbSection(
              title: l10n.labelLimitState,
              child: SbCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.isULS ? l10n.labelULS : l10n.labelSLS,
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









