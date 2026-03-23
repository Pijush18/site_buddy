import 'package:site_buddy/core/design_system/sb_icons.dart';

import 'package:site_buddy/core/design_system/sb_radius.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/theme/app_colors.dart';
import 'package:site_buddy/core/theme/app_border.dart';



import 'package:site_buddy/core/localization/l10n_extension.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';

import 'package:site_buddy/core/constants/engineering_terms.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:site_buddy/features/structural/beam/application/beam_design_controller.dart';

import 'package:site_buddy/core/enums/safety_status.dart';
import 'package:site_buddy/core/utils/safety_utils.dart';
import 'package:site_buddy/features/structural/shared/presentation/widgets/engineering_diagrams/design_result_card.dart';
import 'package:site_buddy/features/structural/shared/presentation/widgets/structural_drawings/beam_rebar_drawing.dart';
import 'package:site_buddy/features/structural/beam/application/beam_safety_controller.dart';
import 'package:site_buddy/features/structural/shared/presentation/providers/design_providers.dart';
import 'package:site_buddy/features/structural/shared/presentation/widgets/optimization/optimization_list.dart';
import 'package:site_buddy/core/services/drawing_export_service.dart';
import 'package:site_buddy/core/utils/widget_capture_helper.dart';
import 'package:site_buddy/core/utils/share_helper.dart';
import 'package:printing/printing.dart';

/// SCREEN: BeamSafetyCheckScreen
/// PURPOSE: Final safety status and report generation (Step 5).
/// 
/// IS 456:2000 Safety Checks:
/// - Flexural capacity check (Clause 38.1)
/// - Shear capacity check (Clause 40.0)
/// - Deflection check (Clause 23.2.1)
class BeamSafetyCheckScreen extends ConsumerStatefulWidget {
  const BeamSafetyCheckScreen({super.key});

  @override
  ConsumerState<BeamSafetyCheckScreen> createState() =>
      _BeamSafetyCheckScreenState();
}

class _BeamSafetyCheckScreenState extends ConsumerState<BeamSafetyCheckScreen> {
  final GlobalKey _drawingKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = ref.watch(beamDesignControllerProvider);
    final optimizationResult = ref.watch(beamOptimizationProvider);
    final colorScheme = Theme.of(context).colorScheme;

    // Derive overall status
    final overallStatus =
        (state.isFlexureSafe && state.isShearSafe && state.isDeflectionSafe)
        ? SafetyStatus.safe
        : SafetyStatus.fail;

    return SbPage.form(
      title: l10n.titleBeamSafety,
      primaryAction: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PrimaryCTA(
            label: l10n.actionExportPdf,
            icon: SbIcons.pdf,
            onPressed: () async {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Generating PDF Report...')),
              );
              try {
                await ref.read(beamDesignControllerProvider.notifier).generateReport();
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error generating report: $e'), backgroundColor: Colors.red),
                  );
                }
              }
            },
          ),
          const SizedBox(height: AppSpacing.md),
          GhostButton(
            label: l10n.actionNewDesign,
            icon: SbIcons.add,
            onPressed: () {
              ref.read(beamDesignControllerProvider.notifier).reset();
              context.go('/');
            },
          ),
          const SizedBox(height: AppSpacing.md),
          GhostButton(
            label: l10n.actionSaveImage,
            icon: SbIcons.image,
            onPressed: () async {
              final bytes = await WidgetCaptureHelper.capture(_drawingKey);
              if (bytes != null) {
                await ShareHelper.shareXFile(
                  bytes: bytes,
                  name: 'Beam_Reinforcement.png',
                  mimeType: 'image/png',
                );
              }
            },
          ),
          const SizedBox(height: AppSpacing.md),
          GhostButton(
            label: l10n.actionSaveDrawing,
            icon: SbIcons.pdf,
            onPressed: () async {
              final bytes = await WidgetCaptureHelper.capture(_drawingKey);
              if (bytes != null) {
                final pdfBytes = await DrawingExportService.generateDrawingPdf(
                  bytes,
                  'Beam Reinforcement',
                  'Section: ${state.width.toInt()}x${state.overallDepth.toInt()} mm',
                );
                await Printing.sharePdf(
                  bytes: pdfBytes,
                  filename: 'Beam_Reinforcement_Drawing.pdf',
                );
              }
            },
          ),
          const SizedBox(height: AppSpacing.md),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.labelStep5Safety,
                  style: Theme.of(context).textTheme.titleLarge!,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'IS 456:2000 Safety Verification',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),

          // ── OVERALL STATUS ──
          SbSection(
            child: _OverallStatusBadge(status: overallStatus),
          ),

          // ── CHECK SUMMARY ──
          SbSection(
            title: 'Safety Checks Summary',
            child: SbCard(
              child: Column(
                children: [
                  _CheckRow(
                    label: l10n.labelFlexure,
                    isSafe: state.isFlexureSafe,
                    detail: 'xu/xu,max = ${(state.xu / state.xuMax).toStringAsFixed(3)}',
                  ),
                  const Divider(height: 1),
                  _CheckRow(
                    label: l10n.labelShear,
                    isSafe: state.isShearSafe,
                    detail: 'τv = ${state.tv.toStringAsFixed(2)} MPa',
                  ),
                  const Divider(height: 1),
                  _CheckRow(
                    label: l10n.labelDeflection,
                    isSafe: state.isDeflectionSafe,
                    detail: 'L/d = ${(state.span / state.overallDepth).toStringAsFixed(2)}',
                  ),
                ],
              ),
            ),
          ),

          // ── FLEXURE CHECK ──
          SbSection(
            title: l10n.labelFlexure,
            child: DesignResultCard(
              title: l10n.labelVerification,
              isSafe: state.isFlexureSafe,
              items: [
                DesignResultItem(
                  label: l10n.labelMomentMu,
                  value: '${state.mu.toStringAsFixed(2)} kNm',
                ),
                DesignResultItem(
                  label: 'xu / xu,max',
                  value: '${state.xu.toInt()} / ${state.xuMax.toInt()} mm',
                  isCritical: true,
                ),
                DesignResultItem(
                  label: 'Ast Provided',
                  value: '${state.astProvided.toInt()} mm²',
                ),
                DesignResultItem(
                  label: 'Status',
                  value: state.isFlexureSafe
                      ? 'Under-reinforced ✓'
                      : 'Over-reinforced ✗',
                  isCritical: true,
                ),
              ],
              codeReference: 'IS 456 Cl. 38.1',
            ),
          ),

          // ── SHEAR CHECK ──
          SbSection(
            title: l10n.labelShear,
            child: DesignResultCard(
              title: l10n.labelVerification,
              isSafe: state.isShearSafe,
              items: [
                DesignResultItem(
                  label: 'Shear Force (Vu)',
                  value: '${state.vu.toStringAsFixed(1)} kN',
                ),
                DesignResultItem(
                  label: 'τv (Nominal)',
                  value: '${state.tv.toStringAsFixed(2)} N/mm²',
                ),
                DesignResultItem(
                  label: 'Stirrup Spacing',
                  value: '${state.stirrupSpacing.toInt()} mm c/c',
                  isCritical: true,
                ),
              ],
              codeReference: 'IS 456 Cl. 40.0',
            ),
          ),

          // ── DEFLECTION CHECK ──
          SbSection(
            title: l10n.labelDeflection,
            child: DesignResultCard(
              title: l10n.labelVerification,
              isSafe: state.isDeflectionSafe,
              items: [
                DesignResultItem(
                  label: 'L/d Ratio',
                  value: (state.span / state.overallDepth).toStringAsFixed(2),
                ),
                DesignResultItem(
                  label: 'Steel %',
                  value: '${((state.astProvided * 100) / (state.b * state.d)).toStringAsFixed(2)}%',
                ),
                DesignResultItem(
                  label: 'Status',
                  value:
                      state.isDeflectionSafe ? 'PASS ✓' : 'FAIL ✗',
                  isCritical: true,
                ),
              ],
              codeReference: 'IS 456 Cl. 23.2.1',
            ),
          ),

          // ── REINFORCEMENT DRAWING ──
          SbSection(
            title: EngineeringTerms.reinforcementDetailing,
            child: SbCard(
              child: Column(
                children: [
                  // Drawing caption
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.straighten,
                          size: 16,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          '${state.width.toInt()} × ${state.overallDepth.toInt()} mm',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  RepaintBoundary(
                    key: _drawingKey,
                    child: Container(
                      color: colorScheme.surfaceContainerHighest,
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: BeamRebarDrawing(
                        width: state.width,
                        depth: state.overallDepth,
                        cover: state.cover.toDouble(),
                        mainBars: state.numBars,
                        mainBarDia: state.mainBarDia,
                        stirrupLegs: state.stirrupLegs,
                        stirrupDia: state.stirrupDia,
                        stirrupSpacing: state.stirrupSpacing,
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
                  ref.read(beamSafetyControllerProvider.notifier).selectOption(opt);
                  
                  final width = opt.parameters['width'] as double;
                  final depth = opt.parameters['depth'] as double;
                  ref.read(beamDesignControllerProvider.notifier).updateInputs(
                    width: width,
                    depth: depth,
                  );
                  ref.read(beamDesignControllerProvider.notifier).calculateAnalysis();
                  ref.read(beamDesignControllerProvider.notifier).calculateReinforcement();
                },
              ),
            ),
        ],
      ),
    );
  }

}

class _OverallStatusBadge extends StatelessWidget {
  final SafetyStatus status;

  const _OverallStatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = SafetyUtils.getColor(context, status);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: SbRadius.borderMd,
        border: Border.all(
          color: context.colors.outline,
          width: AppBorder.width,
        ),


      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(SafetyUtils.getIcon(status), color: color, size: 24),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  SafetyUtils.getLabel(status).toUpperCase(),
                  style: Theme.of(context).textTheme.titleMedium!,
                ),
                Text(
                  status == SafetyStatus.safe
                      ? 'IS 456:2000 Verified'
                      : 'Requirements Failed',
                  style: Theme.of(context).textTheme.labelMedium!,
                ),
              ],
            ),
          ),
          // Status icon
          Icon(
            status == SafetyStatus.safe 
                ? Icons.verified 
                : Icons.warning,
            color: color,
            size: 32,
          ),
        ],
      ),
    );
  }
}

class _CheckRow extends StatelessWidget {
  final String label;
  final bool isSafe;
  final String detail;

  const _CheckRow({
    required this.label,
    required this.isSafe,
    required this.detail,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSafe ? Colors.green : Colors.red;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isSafe ? Icons.check : Icons.close,
              color: color,
              size: 16,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  detail,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              isSafe ? 'PASS' : 'FAIL',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}








