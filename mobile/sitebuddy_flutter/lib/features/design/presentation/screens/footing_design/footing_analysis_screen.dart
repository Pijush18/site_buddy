import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/core/widgets/main_navigation_wrapper.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/shared/domain/models/design/footing_type.dart';

import 'package:site_buddy/features/design/application/controllers/footing_design_controller.dart';
import 'package:site_buddy/features/design/presentation/widgets/engineering_diagrams/design_result_card.dart';
import 'package:site_buddy/shared/widgets/action_buttons_group.dart';

/// SCREEN: FootingAnalysisScreen
/// PURPOSE: Bearing pressure and area analysis (Step 4).
class FootingAnalysisScreen extends ConsumerWidget {
  const FootingAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(footingDesignControllerProvider);
//     final theme = Theme.of(context);

    return MainNavigationWrapper(
      child: SbPage.detail(
        title: 'Soil Analysis',
        appBarActions: [
          SbButton.icon(
            icon: SbIcons.help,
            onPressed: () => debugPrint('Help: Footing Analysis'),
          ),
          const SizedBox(width: AppLayout.pSmall),
        ],
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Step 4 of 6: Pressure Distribution',
              style: SbTextStyles.caption(context).copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            AppLayout.vGap24,

            // Area Comparison
            DesignResultCard(
              title: 'Bearing Area',
              isSafe: state.isAreaSafe,
              items: [
                DesignResultItem(
                  label: 'Required Area',
                  value: state.requiredArea.toStringAsFixed(2),
                  unit: 'm²',
                  subtitle: 'Includes 10% self-weight',
                ),
                DesignResultItem(
                  label: 'Provided Area',
                  value: state.providedArea.toStringAsFixed(2),
                  unit: 'm²',
                  isCritical: true,
                ),
              ],
            ),
            AppLayout.vGap16,

            // Pressure Analysis
            DesignResultCard(
              title: 'Soil Pressure',
              isSafe: state.maxSoilPressure <= state.sbc,
              items: [
                DesignResultItem(
                  label: 'Max. Pressure (q_max)',
                  value: state.maxSoilPressure.toStringAsFixed(2),
                  unit: 'kN/m²',
                  isCritical: true,
                ),
                DesignResultItem(
                  label: 'Min. Pressure (q_min)',
                  value: state.minSoilPressure.toStringAsFixed(2),
                  unit: 'kN/m²',
                ),
                DesignResultItem(
                  label: 'Allowable (SBC)',
                  value: state.sbc.toStringAsFixed(2),
                  unit: 'kN/m²',
                  subtitle: 'Serviceability Limit State',
                ),
              ],
            ),
            AppLayout.vGap16,

            // Eccentricity etc
            SbCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Distribution Details',
                    style: SbTextStyles.title(context),
                  ),
                  AppLayout.vGap16,
                  SbListItem(
                    title: 'Eccentricity (ex)',
                    trailing: Text(
                      '${state.eccentricityX.toStringAsFixed(1)} mm',
                      style: SbTextStyles.body(context),
                    ),
                  ),
                  if (state.type == FootingType.pile) ...[
                    AppLayout.vGap8,
                    SbListItem(
                      title: 'Piles Required',
                      trailing: Text(
                        '${state.pileCount}',
                        style: SbTextStyles.body(context).copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            AppLayout.vGap32,
          ActionButtonsGroup(
            children: [
              SbButton.primary(
                label: 'Next: Reinforcement',
                icon: SbIcons.gridView,
                onPressed: () => context.push('/footing/reinforcement'),
              ),
              SbButton.primary(
                label: 'Back',
                onPressed: () => context.pop(),
              ),
            ],
          ),
          AppLayout.vGap24,
          ],
        ),
      ),
    );
  }
}