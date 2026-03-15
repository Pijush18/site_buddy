import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';

import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/core/widgets/app_number_field.dart';

import 'package:site_buddy/core/utils/validation_helper.dart';
import 'package:site_buddy/shared/domain/models/design/beam_type.dart';
import 'package:site_buddy/features/design/application/controllers/beam_design_controller.dart';
import 'package:site_buddy/features/design/application/services/beam_validator.dart';
import 'package:site_buddy/shared/domain/models/prefill_data.dart';

/// SCREEN: BeamInputScreen
/// PURPOSE: Initial parameters for Beam Design (Step 1).
class BeamInputScreen extends ConsumerStatefulWidget {
  const BeamInputScreen({super.key});

  @override
  ConsumerState<BeamInputScreen> createState() => _BeamInputScreenState();
}

class _BeamInputScreenState extends ConsumerState<BeamInputScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _spanController;
  late final TextEditingController _widthController;
  late final TextEditingController _depthController;
  late final TextEditingController _coverController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(beamDesignControllerProvider);
    _spanController = TextEditingController(
      text: state.span > 0 ? state.span.toString() : '',
    );
    _widthController = TextEditingController(
      text: state.width > 0 ? state.width.toString() : '',
    );
    _depthController = TextEditingController(
      text: state.overallDepth > 0 ? state.overallDepth.toString() : '',
    );
    _coverController = TextEditingController(text: state.cover.toString());
  }

  @override
  void dispose() {
    _spanController.dispose();
    _widthController.dispose();
    _depthController.dispose();
    _coverController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (!_formKey.currentState!.validate()) return;

    final span = double.parse(_spanController.text);
    final width = double.parse(_widthController.text);
    final depth = double.parse(_depthController.text);

    final error = BeamValidator.validateGeometry(
      span: span,
      width: width,
      depth: depth,
    );

    if (error != null) {
      SbFeedback.showToast(context: context, message: error);
      return;
    }

    ref
        .read(beamDesignControllerProvider.notifier)
        .updateInputs(
          span: span,
          width: width,
          depth: depth,
          cover: double.parse(_coverController.text),
        );

    // Trigger analysis before navigating
    ref.read(beamDesignControllerProvider.notifier).calculateAnalysis();

    context.push('/beam/load');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = ref.watch(beamDesignControllerProvider);
    final notifier = ref.read(beamDesignControllerProvider.notifier);

    // Prefill logic
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;
      final extra = GoRouterState.of(context).extra;
      if (extra is BeamDesignPrefillData) {
        notifier.initializeWithPrefill(extra);
        // Sync controllers with prefilled state if they were empty
        if (_spanController.text.isEmpty && extra.length != null) {
          _spanController.text = (extra.length! * 1000).toString();
        }
        if (_widthController.text.isEmpty && extra.width != null) {
          _widthController.text = (extra.width! * 1000).toString();
        }
        if (_depthController.text.isEmpty && extra.depth != null) {
          _depthController.text = (extra.depth! * 1000).toString();
        }
      }
    });

    return SbPage.form(
      title: 'Beam Input',
      primaryAction: SbButton.primary(
        label: 'Next: Load Definition',
        onPressed: _onNext,
        icon: SbIcons.arrowForward,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Step 1 of 5: Geometry & Materials',
              style: SbTextStyles.title(context).copyWith(
                color: colorScheme.primary,
              ),
            ),
            AppLayout.vGap24,

            // Geometry Card
            SbCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Geometry', style: SbTextStyles.title(context)),
                  AppLayout.vGap16,

                  Text('Beam Type', style: SbTextStyles.button(context)),
                  AppLayout.vGap8,
                  SbDropdown<BeamType>(
                    value: state.type,
                    items: BeamType.values,
                    itemLabelBuilder: (t) => t.label,
                    onChanged: (v) {
                      if (v != null) {
                        notifier.updateInputs(type: v);
                      }
                    },
                  ),
                  AppLayout.vGap16,

                  AppNumberField(
                    controller: _spanController,
                    label: 'Clear Span (L) (mm)',
                    validator: (v) =>
                        ValidationHelper.validatePositive(v, 'Span'),
                  ),
                  AppLayout.vGap16,

                  Row(
                    children: [
                      Expanded(
                        child: AppNumberField(
                          controller: _widthController,
                          label: 'Width (b) (mm)',
                          validator: (v) =>
                              ValidationHelper.validatePositive(v, 'Width'),
                        ),
                      ),
                      AppLayout.hGap16,
                      Expanded(
                        child: AppNumberField(
                          controller: _depthController,
                          label: 'Total Depth (D) (mm)',
                          validator: (v) =>
                              ValidationHelper.validatePositive(v, 'Depth'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            AppLayout.vGap16,

            // Materials Card
            SbCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Materials', style: SbTextStyles.title(context)),
                  AppLayout.vGap16,

                  Row(
                    children: [
                      Expanded(
                        child: _buildGradeDropdown(
                          'Concrete Grade',
                          state.concreteGrade,
                          ['M20', 'M25', 'M30', 'M35', 'M40'],
                          (v) => ref
                              .read(beamDesignControllerProvider.notifier)
                              .updateInputs(concrete: v),
                        ),
                      ),
                      AppLayout.hGap16,
                      Expanded(
                        child: _buildGradeDropdown(
                          'Steel Grade',
                          state.steelGrade,
                          ['Fe415', 'Fe500'],
                          (v) => ref
                              .read(beamDesignControllerProvider.notifier)
                              .updateInputs(steel: v),
                        ),
                      ),
                    ],
                  ),
                  AppLayout.vGap16,

                  AppNumberField(
                    controller: _coverController,
                    label: 'Clear Cover (mm)',
                    validator: (v) =>
                        ValidationHelper.validatePositive(v, 'Cover'),
                  ),
                ],
              ),
            ),
            AppLayout.vGap24,
          ],
        ),
      ),
    );
  }

  Widget _buildGradeDropdown(
    String label,
    String value,
    List<String> items,
    Function(String) onChanged,
  ) {
//     final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: SbTextStyles.button(context)),
        AppLayout.vGap8,
        SbDropdown<String>(
          value: value,
          items: items,
          itemLabelBuilder: (s) => s,
          onChanged: (v) => v != null ? onChanged(v) : null,
        ),
      ],
    );
  }
}