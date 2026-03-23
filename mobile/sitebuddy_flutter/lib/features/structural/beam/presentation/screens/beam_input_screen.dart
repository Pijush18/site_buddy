import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/localization/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/navigation/app_routes.dart';

import 'package:site_buddy/core/utils/validation_helper.dart';
import 'package:site_buddy/features/structural/beam/domain/beam_type.dart';
import 'package:site_buddy/features/structural/beam/application/beam_design_controller.dart';
import 'package:site_buddy/features/structural/beam/domain/beam_validator.dart';
import 'package:site_buddy/core/models/prefill_data.dart';

/// SCREEN: BeamInputScreen
/// PURPOSE: Initial parameters for Beam Design (Step 1).
/// 
/// IS 456:2000 Requirements:
/// - Minimum beam width: 200mm (Clause 5.5.1)
/// - Maximum span/depth ratio for deflection control
/// - Clear cover typically 25-40mm depending on exposure
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

  /// IS 456 minimum beam width in mm
  static const double _minBeamWidth = 200.0;
  
  /// IS 456 recommended minimum beam depth based on span (L/d = 20 for simply supported)
  double get _recommendedMinDepth {
    final span = double.tryParse(_spanController.text) ?? 0;
    return span > 0 ? span / 20 : 300;
  }

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

    // Additional IS 456 validation
    if (width < _minBeamWidth) {
      SbFeedback.showToast(
        context: context,
        message: 'Beam width should be ≥ ${_minBeamWidth.toInt()} mm per IS 456 Cl. 5.5.1',
        isError: true,
      );
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

    context.push(AppRoutes.beamLoad);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
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
      title: l10n.titleBeamInput,
      primaryAction: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PrimaryCTA(
            label: l10n.actionNext,
            onPressed: _onNext,
            icon: SbIcons.arrowForward,
          ),
          const SizedBox(height: AppSpacing.md),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.labelStep1Geometry,
                    style: Theme.of(context).textTheme.titleLarge!,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'IS 456:2000 Clause 5.5.1',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),

            // ── BEAM TYPE SECTION ──
            SbSection(
              title: l10n.labelType,
              child: SbCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
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
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      _getBeamTypeDescription(state.type),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── GEOMETRY SECTION ──
            SbSection(
              title: l10n.labelGeometry,
              child: SbCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Span input with unit hint
                    Semantics(
                      label: '${l10n.labelSpanL} in millimeters',
                      hint: 'Enter beam span in millimeters',
                      child: SbInput(
                        controller: _spanController,
                        label: l10n.labelSpanL,
                        hint: 'e.g., 5000 mm',
                        validator: (v) =>
                            ValidationHelper.validatePositive(v, l10n.labelLength),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    // Width and Depth in a row
                    Row(
                      children: [
                        Expanded(
                          child: Semantics(
                            label: '${l10n.labelWidthB} in millimeters, minimum ${_minBeamWidth.toInt()} mm',
                            hint: 'Enter beam width, minimum ${_minBeamWidth.toInt()} mm per IS 456',
                            child: SbInput(
                              controller: _widthController,
                              label: l10n.labelWidthB,
                              hint: '≥ ${_minBeamWidth.toInt()} mm',
                              validator: (v) =>
                                  ValidationHelper.validatePositive(v, l10n.labelWidth),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.lg),
                        Expanded(
                          child: Semantics(
                            label: '${l10n.labelDepthD} in millimeters',
                            hint: 'Enter overall beam depth',
                            child: SbInput(
                              controller: _depthController,
                              label: l10n.labelDepthD,
                              hint: 'e.g., 450 mm',
                              validator: (v) =>
                                  ValidationHelper.validatePositive(v, l10n.labelDepth),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    // IS 456 hint
                    _buildCodeHint(
                      context,
                      'ℹ️ L/d ratio should be ≤ 20 for simply supported beams (IS 456 Cl. 23.2.1)',
                    ),
                  ],
                ),
              ),
            ),

            // ── MATERIALS SECTION ──
            SbSection(
              title: l10n.labelMaterials,
              child: SbCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildGradeDropdown(
                            l10n.labelConcreteGrade,
                            state.concreteGrade,
                            ['M20', 'M25', 'M30', 'M35', 'M40'],
                            (v) => ref
                                .read(beamDesignControllerProvider.notifier)
                                .updateInputs(concrete: v),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.lg),
                        Expanded(
                          child: _buildGradeDropdown(
                            l10n.labelSteelGrade,
                            state.steelGrade,
                            ['Fe415', 'Fe500'],
                            (v) => ref
                                .read(beamDesignControllerProvider.notifier)
                                .updateInputs(steel: v),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Semantics(
                      label: '${l10n.labelCover} in millimeters',
                      hint: 'Enter concrete cover in millimeters, typically 25-40mm',
                      child: SbInput(
                        controller: _coverController,
                        label: l10n.labelCover,
                        hint: '25-40 mm',
                        validator: (v) =>
                            ValidationHelper.validatePositive(v, l10n.labelCover),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _buildCodeHint(
                      context,
                      'ℹ️ Cover depends on exposure condition (IS 456 Table 16)',
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

  /// Helper to get beam type description for accessibility
  String _getBeamTypeDescription(BeamType type) {
    switch (type) {
      case BeamType.simplySupported:
        return 'Simply supported beam - ends rest freely on supports';
      case BeamType.cantilever:
        return 'Cantilever beam - fixed at one end, free at other';
      case BeamType.continuous:
        return 'Continuous beam - extends over multiple supports';
    }
  }

  /// Build a small hint text styled as a code reference
  Widget _buildCodeHint(BuildContext context, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontFamily: 'monospace',
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
        const SizedBox(height: AppSpacing.sm),
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

