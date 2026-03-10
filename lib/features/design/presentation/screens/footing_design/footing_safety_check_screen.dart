import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/core/widgets/main_navigation_wrapper.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/shared/domain/models/design/footing_type.dart';
import 'package:site_buddy/features/design/application/controllers/footing_design_controller.dart';

import 'package:site_buddy/features/design/presentation/widgets/engineering_diagrams/design_result_card.dart';
import 'package:site_buddy/features/design/presentation/widgets/structural_drawings/footing_rebar_drawing.dart';
import 'package:site_buddy/core/services/drawing_export_service.dart';
import 'package:site_buddy/core/utils/widget_capture_helper.dart';
import 'package:site_buddy/core/utils/share_helper.dart';
import 'package:printing/printing.dart';

/// SCREEN: FootingSafetyCheckScreen
/// PURPOSE: Final dashboard for all engineering safety checks (Step 6).
class FootingSafetyCheckScreen extends ConsumerStatefulWidget {
  const FootingSafetyCheckScreen({super.key});

  @override
  ConsumerState<FootingSafetyCheckScreen> createState() =>
      _FootingSafetyCheckScreenState();
}

class _FootingSafetyCheckScreenState
    extends ConsumerState<FootingSafetyCheckScreen> {
  final GlobalKey _drawingKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = ref.watch(footingDesignControllerProvider);
    final overallSafe =
        state.isBendingSafe &&
        state.isAreaSafe &&
        state.isOneWayShearSafe &&
        state.isPunchingShearSafe;

    return MainNavigationWrapper(
      child: SbPage.detail(
        title: 'Safety Checks',
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Step 6 of 6: Design Validation',
              style: SbTextStyles.caption(context).copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            AppLayout.vGap16,

            // Overall Status Card
            SbCard(
              color: overallSafe
                  ? colorScheme.primaryContainer.withValues(alpha: 0.2)
                  : colorScheme.errorContainer,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    overallSafe ? SbIcons.verified : SbIcons.warning,
                    color: overallSafe ? colorScheme.primary : colorScheme.error,
                    size: 32,
                  ),
                  AppLayout.hGap16,
                  Text(
                    overallSafe ? 'DESIGN IS SAFE' : 'DESIGN UNSAFE',
                    style: SbTextStyles.title(context).copyWith(
                      color: overallSafe ? colorScheme.primary : colorScheme.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            AppLayout.vGap16,

            // Soil Bearing Pressure
            DesignResultCard(
              title: 'Soil Bearing',
              isSafe: state.isAreaSafe,
              items: [
                DesignResultItem(
                  label: 'Max Pressure (q_max)',
                  value: state.maxSoilPressure.toStringAsFixed(1),
                  unit: 'kN/m²',
                  isCritical: true,
                ),
                DesignResultItem(
                  label: 'Allowable SBC',
                  value: state.sbc.toStringAsFixed(0),
                  unit: 'kN/m²',
                ),
              ],
            ),
            AppLayout.vGap16,

            // Shear Checks
            DesignResultCard(
              title: 'Shear Validation',
              isSafe: state.isOneWayShearSafe && state.isPunchingShearSafe,
              items: [
                DesignResultItem(
                  label: 'One-Way Shear (τv)',
                  value: state.tauV.toStringAsFixed(2),
                  unit: 'N/mm²',
                  subtitle: 'Limit τc: ${state.tauC.toStringAsFixed(2)} N/mm²',
                ),
                DesignResultItem(
                  label: 'Punching Shear (Vu)',
                  value: state.vup.toStringAsFixed(1),
                  unit: 'kN',
                  subtitle:
                      'Effective Depth: ${state.effDepth.toStringAsFixed(0)} mm',
                  isCritical: true,
                ),
              ],
            ),

            if (state.type == FootingType.pile) ...[
              AppLayout.vGap16,
              DesignResultCard(
                title: 'Pile Requirements',
                isSafe: true,
                items: [
                  DesignResultItem(
                    label: 'Number of Piles',
                    value: state.pileCount.toString(),
                  ),
                ],
              ),
            ],

            AppLayout.vGap32,
            // Reinforcement Detail
            Text('Reinforcement Layout', style: SbTextStyles.title(context)),
            AppLayout.vGap16,
            SbCard(
              child: Column(
                children: [
                  RepaintBoundary(
                    key: _drawingKey,
                    child: Container(
                      color: Theme.of(context).cardColor,
                      padding: const EdgeInsets.all(AppLayout.lg),
                      child: FootingRebarDrawing(
                        length: state.footingLength,
                        width: state.footingWidth,
                        thickness: state.footingThickness,
                        colA: state.colA,
                        colB: state.colB,
                        barDia: state.mainBarDia,
                        spacing: state.mainBarSpacing,
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
                        onPressed: () async {
                          final bytes = await WidgetCaptureHelper.capture(
                            _drawingKey,
                          );
                          if (bytes != null) {
                            await ShareHelper.shareXFile(
                              bytes: bytes,
                              name: 'Footing_Reinforcement.png',
                              mimeType: 'image/png',
                            );
                          }
                        },
                      ),
                      AppLayout.hGap8,
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
                                  'Footing Reinforcement',
                                  'Layout: ${state.footingLength.toInt()}x${state.footingWidth.toInt()} mm',
                                );
                            await Printing.sharePdf(
                              bytes: pdfBytes,
                              filename: 'Footing_Reinforcement_Drawing.pdf',
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            if (state.isSettlementWarning) ...[
              AppLayout.vGap16,
              SbCard(
                color: colorScheme.tertiaryContainer.withValues(alpha: 0.2),
                child: Row(
                  children: [
                    Icon(
                      SbIcons.info,
                      color: colorScheme.tertiary,
                      size: 20,
                    ),
                    AppLayout.hGap16,
                    Expanded(
                      child: Text(
                        'Warning: Low SBC detected. Consider detailed settlement analysis.',
                        style: SbTextStyles.body(context).copyWith(
                          color: colorScheme.onTertiaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            AppLayout.vGap32,

            Row(
              children: [
                Expanded(
                  child: SbButton.primary(
                    label: 'Calculation Sheet',
                    icon: SbIcons.description,
                    onPressed: () {
                      ref
                          .read(footingDesignControllerProvider.notifier)
                          .generateReport();
                    },
                  ),
                ),
                AppLayout.hGap16,
                Expanded(
                  child: SbButton.primary(
                    label: 'Save Design',
                    icon: SbIcons.download,
                    onPressed: () {
                      context.go('/design');
                    },
                  ),
                ),
              ],
            ),

            AppLayout.vGap24,
          ],
        ),
      ),
    );
  }
}
