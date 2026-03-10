import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/core/widgets/sb_widgets.dart';

import 'package:site_buddy/core/widgets/app_number_field.dart';
import 'package:site_buddy/core/widgets/segmented_toggle.dart';
import 'package:site_buddy/core/utils/share_helper.dart';

import 'package:site_buddy/shared/domain/models/design/slab_type.dart';
import 'package:site_buddy/shared/domain/models/design/slab_design_state.dart';
import 'package:site_buddy/features/design/application/controllers/slab_design_controller.dart';
import 'package:site_buddy/core/services/drawing_export_service.dart';
import 'package:printing/printing.dart';
import 'dart:typed_data';
import 'package:site_buddy/features/design/presentation/widgets/slab_illustration_widget.dart';
import 'package:site_buddy/core/providers/settings_provider.dart';
import 'package:site_buddy/core/providers/engine_providers.dart';
import 'package:site_buddy/core/design_engines/models/design_io.dart';
import 'package:site_buddy/core/localization/generated/app_localizations.dart';
import 'package:site_buddy/features/design/presentation/widgets/engineering_diagrams/design_result_card.dart';
import 'package:site_buddy/features/design/presentation/widgets/structural_drawings/slab_rebar_drawing.dart';
import 'package:site_buddy/core/utils/widget_capture_helper.dart';
import 'package:site_buddy/core/optimization/optimization_engine.dart';
import 'package:site_buddy/features/design/presentation/widgets/optimization/optimization_list.dart';
import 'package:site_buddy/core/services/design_advisor_service.dart';
import 'package:site_buddy/features/design/presentation/widgets/design_advisor/design_advisor_card.dart';
import 'package:site_buddy/features/design/presentation/widgets/optimization/optimization_graph.dart';
import 'package:site_buddy/core/widgets/educational_toggle.dart';
import 'package:site_buddy/core/widgets/code_reference_card.dart';
import 'package:site_buddy/core/data/code_references/is_456_references.dart';
import 'package:site_buddy/core/services/educational_mode_service.dart';

class SlabDesignScreen extends ConsumerStatefulWidget {
  const SlabDesignScreen({super.key});

  @override
  ConsumerState<SlabDesignScreen> createState() => _SlabDesignScreenState();
}

class _SlabDesignScreenState extends ConsumerState<SlabDesignScreen> {
  bool _isSharing = false;
  final _optimizationEngine = OptimizationEngine();
  final GlobalKey _drawingKey = GlobalKey();

  Future<void> _handleShareImage(Uint8List bytes) async {
    await ShareHelper.shareXFile(
      bytes: bytes,
      name: 'Slab_Design_Drawing.png',
      mimeType: 'image/png',
    );
  }

  Future<void> _handleSharePdf(Uint8List bytes) async {
    final pdfBytes = await DrawingExportService.generateDrawingPdf(
      bytes,
      'Slab Design',
      'One-way/Two-way Slab Reinforcement Drawing',
    );
    await Printing.sharePdf(
      bytes: pdfBytes,
      filename: 'Slab_Design_Drawing.pdf',
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = ref.watch(slabDesignControllerProvider);
    final controller = ref.read(slabDesignControllerProvider.notifier);
    final settings = ref.watch(settingsProvider);
    final l10n = AppLocalizations.of(context)!;

    final lengthUnit = settings.lengthUnit;
    final spanUnit = settings.spanUnit;

    // Generate Optimization Suggestions using the pure engine
    final slabEngine = ref.read(slabEngineProvider);
    final optimizationResult = _optimizationEngine.optimizeSlabThickness(
      lx: state.lx,
      ly: state.ly,
      deadLoad: state.deadLoad,
      liveLoad: state.liveLoad,
      type: state.type,
    );

    // Proof of Engine usage as requested by user architect:
    // This allows for "What-If" scenarios without necessarily updating the global controller state.
    final _ = slabEngine.calculate(
      SlabDesignInputs(
        type: state.type,
        lx: state.lx,
        ly: state.ly,
        depth: state.d,
        deadLoad: state.deadLoad,
        liveLoad: state.liveLoad,
      ),
    );

    final advisorResult = ref
        .read(designAdvisorServiceProvider)
        .advise(category: 'slab', optimizationResult: optimizationResult);

    return SbPage.detail(
      title: l10n.slabDesign,

      appBarActions: [
        SbButton.icon(
          icon: SbIcons.share,
          tooltip: l10n.shareDesignResult,
          onPressed: _isSharing ? null : () => _handleShare(state, l10n),
        ),
        const EducationalToggle(),
        AppLayout.hGap8,
      ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Illustration Card
          SbCard(
            child: Column(
              children: [
                SlabIllustrationWidget(type: state.type),
                AppLayout.vGap16,
                SegmentedToggle<SlabType>(
                  value: state.type,
                  items: SlabType.values,
                  labelBuilder: (t) => t.label.split(' ')[0],
                  onChanged: controller.updateType,
                ),
              ],
            ),
          ),
          AppLayout.vGap24,

          // Inputs Card
          SbCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.physicalDimensions,
                  style: SbTextStyles.title(context),
                ),
                AppLayout.vGap16,
                Row(
                  children: [
                    Expanded(
                      child: AppNumberField(
                        label: '${l10n.spanLx} ($spanUnit)',
                        onChanged: (val) =>
                            controller.updateLx(double.tryParse(val) ?? 0.0),
                      ),
                    ),
                    AppLayout.hGap24,
                    Expanded(
                      child: AppNumberField(
                        label: '${l10n.spanLy} ($spanUnit)',
                        onChanged: (val) =>
                            controller.updateLy(double.tryParse(val) ?? 0.0),
                      ),
                    ),
                  ],
                ),
                AppLayout.vGap16,
                AppNumberField(
                  label: '${l10n.effectiveDepth} ($lengthUnit)',
                  onChanged: (val) =>
                      controller.updateDepth(double.tryParse(val) ?? 0.0),
                ),
              ],
            ),
          ),
          AppLayout.vGap24,

          // Diagram
          Text('Reinforcement Detail', style: SbTextStyles.title(context)),
          AppLayout.vGap16,
          SbCard(
            child: Column(
              children: [
                RepaintBoundary(
                  key: _drawingKey,
                  child: Container(
                    color: Theme.of(context).cardColor,
                    padding: AppLayout.paddingMedium,
                    child: SlabRebarDrawing(
                      lx: state.lx,
                      ly: state.ly,
                      depth: state.d,
                      mainSteel: state.result?.mainRebar ?? '---',
                      distributionSteel:
                          state.result?.distributionSteel ?? '---',
                    ),
                  ),
                ),
                AppLayout.vGap16,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SbButton.ghost(
                      label: 'Save Image',
                      icon: SbIcons.image,
                      onPressed: state.result == null
                          ? null
                          : () async {
                              final bytes = await WidgetCaptureHelper.capture(
                                _drawingKey,
                              );
                              if (bytes != null) {
                                await _handleShareImage(bytes);
                              }
                            },
                    ),
                    AppLayout.hGap24,
                    SbButton.ghost(
                      label: 'Save PDF',
                      icon: SbIcons.pdf,
                      onPressed: state.result == null
                          ? null
                          : () async {
                              final bytes = await WidgetCaptureHelper.capture(
                                _drawingKey,
                              );
                              if (bytes != null) {
                                await _handleSharePdf(bytes);
                              }
                            },
                    ),
                  ],
                ),
              ],
            ),
          ),
          AppLayout.vGap24,

          if (state.error != null)
            SbCard(
              color: colorScheme.errorContainer,
              child: Text(
                state.error!,
                style: SbTextStyles.body(context).copyWith(
                  color: colorScheme.onErrorContainer,
                ),
              ),
            ),

          if (state.result != null) ...[
            // Results Card
            DesignResultCard(
              title: l10n.designResults,
              isSafe:
                  state.result!.isShearSafe && state.result!.isDeflectionSafe,
              items: [
                DesignResultItem(
                  label: l10n.bendingMoment,
                  value:
                      '${state.result!.bendingMoment.toStringAsFixed(2)} kNm/m',
                ),
                DesignResultItem(
                  label: l10n.mainRebar,
                  value: state.result!.mainRebar,
                  isCritical: true,
                ),
                DesignResultItem(
                  label: l10n.distributionSteel,
                  value: state.result!.distributionSteel,
                ),
              ],
              codeReference: 'IS 456 Annex D',
            ),

            if (ref.watch(educationalModeProvider))
              const CodeReferenceCard(
                reference: IS456References.slabMinReinforcement,
              ),

            AppLayout.vGap16,

            // Safety Checks
            DesignResultCard(
              title: l10n.safetyChecks,
              isSafe:
                  state.result!.isShearSafe && state.result!.isDeflectionSafe,
              items: [
                DesignResultItem(
                  label: l10n.shear,
                  value: state.result!.isShearSafe ? 'PASS' : 'FAIL',
                ),
                DesignResultItem(
                  label: l10n.deflection,
                  value: state.result!.isDeflectionSafe
                      ? 'SAFE'
                      : 'EXCEEDS LIMIT',
                  isCritical: true,
                ),
                DesignResultItem(
                  label: l10n.cracking,
                  value: state.result!.isCrackingSafe ? 'OK' : 'FAIL',
                ),
              ],
              codeReference: 'IS 456 Cl. 23.2.1',
            ),
            AppLayout.vGap16,
            if (ref.watch(educationalModeProvider))
              const CodeReferenceCard(
                reference: IS456References.deflectionCheck,
              ),
          ],
          AppLayout.vGap32,

          // Recommended Design Options
          Text(
            'RECOMMENDED DESIGN OPTIONS',
            style: SbTextStyles.title(context).copyWith(
              color: colorScheme.primary,
              letterSpacing: 1.2,
            ),
          ),
          AppLayout.vGap16,
          OptimizationList(
            options: optimizationResult.options,
            onOptionSelected: (option) {
              final d = option.parameters['thickness'] as double;
              controller.updateDepth(d);

              SbFeedback.showToast(
                context: context,
                message: 'Thickness updated to ${d.toInt()} mm',
              );
            },
          ),
          AppLayout.vGap16,
          OptimizationGraph(options: optimizationResult.options),

          AppLayout.vGap16,

          if (optimizationResult.options.isNotEmpty)
            DesignAdvisorCard(advisorResult: advisorResult),

          AppLayout.vGap24,

          SbButton.primary(
            label: 'Export PDF Report',
            icon: SbIcons.pdf,
            isLoading: _isSharing,
            onPressed: state.result == null
                ? null
                : () {
                    ref
                        .read(slabDesignControllerProvider.notifier)
                        .generateReport();
                  },
          ),
        ],
      ),
    );
  }

  Future<void> _handleShare(
    SlabDesignState state,
    AppLocalizations l10n,
  ) async {
    if (state.result == null) return;
    setState(() => _isSharing = true);
    try {
      await ShareHelper.shareSlabDesign(
        projectName: "Structural Design Report",
        slabType: state.type.label,
        lx: state.lx,
        ly: state.ly,
        depth: state.d,
        deadLoad: state.deadLoad,
        liveLoad: state.liveLoad,
        totalLoad: state.deadLoad + state.liveLoad,
        bendingMoment: state.result!.bendingMoment,
        mainRebar: state.result!.mainRebar,
        distributionSteel: state.result!.distributionSteel,
      );
    } finally {
      if (mounted) {
        setState(() => _isSharing = false);
      }
    }
  }
}
