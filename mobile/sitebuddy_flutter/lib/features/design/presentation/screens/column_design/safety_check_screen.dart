import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';

import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/localization/l10n_extension.dart';
import 'package:site_buddy/core/utils/widget_capture_helper.dart';
import 'package:site_buddy/core/utils/share_helper.dart';
import 'package:site_buddy/core/services/drawing_export_service.dart';

import 'package:site_buddy/features/design/application/controllers/column_design_controller.dart';
import 'package:site_buddy/features/design/application/services/column_insight_service.dart';
import 'package:site_buddy/features/design/presentation/widgets/engineering_diagrams/column_interaction_diagram.dart';
import 'package:site_buddy/features/design/presentation/widgets/engineering_diagrams/design_result_card.dart';
import 'package:site_buddy/features/design/presentation/widgets/structural_drawings/column_rebar_drawing.dart';
import 'package:site_buddy/features/design/application/controllers/column_safety_controller.dart';
import 'package:site_buddy/features/design/presentation/providers/design_providers.dart';
import 'package:site_buddy/features/design/presentation/widgets/optimization/optimization_list.dart';

/// SCREEN: SafetyCheckScreen
/// PURPOSE: Final summary and safety checks (Step 6).
class SafetyCheckScreen extends ConsumerStatefulWidget {
  const SafetyCheckScreen({super.key});

  @override
  ConsumerState<SafetyCheckScreen> createState() => _SafetyCheckScreenState();
}

class _SafetyCheckScreenState extends ConsumerState<SafetyCheckScreen> {
  final GlobalKey _drawingKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = ref.watch(columnDesignControllerProvider);
    final optimizationResult = ref.watch(columnOptimizationProvider);

    return SbPage.form(
      title: l10n.labelVerification,
      primaryAction: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PrimaryCTA(
            label: l10n.actionOptimize,
            onPressed: () {
              ref
                  .read(columnDesignControllerProvider.notifier)
                  .optimizeDesign();
            },
            icon: Icons.auto_awesome_outlined,
          ),
          const SizedBox(height: SbSpacing.sm),
          PrimaryCTA(
            label: l10n.actionExportPdf,
            icon: Icons.picture_as_pdf_outlined,
            onPressed: () async {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.msgGeneratingReport)),
              );
              try {
                await ref.read(columnDesignControllerProvider.notifier).generateReport();
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.msgErrorGeneratingReport(e.toString())), 
                      backgroundColor: colorScheme.error,
                    ),
                  );
                }
              }
            },
          ),
          const SizedBox(height: SbSpacing.sm),
          GhostButton(
            label: l10n.actionNewDesign,
            icon: Icons.add,
            onPressed: () {
              ref.read(columnDesignControllerProvider.notifier).reset();
              context.go('/');
            },
          ),
          const SizedBox(height: SbSpacing.sm),
          GhostButton(
            label: l10n.actionSaveImage,
            icon: Icons.image_outlined,
            onPressed: () async {
              final bytes = await WidgetCaptureHelper.capture(_drawingKey);
              if (bytes != null) {
                await ShareHelper.shareXFile(
                  bytes: bytes,
                  name: 'Column_Reinforcement.png',
                  mimeType: 'image/png',
                );
              }
            },
          ),
          const SizedBox(height: SbSpacing.sm),
          GhostButton(
            label: l10n.actionSaveDrawing,
            icon: Icons.picture_as_pdf_outlined,
            onPressed: () async {
              final bytes = await WidgetCaptureHelper.capture(_drawingKey);
              if (bytes != null) {
                final pdfBytes = await DrawingExportService.generateDrawingPdf(
                  bytes,
                  'Column Reinforcement',
                  '${state.type.label} Section: ${state.b.toInt()}x${state.d.toInt()} mm',
                );
                await Printing.sharePdf(
                  bytes: pdfBytes,
                  filename: 'Column_Reinforcement_Drawing.pdf',
                );
              }
            },
          ),
          const SizedBox(height: SbSpacing.sm),
          GhostButton(
            label: l10n.actionBack,
            onPressed: () => context.pop(),
          ),
        ],
      ),
      body: SbSectionList(
        sections: [
          // ── STEP HEADER ──
          SbSection(
            child: Text(
              l10n.labelStep6Validation,
              style: theme.textTheme.titleLarge!,
            ),
          ),

          // ── ERROR MESSAGE ──
          if (state.errorMessage != null)
            SbSection(
              child: SbCard(
                color: colorScheme.error.withValues(alpha: 0.1),
                padding: const EdgeInsets.all(SbSpacing.lg),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: colorScheme.error),
                    const SizedBox(width: SbSpacing.lg),
                    Expanded(
                      child: Text(
                        state.errorMessage!,
                        style: theme.textTheme.labelMedium!,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // ── INTERACTION VISUALIZATION ──
          SbSection(
            title: l10n.labelVisualization,
            child: ColumnInteractionDiagram(
              pu: state.pu,
              mu: max(state.mx, state.my),
              interactionRatio: state.interactionRatio,
            ),
          ),

          // ── CAPACITY VERIFICATION ──
          SbSection(
            title: l10n.labelCapacity,
            child: DesignResultCard(
              title: l10n.labelDemandVsCapacity,
              isSafe: state.isCapacitySafe,
              items: [
                DesignResultItem(
                  label: l10n.labelInteractionRatio,
                  value: state.interactionRatio.toStringAsFixed(2),
                  subtitle: l10n.labelDemandCapacity,
                  isCritical: true,
                ),
                DesignResultItem(
                  label: l10n.labelFailureMode,
                  value: state.failureMode.label,
                ),
              ],
              codeReference: 'IS 456 Cl. 39.6',
            ),
          ),

          // ── STABILITY & DETAILING ──
          SbSection(
            title: l10n.labelStability,
            child: DesignResultCard(
              title: l10n.labelVerification,
              isSafe: state.isSlendernessSafe && state.isReinforcementSafe,
              items: [
                DesignResultItem(
                    label: l10n.titleSlenderness,
                  value: max(
                    state.slendernessX,
                    state.slendernessY,
                  ).toStringAsFixed(2),
                  subtitle: state.isShort ? l10n.labelShortColumn : l10n.labelSlenderColumn,
                ),
                DesignResultItem(
                  label: l10n.labelSteelPercentage,
                  value: '${state.steelPercentage.toStringAsFixed(2)}%',
                  subtitle: l10n.labelSteelRange,
                ),
                if (!state.isShort)
                  DesignResultItem(
                    label: l10n.labelMagnifiedMoment,
                    value: state.magnifiedMx.toStringAsFixed(1),
                    unit: 'kNm',
                  ),
              ],
              codeReference: 'IS 456 Cl. 26.5.3',
            ),
          ),

          // ── REINFORCEMENT DETAIL ──
          SbSection(
            title: l10n.labelDrawing,
            child: SbCard(
              child: Column(
                children: [
                  RepaintBoundary(
                    key: _drawingKey,
                    child: Container(
                      color: theme.cardColor,
                      padding: const EdgeInsets.all(SbSpacing.xxl),
                      child: ColumnRebarDrawing(
                        width: state.b,
                        depth: state.d,
                        cover: state.cover.toDouble(),
                        numBars: state.numBars,
                        barDia: state.mainBarDia,
                        tieDia: state.tieDia,
                        tieSpacing: state.tieSpacing,
                        type: state.type,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── OPTIMIZATION ──
          if (optimizationResult.options.isNotEmpty)
            SbSection(
              title: l10n.labelOptimization,
              child: OptimizationList(
                options: optimizationResult.options,
                onOptionSelected: (opt) {
                  debugPrint('OPTION CLICKED: Select Option ($opt)');
                  ref.read(columnSafetyControllerProvider.notifier).selectOption(opt);
                  
                  final b = opt.parameters['b'] as double;
                  final d = opt.parameters['d'] as double;
                  ref.read(columnDesignControllerProvider.notifier).updateInput(
                    b: b,
                    d: d,
                  );
                },
              ),
            ),

          // ── SMART INSIGHTS ──
          SbSection(
            title: l10n.labelInsights,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: ColumnInsightService.getSuggestions(state, l10n)
                  .map(
                    (s) => Padding(
                      padding: const EdgeInsets.only(bottom: SbSpacing.sm),
                      child: SbCard(
                        color: colorScheme.primary.withValues(alpha: 0.05),
                        padding: const EdgeInsets.all(SbSpacing.lg),
                        child: Row(
                          children: [
                            Icon(
                              Icons.lightbulb_outline,
                              color: colorScheme.primary,
                              size: 20,
                            ),
                            const SizedBox(width: SbSpacing.lg),
                            Expanded(
                              child: Text(
                                s,
                                style: theme.textTheme.labelMedium!,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}








