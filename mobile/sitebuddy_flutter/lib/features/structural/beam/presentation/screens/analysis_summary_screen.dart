import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/localization/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/theme/app_colors.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';

import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/navigation/app_routes.dart';

import 'package:site_buddy/features/structural/beam/application/beam_design_controller.dart';

import 'package:site_buddy/features/structural/beam/domain/beam_design_state.dart';
import 'package:site_buddy/features/structural/shared/presentation/widgets/beam_diagram_painter.dart';
import 'package:site_buddy/features/structural/shared/presentation/widgets/engineering_diagrams/design_result_card.dart';

/// SCREEN: AnalysisSummaryScreen
/// PURPOSE: Displays analysis results with BMD and SFD (Step 3).
/// 
/// IS 456:2000 Requirements:
/// - Maximum moment calculation for design (Clause 38)
/// - Shear force envelope for shear reinforcement design (Clause 40)
class AnalysisSummaryScreen extends ConsumerWidget {
  const AnalysisSummaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final state = ref.watch(beamDesignControllerProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

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
                  l10n.labelStep3Analysis,
                  style: Theme.of(context).textTheme.titleLarge!,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'IS 456:2000 Clause 38',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
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
                // SFD Card
                _DiagramCard(
                  label: 'SFD (Shear Force Diagram)',
                  subtitle: 'Maximum shear at supports',
                  points: state.sfdPoints,
                  isBMD: false,
                  isDark: isDark,
                ),
                const SizedBox(height: AppSpacing.lg),
                // BMD Card
                _DiagramCard(
                  label: 'BMD (Bending Moment Diagram)',
                  subtitle: 'Maximum moment at midspan',
                  points: state.bmdPoints,
                  isBMD: true,
                  isDark: isDark,
                ),
              ],
            ),
          ),

          // ── KEY INSIGHTS ──
          SbSection(
            title: 'Design Insights',
            child: SbCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InsightRow(
                    icon: Icons.architecture,
                    label: 'Span',
                    value: '${(state.span / 1000).toStringAsFixed(2)} m',
                    color: colorScheme.primary,
                  ),
                  const Divider(height: AppSpacing.lg),
                  _InsightRow(
                    icon: Icons.straighten,
                    label: 'L/d Ratio',
                    value: (state.span / state.overallDepth).toStringAsFixed(2),
                    color: _getLdRatioColor(state.span / state.overallDepth),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _buildCodeHint(
                    context,
                    'ℹ️ L/d ≤ 20 for simply supported (IS 456 Cl. 23.2.1)',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Get color for L/d ratio indicator
  Color _getLdRatioColor(double ldRatio) {
    if (ldRatio <= 20) return Colors.green;
    if (ldRatio <= 26) return Colors.orange;
    return Colors.red;
  }

  /// Build a small hint text styled as a code reference
  Widget _buildCodeHint(BuildContext context, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontFamily: 'monospace',
        ),
      ),
    );
  }
}

class _DiagramCard extends StatelessWidget {
  final String label;
  final String subtitle;
  final List<DiagramPoint> points;
  final bool isBMD;
  final bool isDark;

  const _DiagramCard({
    required this.label,
    required this.subtitle,
    required this.points,
    required this.isBMD,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SbDiagramCard(
      title: label,
      subtitle: subtitle,
      footer: _buildTypeBadge(context, colorScheme),
      showDivider: true,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
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
            primaryColor: isBMD ? colorScheme.primary : colorScheme.tertiary,
            warningColor: AppColors.warning(context),
          ),
          size: Size.infinite,
        ),
      ),
    );
  }

  Widget _buildTypeBadge(BuildContext context, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: (isBMD ? colorScheme.primary : colorScheme.tertiary)
            .withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        isBMD ? 'M' : 'V',
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: isBMD ? colorScheme.primary : colorScheme.tertiary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _InsightRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InsightRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

