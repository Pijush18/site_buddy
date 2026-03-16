import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/theme/app_font_sizes.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/core/widgets/app_screen_wrapper.dart';
import 'package:site_buddy/core/widgets/components/sb_button.dart';
import 'package:site_buddy/core/widgets/components/sb_card.dart';
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

    return AppScreenWrapper(
      title: 'Safety Checks',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Step 6 of 6: Design Validation',
            style: TextStyle(
              fontSize: AppFontSizes.tab,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.md), // Replaced AppLayout.vGap16

          // Overall Status Card
          SBCard(
            backgroundColor: overallSafe
                ? colorScheme.primaryContainer.withValues(alpha: 0.2)
                : colorScheme.errorContainer.withValues(alpha: 0.2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  overallSafe ? Icons.verified_user : Icons.warning_amber_rounded,
                  color: overallSafe ? colorScheme.primary : colorScheme.error,
                  size: 32,
                ),
                const SizedBox(width: AppSpacing.md), // Replaced AppLayout.hGap16
                Text(
                  overallSafe ? 'DESIGN IS SAFE' : 'DESIGN UNSAFE',
                  style: TextStyle(
                    fontSize: AppFontSizes.title,
                    fontWeight: FontWeight.w600,
                    color: overallSafe ? colorScheme.primary : colorScheme.error,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.md), // Replaced AppLayout.vGap16

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
          const SizedBox(height: AppSpacing.md), // Replaced AppLayout.vGap16

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
            const SizedBox(height: AppSpacing.md), // Replaced AppLayout.vGap16
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

          const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap32
          // Reinforcement Detail
          const Text(
            'Reinforcement Layout',
            style: TextStyle(
              fontSize: AppFontSizes.title,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SBCard(
            child: Column(
              children: [
                RepaintBoundary(
                  key: _drawingKey,
                  child: Container(
                    color: theme.cardColor,
                    padding: const EdgeInsets.all(AppSpacing.lg),
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
                const SizedBox(height: AppSpacing.md), // Replaced AppLayout.vGap16
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SBButton.ghost(
                        label: 'Save Image',
                        icon: Icons.image_outlined,
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
                      const SizedBox(height: AppSpacing.sm),
                      SBButton.ghost(
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
                ),
              ],
            ),
          ),

          if (state.isSettlementWarning) ...[
            const SizedBox(height: AppSpacing.md),
            SBCard(
              backgroundColor: colorScheme.tertiaryContainer.withValues(alpha: 0.2),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: colorScheme.tertiary,
                    size: 20,
                  ),
                  const SizedBox(width: AppSpacing.md), // Replaced AppLayout.hGap16
                  Expanded(
                    child: Text(
                      'Warning: Low SBC detected. Consider detailed settlement analysis.',
                      style: TextStyle(
                        fontSize: AppFontSizes.subtitle,
                        color: colorScheme.onTertiaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap32

          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SBButton.primary(
                label: 'Calculation Sheet',
                icon: Icons.description_outlined,
                onPressed: () {
                  ref
                      .read(footingDesignControllerProvider.notifier)
                      .generateReport();
                },
                fullWidth: true,
              ),
              const SizedBox(height: AppSpacing.sm),
              SBButton.primary(
                label: 'Save Design',
                icon: Icons.save_outlined,
                onPressed: () {
                  context.go('/design');
                },
                fullWidth: true,
              ),
              const SizedBox(height: AppSpacing.sm),
              SBButton.secondary(
                label: 'Back',
                onPressed: () => context.pop(),
                fullWidth: true,
              ),
              const SizedBox(height: AppSpacing.sm),
              SBButton.primary(
                label: 'New Design',
                icon: Icons.add,
                onPressed: () {
                  context.go('/');
                },
                fullWidth: true,
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24
        ],
      ),
    );
  }
}
