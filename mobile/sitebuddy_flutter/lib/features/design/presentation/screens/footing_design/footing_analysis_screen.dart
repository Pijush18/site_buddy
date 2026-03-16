import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/theme/app_font_sizes.dart';
import 'package:site_buddy/core/widgets/app_screen_wrapper.dart';
import 'package:site_buddy/core/widgets/components/sb_button.dart';
import 'package:site_buddy/core/widgets/components/sb_card.dart';
import 'package:site_buddy/shared/domain/models/design/footing_type.dart';
import 'package:site_buddy/features/design/application/controllers/footing_design_controller.dart';
import 'package:site_buddy/features/design/presentation/widgets/engineering_diagrams/design_result_card.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';

/// SCREEN: FootingAnalysisScreen
/// PURPOSE: Bearing pressure and area analysis (Step 4).
class FootingAnalysisScreen extends ConsumerWidget {
  const FootingAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(footingDesignControllerProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return AppScreenWrapper(
      title: 'Soil Analysis',
      actions: [
        IconButton(
          icon: const Icon(Icons.help_outline),
          onPressed: () => debugPrint('Help: Footing Analysis'),
        ),
        const SizedBox(width: AppSpacing.sm),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Step 4 of 6: Pressure Distribution',
            style: TextStyle(
              fontSize: AppFontSizes.tab,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24

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
          const SizedBox(height: AppSpacing.md), // Replaced AppLayout.vGap16

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
          const SizedBox(height: AppSpacing.md), // Replaced AppLayout.vGap16

          // Eccentricity etc
          SBCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Distribution Details',
                  style: TextStyle(
                    fontSize: AppFontSizes.title,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.md), // Replaced AppLayout.vGap16
                SbListItem(
                  title: 'Eccentricity (ex)',
                  trailing: Text(
                    '${state.eccentricityX.toStringAsFixed(1)} mm',
                    style: const TextStyle(fontSize: AppFontSizes.subtitle),
                  ),
                ),
                if (state.type == FootingType.pile) ...[
                  const SizedBox(height: AppSpacing.sm), // Replaced AppLayout.vGap8
                  SbListItem(
                    title: 'Piles Required',
                    trailing: Text(
                      '${state.pileCount}',
                      style: TextStyle(
                        fontSize: AppFontSizes.subtitle,
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap32 (closest standard)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SBButton.primary(
                label: 'Next: Reinforcement',
                icon: Icons.grid_view_outlined,
                onPressed: () => context.push('/footing/reinforcement'),
                fullWidth: true,
              ),
              const SizedBox(height: AppSpacing.sm),
              SBButton.secondary(
                label: 'Back',
                onPressed: () => context.pop(),
                fullWidth: true,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg), // Added for bottom padding consistency
        ],
      ),
    );
  }
}