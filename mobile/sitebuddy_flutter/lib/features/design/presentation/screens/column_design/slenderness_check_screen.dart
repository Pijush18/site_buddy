
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/features/design/application/controllers/column_design_controller.dart';
import 'package:site_buddy/shared/domain/models/design/column_enums.dart';
import 'package:site_buddy/features/design/presentation/widgets/engineering_diagrams/slenderness_diagram.dart';
import 'package:site_buddy/features/design/presentation/widgets/engineering_diagrams/design_result_card.dart';

/// SCREEN: SlendernessCheckScreen
/// PURPOSE: Slenderness classification (Step 3).
class SlendernessCheckScreen extends ConsumerWidget {
  const SlendernessCheckScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(columnDesignControllerProvider);

    return SbPage.form(
      title: 'Slenderness Check',
      primaryAction: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SbButton.primary(
            label: 'Next: Design Calculation',
            onPressed: () {
              context.push('/column/design');
            },
          ),
          SizedBox(height: SbSpacing.sm),
          SbButton.ghost(
            label: 'Back',
            onPressed: () => context.pop(),
          ),
        ],
      ),
      body: SbSectionList(
        sections: [
          // ── STEP HEADER ──
          SbSection(
            child: Text(
              'Step 3 of 6: Slenderness Check',
              style: Theme.of(context).textTheme.titleLarge!,
            ),
          ),

          // ── CLASSIFICATION SECTION ──
          SbSection(
            title: 'Column Classification',
            child: DesignResultCard(
              title: 'Verification',
              isSafe: state.isShort,
              items: [
                DesignResultItem(
                  label: 'Status',
                  value: state.isShort ? 'SHORT' : 'SLENDER',
                  isCritical: true,
                ),
                DesignResultItem(
                  label: 'Classification Rule',
                  value: state.isShort ? 'λ < 12' : 'λ ≥ 12',
                  subtitle: 'Based on IS 456 Cl 39.7.1',
                ),
              ],
            ),
          ),

          // ── VISUALIZATION SECTION ──
          SbSection(
            title: 'Geometric Visualization',
            child: SlendernessDiagram(
              slendernessX: state.slendernessX,
              slendernessY: state.slendernessY,
              lex: state.lex,
              ley: state.ley,
              b: state.b,
              d: state.d,
              isCircular: state.type == ColumnType.circular,
            ),
          ),

          // ── PARAMETERS SECTION ──
          SbSection(
            title: 'Effective Length',
            child: DesignResultCard(
              title: 'Parameters',
              isSafe: true,
              items: [
                DesignResultItem(
                  label: 'lex (Major Axis)',
                  value: state.lex.toInt().toString(),
                  unit: 'mm',
                ),
                DesignResultItem(
                  label: 'ley (Minor Axis)',
                  value: state.ley.toInt().toString(),
                  unit: 'mm',
                ),
                DesignResultItem(
                  label: 'Unsupported Length (L)',
                  value: state.length.toInt().toString(),
                  unit: 'mm',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}











