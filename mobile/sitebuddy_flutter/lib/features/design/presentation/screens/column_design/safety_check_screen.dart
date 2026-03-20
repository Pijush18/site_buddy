
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

    return AppScreenWrapper(
      title: 'Safety Check',
      isScrollable: false,
      usePadding: false,
      child: ListView(
        padding: const EdgeInsets.all(SbSpacing.lg),
        children: [
          Text(
            'Step 6 of 6: Final Verification',
            style: Theme.of(context).textTheme.titleLarge!,
          ),
          const SizedBox(height: SbSpacing.xxl),
          if (state.errorMessage != null) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: SbSpacing.lg),
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
                        style: Theme.of(context).textTheme.labelMedium!,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SbSectionHeader(title: 'Interaction Visualization'),
          const SizedBox(height: SbSpacing.sm),
          ColumnInteractionDiagram(
            pu: state.pu,
            mu: max(state.mx, state.my),
            interactionRatio: state.interactionRatio,
          ),
          const SizedBox(height: SbSpacing.xxl),
          DesignResultCard(
            title: 'Capacity Verification',
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
          const SizedBox(height: SbSpacing.sm),
          DesignResultCard(
            title: 'Stability & Detailing',
            isSafe: state.isSlendernessSafe && state.isReinforcementSafe,
            items: [
              DesignResultItem(
                label: 'Slenderness (λmax)',
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
          const SbSectionHeader(title: 'Reinforcement Detail'),
          const SizedBox(height: SbSpacing.sm),
          SbCard(
            padding: const EdgeInsets.all(SbSpacing.lg),
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
                const SizedBox(height: SbSpacing.lg),
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SbButton.ghost(
                        label: 'Save Image',
                        icon: Icons.image_outlined,
                        onPressed: () async {
                          final bytes = await WidgetCaptureHelper.capture(
                            _drawingKey,
                          );
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
                      SbButton.ghost(
                        label: 'Save PDF',
                        icon: Icons.picture_as_pdf_outlined,
                        onPressed: () async {
                          final bytes = await WidgetCaptureHelper.capture(
                            _drawingKey,
                          );
                          if (bytes != null) {
                            final pdfBytes =
                                await DrawingExportService.generateDrawingPdf(
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
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: SbSpacing.xxl),
          const SbSectionHeader(title: 'Smart Engineering Insights'),
          const SizedBox(height: SbSpacing.sm),
          ...ColumnInsightService.getSuggestions(state).map(
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
                        style: Theme.of(context).textTheme.labelMedium!,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: SbSpacing.xxl),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SbButton.primary(
                label: 'Optimize Section',
                onPressed: () {
                  ref
                      .read(columnDesignControllerProvider.notifier)
                      .optimizeDesign();
                },
                width: double.infinity,
              ),
              const SizedBox(height: SbSpacing.sm),
              SbButton.primary(
                label: 'Export PDF Report',
                icon: Icons.picture_as_pdf_outlined,
                onPressed: () {
                  ref
                      .read(columnDesignControllerProvider.notifier)
                      .generateReport();
                },
                width: double.infinity,
              ),
              const SizedBox(height: SbSpacing.sm),
              SbButton.primary(
                label: 'Save to History',
                icon: Icons.history,
                onPressed: () {
                  ref
                      .read(columnDesignControllerProvider.notifier)
                      .saveToHistory('Column ${state.b}x${state.d}');
                  SbFeedback.showToast(
                    context: context,
                    message: 'Design Saved to History',
                  );
                },
                width: double.infinity,
              ),
              const SizedBox(height: SbSpacing.sm),
              SbButton.secondary(
                label: 'Back',
                onPressed: () => context.pop(),
                width: double.infinity,
              ),
              const SizedBox(height: SbSpacing.sm),
              SbButton.primary(
                label: 'New Design',
                icon: Icons.add,
                onPressed: () {
                  ref.read(columnDesignControllerProvider.notifier).reset();
                  context.go('/');
                },
                width: double.infinity,
              ),
            ],
          ),
        ],
      ),
    );
  }
}








