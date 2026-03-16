import 'package:site_buddy/core/design_system/sb_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/features/design/application/controllers/column_design_controller.dart';
import 'package:site_buddy/shared/domain/models/design/column_enums.dart';
import 'package:site_buddy/features/design/presentation/widgets/engineering_diagrams/slenderness_diagram.dart';
import 'package:site_buddy/features/design/presentation/widgets/engineering_diagrams/design_result_card.dart';
// import 'package:site_buddy/shared/widgets/action_buttons_group.dart';

/// SCREEN: SlendernessCheckScreen
/// PURPOSE: Slenderness classification (Step 3).
class SlendernessCheckScreen extends ConsumerWidget {
  const SlendernessCheckScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(columnDesignControllerProvider);

    return SbPage.detail(
      title: 'Slenderness Check',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Step 3 of 6: Slenderness Classification',
            style: SbTextStyles.title(context).copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: AppLayout.sectionGap),
          DesignResultCard(
            title: 'Column Classification',
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
          const SizedBox(height: AppLayout.elementGap),
          Text(
            'Geometric Visualization',
            style: SbTextStyles.title(context),
          ),
          const SizedBox(height: AppLayout.elementGap),
          SlendernessDiagram(
            slendernessX: state.slendernessX,
            slendernessY: state.slendernessY,
            lex: state.lex,
            ley: state.ley,
            b: state.b,
            d: state.d,
            isCircular: state.type == ColumnType.circular,
          ),
          const SizedBox(height: AppLayout.sectionGap),
          DesignResultCard(
            title: 'Effective Length Parameters',
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
          const SizedBox(height: AppLayout.sectionGap),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SbButton.primary(
                label: 'Next: Design Calculation',
                onPressed: () {
                  context.push('/column/design');
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
