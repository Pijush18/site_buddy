import 'package:site_buddy/core/design_system/sb_icons.dart';

import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';

import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



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
      primaryAction: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SbButton.primary(
            label: 'Next: Load Definition',
            onPressed: _onNext,
            icon: SbIcons.arrowForward,
          ),
          const SizedBox(height: SbSpacing.sm),
          SbButton.ghost(
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
                'Step 1 of 5: Geometry & Materials',
                style: Theme.of(context).textTheme.titleLarge!,
              ),
            ),

            // ── GEOMETRY SECTION ──
            SbSection(
              title: 'Geometry',
              child: SbCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Beam Type',
                      style: Theme.of(context).textTheme.labelLarge!,
                    ),
                    const SizedBox(height: SbSpacing.sm),
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
                    const SizedBox(height: SbSpacing.lg),
                    SbInput(
                      controller: _spanController,
                      label: 'Clear Span (L) (mm)',
                      validator: (v) =>
                          ValidationHelper.validatePositive(v, 'Span'),
                    ),
                    const SizedBox(height: SbSpacing.lg),
                    Row(
                      children: [
                        Expanded(
                          child: SbInput(
                            controller: _widthController,
                            label: 'Width (b) (mm)',
                            validator: (v) =>
                                ValidationHelper.validatePositive(v, 'Width'),
                          ),
                        ),
                        const SizedBox(width: SbSpacing.lg),
                        Expanded(
                          child: SbInput(
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
            ),

            // ── MATERIALS SECTION ──
            SbSection(
              title: 'Materials',
              child: SbCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
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
                        const SizedBox(width: SbSpacing.lg),
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
                    const SizedBox(height: SbSpacing.lg),
                    SbInput(
                      controller: _coverController,
                      label: 'Clear Cover (mm)',
                      validator: (v) =>
                          ValidationHelper.validatePositive(v, 'Cover'),
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

  Widget _buildGradeDropdown(
    String label,
    String value,
    List<String> items,
    Function(String) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge!,
        ),
        const SizedBox(height: SbSpacing.sm), // Replaced const SizedBox(height: SbSpacing.sm)
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








