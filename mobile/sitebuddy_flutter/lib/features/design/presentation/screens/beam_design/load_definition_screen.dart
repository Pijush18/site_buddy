import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/theme/app_font_sizes.dart';
import 'package:site_buddy/core/widgets/app_screen_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';

import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/core/widgets/app_number_field.dart';

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
    final theme = Theme.of(context);
    final state = ref.watch(beamDesignControllerProvider);
    final colorScheme = theme.colorScheme;

    return AppScreenWrapper(
      title: 'Load Definition',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Step 2 of 5: Applied Loads',
              style: TextStyle(
                fontSize: AppFontSizes.title,
                fontWeight: FontWeight.w600,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24

            // Loads Card
            SbCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Vertical Loads',
                    style: TextStyle(
                      fontSize: AppFontSizes.title,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md), // Replaced AppLayout.vGap16

                  AppNumberField(
                    controller: _dlController,
                    label: 'Dead Load (incl. Self-weight) (kN/m)',
                    validator: (v) =>
                        ValidationHelper.validatePositive(v, 'Dead Load'),
                  ),
                  const SizedBox(height: AppSpacing.md), // Replaced AppLayout.vGap16

                  AppNumberField(
                    controller: _llController,
                    label: 'Live Load (kN/m)',
                    validator: (v) =>
                        ValidationHelper.validatePositive(v, 'Live Load'),
                  ),
                  const SizedBox(height: AppSpacing.md), // Replaced AppLayout.vGap16

                  AppNumberField(
                    controller: _plController,
                    label: 'Point Load (Optional) (kN)',
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md), // Replaced AppLayout.vGap16

            // Load Factor Toggle Card
            SbCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Design Limit State',
                        style: TextStyle(
                          fontSize: AppFontSizes.title,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm), // Replaced AppLayout.vGap4
                      Text(
                        state.isULS ? 'ULS (Factor 1.5)' : 'SLS (Factor 1.0)',
                        style: TextStyle(
                          fontSize: AppFontSizes.tab,
                          color: colorScheme.onSurfaceVariant,
                        ),
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
            const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap32 (closest match)

            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SbButton.primary(
                  label: 'Calculate & View Analysis',
                  onPressed: _onNext,
                  icon: SbIcons.analytics,
                ),
                const SizedBox(height: AppSpacing.sm), // Replaced AppLayout.vGap12
                SbButton.outline(
                  label: 'Back',
                  onPressed: () => context.pop(),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24
          ],
        ),
      ),
    );
  }
}
