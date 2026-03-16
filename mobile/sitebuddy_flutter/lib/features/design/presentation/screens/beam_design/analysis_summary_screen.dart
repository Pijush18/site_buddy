import 'package:site_buddy/core/design_system/sb_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/features/design/application/controllers/beam_design_controller.dart';

import 'package:site_buddy/shared/domain/models/design/beam_design_state.dart';
// import 'package:site_buddy/shared/widgets/action_buttons_group.dart';
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

    return SbPage.detail(
      title: 'Analysis Summary',

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Step 3 of 5: Engineering Analysis',
            style: SbTextStyles.title(context).copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: AppLayout.sectionGap),

          // Design Result Card for Principal Forces
          DesignResultCard(
            title: 'Principal Design Forces',
            isSafe:
                true, // Analysis results are just facts, not safety checks yet
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
          const SizedBox(height: AppLayout.sectionGap),

          // Diagrams Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Engineering Diagrams',
                style: SbTextStyles.title(context),
              ),
              Text(
                'L = ${(state.span / 1000).toStringAsFixed(2)}m',
                style: SbTextStyles.caption(context).copyWith(color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: AppLayout.elementGap),

          _DiagramCard(
            label: 'Shear Force Diagram (SFD)',
            points: state.sfdPoints,
            isBMD: false,
            isDark: isDark,
          ),
          const SizedBox(height: AppLayout.elementGap),
          _DiagramCard(
            label: 'Bending Moment Diagram (BMD)',
            points: state.bmdPoints,
            isBMD: true,
            isDark: isDark,
          ),
          const SizedBox(height: AppLayout.sectionGap * 1.5),

          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SbButton.primary(
                label: 'Next: Reinforcement Design',
                icon: Icons.iron_rounded,
                onPressed: () {
                  ref
                      .read(beamDesignControllerProvider.notifier)
                      .calculateReinforcement();
                  context.push('/beam/rebar');
                },
              ),
              AppLayout.vGap12,
              SbButton.outline(
                label: 'Back',
                onPressed: () => context.pop(),
              ),
            ],
          ),
          const SizedBox(height: AppLayout.sectionGap),
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
    return Container(
      height: 180,
      padding: const EdgeInsets.all(AppLayout.cardPadding),
      decoration: AppLayout.sbCommonDecoration(context),
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
    );
  }
}
