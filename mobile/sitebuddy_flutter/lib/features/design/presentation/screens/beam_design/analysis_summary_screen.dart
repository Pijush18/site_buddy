import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/theme/app_font_sizes.dart';
import 'package:site_buddy/core/widgets/app_screen_wrapper.dart';
import 'package:site_buddy/core/widgets/components/sb_button.dart';
import 'package:site_buddy/core/widgets/components/sb_card.dart';
import 'package:site_buddy/core/widgets/components/sb_section_header.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    final state = ref.watch(beamDesignControllerProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return AppScreenWrapper(
      title: 'Analysis Summary',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Step 3 of 5: Engineering Analysis',
            style: TextStyle(
              fontSize: AppFontSizes.title,
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Design Result Card for Principal Forces
          DesignResultCard(
            title: 'Principal Design Forces',
            isSafe: true, 
            items: [
              DesignResultItem(
                label: 'Bending Moment (Mu)',
                value: '${state.mu.toStringAsFixed(2)} kNm',
                isCritical: true,
              ),
              DesignResultItem(
                label: 'Shear Force (Vu)',
                value: '${state.vu.toStringAsFixed(2)} kN',
                isCritical: true,
              ),
              DesignResultItem(
                label: 'ULS Load (wu)',
                value: '${state.wu.toStringAsFixed(2)} kN/m',
              ),
            ],
            codeReference: 'IS 456:2000 Cl. 38',
          ),
          const SizedBox(height: AppSpacing.md),

          // Diagrams Section
          SBSectionHeader(
            title: 'Engineering Diagrams',
            trailing: Text(
              'L = ${(state.span / 1000).toStringAsFixed(2)}m',
              style: const TextStyle(
                fontSize: AppFontSizes.tab,
                color: Colors.grey,
              ),
            ),
            bottomPadding: AppSpacing.sm,
          ),

          _DiagramCard(
            label: 'Shear Force Diagram (SFD)',
            points: state.sfdPoints,
            isBMD: false,
            isDark: isDark,
          ),
          const SizedBox(height: AppSpacing.md),
          _DiagramCard(
            label: 'Bending Moment Diagram (BMD)',
            points: state.bmdPoints,
            isBMD: true,
            isDark: isDark,
          ),
          const SizedBox(height: AppSpacing.lg),

          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SBButton.primary(
                label: 'Next: Reinforcement Design',
                icon: Icons.iron_rounded,
                onPressed: () {
                  ref
                      .read(beamDesignControllerProvider.notifier)
                      .calculateReinforcement();
                  context.push('/beam/rebar');
                },
                fullWidth: true,
              ),
              const SizedBox(height: AppSpacing.sm),
              SBButton.ghost(
                label: 'Back',
                onPressed: () => context.pop(),
                fullWidth: true,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
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
    return SBCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: SizedBox(
        height: 140,
        child: CustomPaint(
          painter: BeamDiagramPainter(
            points: points,
            isBMD: isBMD,
            label: label,
            axisColor: isDark ? Colors.white24 : Colors.black12,
            labelColor: isDark ? Colors.white70 : Colors.black54,
            textTheme: Theme.of(context).textTheme,
          ),
          size: Size.infinite,
        ),
      ),
    );
  }
}
