import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/theme/app_font_sizes.dart';
import 'package:site_buddy/core/theme/app_radius.dart';
import 'package:site_buddy/core/widgets/app_screen_wrapper.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/features/design/application/controllers/beam_design_controller.dart';

import 'package:site_buddy/core/enums/safety_status.dart';
import 'package:site_buddy/core/utils/safety_utils.dart';
import 'package:site_buddy/core/widgets/app_card.dart';
import 'package:site_buddy/features/design/presentation/widgets/engineering_diagrams/design_result_card.dart';
import 'package:site_buddy/features/design/presentation/widgets/structural_drawings/beam_rebar_drawing.dart';
import 'package:site_buddy/core/services/drawing_export_service.dart';
import 'package:site_buddy/core/utils/widget_capture_helper.dart';
import 'package:site_buddy/core/utils/share_helper.dart';
import 'package:printing/printing.dart';

/// SCREEN: BeamSafetyCheckScreen
/// PURPOSE: Final safety status and report generation (Step 5).
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
    final state = ref.watch(beamDesignControllerProvider);

    // Derive overall status
    final overallStatus =
        (state.isFlexureSafe && state.isShearSafe && state.isDeflectionSafe)
        ? SafetyStatus.safe
        : SafetyStatus.fail;

    return AppScreenWrapper(
      title: 'Safety Verification',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Step 5 of 5: Engineering Validation',
            style: TextStyle(
              fontSize: AppFontSizes.tab,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.pLarge

          // Overall Safety Status Display
          _OverallStatusBadge(status: overallStatus),
          const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.pLarge

          DesignResultCard(
            title: 'Limit State of Flexure',
            isSafe: state.isFlexureSafe,
            items: [
              DesignResultItem(
                label: 'Design Moment (Mu)',
                value: '${state.mu.toStringAsFixed(2)} kNm',
              ),
              DesignResultItem(
                label: 'Neutral Axis Ratio',
                value: (state.xu / state.xuMax).toStringAsFixed(3),
                isCritical: true,
              ),
              DesignResultItem(
                label: 'Status',
                value: state.isFlexureSafe
                    ? 'Under-reinforced'
                    : 'Over-reinforced',
              ),
            ],
            codeReference: 'IS 456 Cl. 38.1',
          ),
          const SizedBox(height: AppSpacing.md), // Replaced AppLayout.pMedium

          DesignResultCard(
            title: 'Limit State of Shear',
            isSafe: state.isShearSafe,
            items: [
              DesignResultItem(
                label: 'Nominal Stress (τv)',
                value: '${state.tv.toStringAsFixed(2)} MPa',
              ),
              DesignResultItem(
                label: 'Stirrup Capacity',
                value: '${state.stirrupSpacing.toInt()} mm c/c',
                isCritical: true,
              ),
            ],
            codeReference: 'IS 456 Cl. 40.0',
          ),
          const SizedBox(height: AppSpacing.md), // Replaced AppLayout.pMedium

          DesignResultCard(
            title: 'Control of Deflection',
            isSafe: state.isDeflectionSafe,
            items: [
              DesignResultItem(
                label: 'L/d Ratio provided',
                value: (state.span / state.overallDepth).toStringAsFixed(2),
              ),
              DesignResultItem(
                label: 'Safety Status',
                value: state.isDeflectionSafe ? 'PERMISSIBLE' : 'EXCEEDS LIMIT',
                isCritical: true,
              ),
            ],
            codeReference: 'IS 456 Cl. 23.2.1',
          ),
          const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.pLarge

          // Reinforcement Detail
          const Text(
            'Reinforcement Cross-Section',
            style: TextStyle(
              fontSize: AppFontSizes.subtitle,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppSpacing.md), // Replaced AppLayout.pMedium
          AppCard(
            child: Column(
              children: [
                RepaintBoundary(
                  key: _drawingKey,
                  child: Container(
                    color: Theme.of(context).cardColor,
                    padding: const EdgeInsets.all(AppSpacing.md), // Replaced AppLayout.paddingMedium
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
                const SizedBox(height: AppSpacing.md), // Replaced AppLayout.pMedium
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
                              name: 'Beam_Reinforcement.png',
                              mimeType: 'image/png',
                            );
                          }
                        },
                      ),
                      const SizedBox(height: AppSpacing.sm), // Replaced AppLayout.vGap8
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
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.pHuge (closest standard)

          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SbButton.primary(
                label: 'Export PDF Report',
                icon: SbIcons.pdf,
                onPressed: () {
                  ref.read(beamDesignControllerProvider.notifier).generateReport();
                },
              ),
              const SizedBox(height: AppSpacing.sm), // Replaced AppLayout.vGap12
              SbButton.primary(
                label: 'Save to Design History',
                icon: SbIcons.history,
                onPressed: () => _saveDesign(context, ref),
              ),
              const SizedBox(height: AppSpacing.sm), // Replaced AppLayout.vGap12
              SbButton.outline(
                label: 'Back',
                onPressed: () => context.pop(),
              ),
              const SizedBox(height: AppSpacing.sm), // Replaced AppLayout.vGap12
              SbButton.primary(
                label: 'New Design',
                icon: SbIcons.add,
                onPressed: () {
                  ref.read(beamDesignControllerProvider.notifier).reset();
                  context.go('/');
                },
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.pLarge
        ],
      ),
    );
  }

  void _saveDesign(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    SbFeedback.showDialog(
      context: context,
      title: 'Save Design',
      content: SbInput(
        controller: nameController,
        hint: 'Enter Project/Beam Name',
        label: 'Design Name',
      ),
      confirmLabel: 'SAVE',
      onConfirm: () async {
        if (nameController.text.isNotEmpty) {
          await ref
              .read(beamDesignControllerProvider.notifier)
              .saveToHistory(nameController.text);
          if (context.mounted) {
            context.pop(); // Pop the feedback dialog
            SbFeedback.showToast(
              context: context,
              message: 'Design saved to history',
            );
          }
        }
      },
    );
  }
}

class _OverallStatusBadge extends StatelessWidget {
  final SafetyStatus status;

  const _OverallStatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = SafetyUtils.getColor(status);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md), // Replaced AppLayout.pMedium
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md), // Replaced AppLayout.paddingMedium
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(SafetyUtils.getIcon(status), color: color, size: 24),
          ),
          const SizedBox(width: AppSpacing.md), // Replaced AppLayout.hGap16
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  SafetyUtils.getLabel(status).toUpperCase(),
                  style: const TextStyle(
                    fontSize: AppFontSizes.subtitle,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  status == SafetyStatus.safe
                      ? 'Verified as per IS 456 code standards'
                      : 'Fails to meet safety requirements',
                  style: TextStyle(
                    fontSize: AppFontSizes.tab,
                    color: color.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}