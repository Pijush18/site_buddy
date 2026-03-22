
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'dart:math';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/features/design/application/controllers/column_design_controller.dart';
import 'package:site_buddy/features/design/application/services/column_insight_service.dart';
import 'package:site_buddy/features/design/presentation/widgets/engineering_diagrams/column_interaction_diagram.dart';
import 'package:site_buddy/features/design/presentation/widgets/engineering_diagrams/design_result_card.dart';
import 'package:site_buddy/features/design/presentation/widgets/structural_drawings/column_rebar_drawing.dart';
import 'package:site_buddy/features/design/application/controllers/column_safety_controller.dart';
import 'package:site_buddy/features/design/presentation/providers/design_providers.dart';
import 'package:site_buddy/features/design/presentation/widgets/optimization/optimization_list.dart';
import 'package:site_buddy/core/services/drawing_export_service.dart';
import 'package:site_buddy/core/utils/widget_capture_helper.dart';
import 'package:site_buddy/core/utils/share_helper.dart';
import 'package:printing/printing.dart';

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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = ref.watch(columnDesignControllerProvider);
    final optimizationResult = ref.watch(columnOptimizationProvider);

    return SbPage.form(
      title: 'Verification',
      primaryAction: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PrimaryCTA(
            label: 'Optimize',
            onPressed: () {
              ref
                  .read(columnDesignControllerProvider.notifier)
                  .optimizeDesign();
            },
          ),
          const SizedBox(height: SbSpacing.sm),
          PrimaryCTA(
            label: 'Export PDF',
            icon: Icons.picture_as_pdf_outlined,
            onPressed: () async {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Generating PDF Report...')),
              );
              try {
                await ref.read(columnDesignControllerProvider.notifier).generateReport();
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error generating report: $e'), backgroundColor: Colors.red),
                  );
                }
              }
            },
          ),
          const SizedBox(height: SbSpacing.sm),
          GhostButton(
            label: 'New Design',
            icon: Icons.add,
            onPressed: () {
              ref.read(columnDesignControllerProvider.notifier).reset();
              context.go('/');
            },
          ),
          const SizedBox(height: SbSpacing.sm),
          GhostButton(
            label: 'Save Image',
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
            label: 'Save Drawing',
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
            label: 'Back',
            onPressed: () => context.pop(),
          ),
        ],
      ),
      body: SbSectionList(
        sections: [
          // ── STEP HEADER ──
          SbSection(
            child: Text(
              'Step 6: Validation',
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
            title: 'Visualization',
            child: ColumnInteractionDiagram(
              pu: state.pu,
              mu: max(state.mx, state.my),
              interactionRatio: state.interactionRatio,
            ),
          ),

          // ── CAPACITY VERIFICATION ──
          SbSection(
            title: 'Capacity',
            child: DesignResultCard(
              title: 'Demand vs Capacity',
              isSafe: state.isCapacitySafe,
              items: [
                DesignResultItem(
                  label: 'Interaction Ratio',
                  value: state.interactionRatio.toStringAsFixed(2),
                  subtitle: 'Demand / Capacity',
                  isCritical: true,
                ),
                DesignResultItem(
                  label: 'Failure Mode',
                  value: state.failureMode.label,
                ),
              ],
              codeReference: 'IS 456 Cl. 39.6',
            ),
          ),

          // ── STABILITY & DETAILING ──
          SbSection(
            title: 'Stability',
            child: DesignResultCard(
              title: 'Verification',
              isSafe: state.isSlendernessSafe && state.isReinforcementSafe,
              items: [
                DesignResultItem(
                    label: 'Slenderness',
                  value: max(
                    state.slendernessX,
                    state.slendernessY,
                  ).toStringAsFixed(2),
                  subtitle: state.isShort ? 'Short Column' : 'Slender Column',
                ),
                DesignResultItem(
                  label: 'Steel Percentage',
                  value: '${state.steelPercentage.toStringAsFixed(2)}%',
                  subtitle: 'Range: 0.8% - 6.0%',
                ),
                if (!state.isShort)
                  DesignResultItem(
                    label: 'Magnified Moment',
                    value: state.magnifiedMx.toStringAsFixed(1),
                    unit: 'kNm',
                  ),
              ],
              codeReference: 'IS 456 Cl. 26.5.3',
            ),
          ),

          // ── REINFORCEMENT DETAIL ──
          SbSection(
            title: 'Drawing',
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
              title: 'Optimization',
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
            title: 'Insights',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: ColumnInsightService.getSuggestions(state)
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








