import 'package:site_buddy/core/theme/app_text_styles.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
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
    final colorScheme = Theme.of(context).colorScheme;

    return AppScreenWrapper(
      title: 'Slenderness Check',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Step 3 of 6: Slenderness Classification',
            style: AppTextStyles.screenTitle(context).copyWith(
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.sectionGap
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
          const SizedBox(height: AppSpacing.md), // Replaced AppLayout.elementGap
          Text(
            'Geometric Visualization',
          style: AppTextStyles.sectionTitle(context),
          ),
          const SizedBox(height: AppSpacing.md), // Replaced AppLayout.elementGap
          SlendernessDiagram(
            slendernessX: state.slendernessX,
            slendernessY: state.slendernessY,
            lex: state.lex,
            ley: state.ley,
            b: state.b,
            d: state.d,
            isCircular: state.type == ColumnType.circular,
          ),
          const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.sectionGap
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SbButton.primary(
                label: 'Next: Design Calculation',
                onPressed: () {
                  context.push('/column/design');
                },
                width: double.infinity,
              ),
              const SizedBox(height: AppSpacing.sm),
              SbButton.secondary(
                label: 'Back',
                onPressed: () => context.pop(),
                width: double.infinity,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}
