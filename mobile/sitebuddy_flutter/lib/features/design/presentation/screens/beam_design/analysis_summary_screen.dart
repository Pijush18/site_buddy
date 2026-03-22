import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/localization/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/theme/app_colors.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';

import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/navigation/app_routes.dart';

import 'package:site_buddy/features/design/application/controllers/beam_design_controller.dart';

import 'package:site_buddy/shared/domain/models/design/beam_design_state.dart';
import 'package:site_buddy/features/design/presentation/widgets/beam_diagram_painter.dart';
import 'package:site_buddy/features/design/presentation/widgets/engineering_diagrams/design_result_card.dart';

/// SCREEN: AnalysisSummaryScreen
/// PURPOSE: Displays analysis results with BMD and SFD (Step 3).
class AnalysisSummaryScreen extends ConsumerWidget {
  const AnalysisSummaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final state = ref.watch(beamDesignControllerProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SbPage.form(
      title: l10n.titleAnalysis,
      primaryAction: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PrimaryCTA(
            label: l10n.actionNext,
            icon: Icons.iron_rounded,
            onPressed: () {
              ref
                  .read(beamDesignControllerProvider.notifier)
                  .calculateReinforcement();
              context.push(AppRoutes.beamReinforcement);
            },
          ),
          const SizedBox(height: SbSpacing.md),
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
              l10n.labelStep3Analysis,
              style: Theme.of(context).textTheme.titleLarge!,
            ),
          ),

          // ── PRINCIPAL FORCES ──
          SbSection(
            title: l10n.labelPrincipalForces,
            child: DesignResultCard(
              title: l10n.labelULSForces,
              isSafe: true,
              items: [
                DesignResultItem(
                  label: l10n.labelMomentMu,
                  value: '${state.mu.toStringAsFixed(2)} kNm',
                  isCritical: true,
                ),
                DesignResultItem(
                  label: l10n.labelShearVu,
                  value: '${state.vu.toStringAsFixed(2)} kN',
                  isCritical: true,
                ),
                DesignResultItem(
                  label: l10n.labelTotalLoadWu,
                  value: '${state.wu.toStringAsFixed(2)} kN/m',
                ),
              ],
              codeReference: 'IS 456:2000 Cl. 38',
            ),
          ),

          // ── ENGINEERING DIAGRAMS ──
          SbSection(
            title: l10n.labelDiagrams,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _DiagramCard(
                  label: 'SFD (Shear)',
                  points: state.sfdPoints,
                  isBMD: false,
                  isDark: isDark,
                ),
                const SizedBox(height: SbSpacing.lg),
                _DiagramCard(
                  label: 'BMD (Moment)',
                  points: state.bmdPoints,
                  isBMD: true,
                  isDark: isDark,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DiagramCard extends StatelessWidget {
  final String label;
  final List<DiagramPoint> points;
  final bool isBMD;
  final bool isDark;

  const _DiagramCard({
    required this.label,
    required this.points,
    required this.isBMD,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SbCard(
      child: SizedBox(
        height: 140,
        child: CustomPaint(
          painter: BeamDiagramPainter(
            points: points,
            isBMD: isBMD,
            label: label,
            axisColor: isDark ? colorScheme.onSurface.withValues(alpha: 0.12) : colorScheme.outline,
            labelColor: colorScheme.onSurfaceVariant,
            labelStyle: Theme.of(context).textTheme.labelMedium!,
            primaryColor: colorScheme.primary,
            warningColor: AppColors.warning(context),
          ),
          size: Size.infinite,
        ),
      ),
    );
  }
}
