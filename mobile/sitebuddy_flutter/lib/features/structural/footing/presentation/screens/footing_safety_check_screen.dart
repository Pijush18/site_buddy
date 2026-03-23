import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:site_buddy/core/navigation/app_routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/localization/l10n_extension.dart';
import 'package:site_buddy/features/structural/footing/domain/footing_type.dart';
import 'package:site_buddy/features/structural/footing/application/footing_design_controller.dart';

import 'package:site_buddy/features/structural/footing/application/footing_safety_controller.dart';
import 'package:site_buddy/features/structural/shared/presentation/providers/design_providers.dart';
import 'package:site_buddy/features/structural/shared/presentation/widgets/optimization/optimization_list.dart';
import 'package:site_buddy/features/structural/shared/presentation/widgets/engineering_diagrams/design_result_card.dart';
import 'package:site_buddy/features/structural/shared/presentation/widgets/structural_drawings/footing_rebar_drawing.dart';
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
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = ref.watch(footingDesignControllerProvider);
    final optimizationResult = ref.watch(footingOptimizationProvider);
    final overallSafe = state.isBendingSafe &&
        state.isAreaSafe &&
        state.isOneWayShearSafe &&
        state.isPunchingShearSafe;

    return SbPage.form(
      title: l10n.titleSafetyChecks,
      primaryAction: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PrimaryCTA(
            label: l10n.actionCalculationSheet,
            icon: Icons.description_outlined,
            onPressed: () async {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.msgGeneratingReport)),
              );
              try {
                await ref
                    .read(footingDesignControllerProvider.notifier)
                    .generateReport();
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.errorGeneratingReport(e.toString())),
                      backgroundColor: Colors.red,
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
            onPressed: () => context.go(AppRoutes.home),
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
                  name: 'Footing_Reinforcement.png',
                  mimeType: 'image/png',
                );
              }
            },
          ),
          const SizedBox(height: SbSpacing.sm),
          GhostButton(
            label: l10n.actionSavePdf,
            icon: Icons.picture_as_pdf_outlined,
            onPressed: () async {
              final bytes = await WidgetCaptureHelper.capture(_drawingKey);
              if (bytes != null) {
                final pdfBytes = await DrawingExportService.generateDrawingPdf(
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
              l10n.labelDesignValidation,
              style: Theme.of(context).textTheme.titleLarge!,
            ),
          ),

          // ── OVERALL STATUS ──
          SbSection(
            child: SbCard(
              color: overallSafe
                  ? colorScheme.primaryContainer.withValues(alpha: 0.2)
                  : colorScheme.errorContainer.withValues(alpha: 0.2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    overallSafe
                        ? Icons.verified_user
                        : Icons.warning_amber_rounded,
                    color:
                        overallSafe ? colorScheme.primary : colorScheme.error,
                    size: 32,
                  ),
                  const SizedBox(width: SbSpacing.lg),
                  Text(
                    overallSafe ? l10n.labelDesignSafe : l10n.labelDesignUnsafe,
                    style: Theme.of(context).textTheme.titleLarge!,
                  ),
                ],
              ),
            ),
          ),

          // ── SOIL BEARING ──
          SbSection(
            title: l10n.labelSoilBearing,
            child: DesignResultCard(
              title: l10n.labelVerification,
              isSafe: state.isAreaSafe,
              items: [
                DesignResultItem(
                  label: l10n.labelMaxPressureQMax,
                  value: state.maxSoilPressure.toStringAsFixed(1),
                  unit: 'kN/m²',
                  isCritical: true,
                ),
                DesignResultItem(
                  label: l10n.labelAllowableSbc,
                  value: state.sbc.toStringAsFixed(0),
                  unit: 'kN/m²',
                ),
              ],
            ),
          ),

          // ── SHEAR VALIDATION ──
          SbSection(
            title: l10n.labelShearValidation,
            child: DesignResultCard(
              title: l10n.labelVerification,
              isSafe: state.isOneWayShearSafe && state.isPunchingShearSafe,
              items: [
                DesignResultItem(
                  label: l10n.labelOneWayShearTauV,
                  value: state.tauV.toStringAsFixed(2),
                  unit: 'N/mm²',
                  subtitle: l10n.msgLimitTauC(state.tauC.toStringAsFixed(2)),
                ),
                DesignResultItem(
                  label: l10n.labelPunchingShearVu,
                  value: state.vup.toStringAsFixed(1),
                  unit: 'kN',
                  subtitle:
                      l10n.msgEffectiveDepth(state.effDepth.toStringAsFixed(0)),
                  isCritical: true,
                ),
              ],
            ),
          ),

          if (state.type == FootingType.pile)
            SbSection(
              title: l10n.labelPileRequirements,
              child: DesignResultCard(
                title: l10n.labelPileCheck,
                isSafe: true,
                items: [
                  DesignResultItem(
                    label: l10n.labelNumberOfPiles,
                    value: state.pileCount.toString(),
                  ),
                ],
              ),
            ),

          // ── REINFORCEMENT DRAWING ──
          SbSection(
            title: l10n.labelReinforcementLayout,
            child: SbCard(
              child: Column(
                children: [
                  RepaintBoundary(
                    key: _drawingKey,
                    child: Container(
                      color: theme.cardColor,
                      padding: const EdgeInsets.all(SbSpacing.xxl),
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
                ],
              ),
            ),
          ),

          // ── SETTLEMENT WARNING ──
          if (state.isSettlementWarning)
            SbSection(
              child: SbCard(
                color: colorScheme.tertiaryContainer.withValues(alpha: 0.2),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: colorScheme.tertiary,
                      size: 20,
                    ),
                    const SizedBox(width: SbSpacing.lg),
                    Expanded(
                      child: Text(
                        l10n.msgSettlementWarning,
                        style: Theme.of(context).textTheme.labelMedium!,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // ── OPTIMIZATION ──
          if (optimizationResult.options.isNotEmpty)
            SbSection(
              title: l10n.labelEconomicalAlternatives,
              child: OptimizationList(
                options: optimizationResult.options,
                onOptionSelected: (opt) {
                  ref
                      .read(footingSafetyControllerProvider.notifier)
                      .selectOption(opt);

                  final length = opt.parameters['length'] as double;
                  final width = opt.parameters['width'] as double;
                  final thickness = opt.parameters['thickness'] as double;

                  ref
                      .read(footingDesignControllerProvider.notifier)
                      .updateGeometry(
                        length: length,
                        width: width,
                        thickness: thickness,
                      );
                },
              ),
            ),
        ],
      ),
    );
  }
}

