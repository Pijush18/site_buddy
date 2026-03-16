import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'dart:math';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/widgets/app_card.dart';
import 'package:site_buddy/features/design/application/controllers/column_design_controller.dart';
import 'package:site_buddy/features/design/application/services/column_insight_service.dart';
import 'package:site_buddy/features/design/presentation/widgets/engineering_diagrams/column_interaction_diagram.dart';
import 'package:site_buddy/features/design/presentation/widgets/engineering_diagrams/design_result_card.dart';
import 'package:site_buddy/features/design/presentation/widgets/structural_drawings/column_rebar_drawing.dart';
import 'package:site_buddy/core/services/drawing_export_service.dart';
import 'package:site_buddy/core/utils/widget_capture_helper.dart';
import 'package:site_buddy/core/utils/share_helper.dart';
import 'package:printing/printing.dart';
// import 'package:site_buddy/shared/widgets/action_buttons_group.dart';

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

    return SbPage.detail(
      title: 'Safety Check',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Step 6 of 6: Final Verification',
            style: SbTextStyles.title(context).copyWith(
              color: colorScheme.primary,
            ),
          ),
          AppLayout.vGap24,
          if (state.errorMessage != null) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: AppLayout.md),
              child: AppCard(
                color: colorScheme.error.withValues(alpha: 0.1),
                border: BorderSide(color: colorScheme.error, width: 1),
                child: Row(
                  children: [
                    Icon(SbIcons.error, color: colorScheme.error),
                    AppLayout.hGap16,
                    Expanded(
                      child: Text(
                        state.errorMessage!,
                        style: SbTextStyles.bodySecondary(context).copyWith(
                          color: colorScheme.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          Text('Interaction Visualization', style: SbTextStyles.title(context)),
          AppLayout.vGap8,
          ColumnInteractionDiagram(
            pu: state.pu,
            mu: max(state.mx, state.my),
            interactionRatio: state.interactionRatio,
          ),
          AppLayout.vGap24,
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
          AppLayout.vGap12,
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
          Text('Reinforcement Detail', style: SbTextStyles.title(context)),
          AppLayout.vGap12,
          AppCard(
            child: Column(
              children: [
                RepaintBoundary(
                  key: _drawingKey,
                  child: Container(
                    color: theme.cardColor,
                    padding: AppLayout.paddingLarge,
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
                AppLayout.vGap16,
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SbButton.ghost(
                        label: 'Save Image',
                        icon: SbIcons.image,
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
                      AppLayout.vGap8,
                      SbButton.ghost(
                        label: 'Save PDF',
                        icon: SbIcons.pdf,
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
          AppLayout.vGap24,
          Text(
            'Smart Engineering Insights',
            style: SbTextStyles.title(context),
          ),
          AppLayout.vGap12,
          ...ColumnInsightService.getSuggestions(state).map(
            (s) => Padding(
              padding: const EdgeInsets.only(bottom: AppLayout.sm),
              child: AppCard(
                color: colorScheme.primary.withValues(alpha: 0.05),
                child: Row(
                  children: [
                    Icon(
                      SbIcons.lightbulb,
                      color: colorScheme.primary,
                      size: 20,
                    ),
                    AppLayout.hGap16,
                    Expanded(child: Text(s, style: SbTextStyles.bodySecondary(context))),
                  ],
                ),
              ),
            ),
          ),
          AppLayout.vGap24,
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
              ),
              AppLayout.vGap12,
              SbButton.primary(
                label: 'Export PDF',
                icon: SbIcons.pdf,
                onPressed: () {
                  ref
                      .read(columnDesignControllerProvider.notifier)
                      .generateReport();
                },
              ),
              AppLayout.vGap12,
              SbButton.primary(
                label: 'Save History',
                onPressed: () {
                  ref
                      .read(columnDesignControllerProvider.notifier)
                      .saveToHistory('Column ${state.b}x${state.d}');
                  SbFeedback.showToast(
                    context: context,
                    message: 'Design Saved to History',
                  );
                },
              ),
              AppLayout.vGap12,
              SbButton.outline(
                label: 'Back',
                onPressed: () => context.pop(),
              ),
              AppLayout.vGap12,
              SbButton.primary(
                label: 'New Design',
                onPressed: () {
                  ref.read(columnDesignControllerProvider.notifier).reset();
                  context.go('/');
                },
              ),
            ],
          ),
          AppLayout.vGap24,
        ],
      ),
    );
  }
}
