import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/features/water/irrigation/application/irrigation_calculator.dart';

/// lib/features/water/irrigation/presentation/irrigation_screen.dart
///
/// Basic UI for Irrigation Discharge Calculation.
class IrrigationScreen extends ConsumerWidget {
  const IrrigationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(irrigationCalculatorProvider);
    final controller = ref.read(irrigationCalculatorProvider.notifier);
    final theme = Theme.of(context);

    return SbPage.scaffold(
      title: 'Irrigation Discharge',
      body: SbSectionList(
        sections: [
          SbSection(
            title: 'Channel Parameters',
            child: SbCard(
              child: Column(
                children: [
                  SbInput(
                    label: 'Cross-sectional Area (m²)',
                    suffixIcon: const Icon(SbIcons.area),
                    onChanged: controller.updateArea,
                    hint: 'e.g. 2.5',
                  ),
                  const SizedBox(height: SbSpacing.md),
                  SbInput(
                    label: 'Mean Velocity (m/s)',
                    suffixIcon: const Icon(SbIcons.trendingUp),
                    onChanged: controller.updateVelocity,
                    hint: 'e.g. 1.2',
                  ),
                ],
              ),
            ),
          ),
          SbSection(
            child: Row(
              children: [
                Expanded(
                  child: SecondaryButton(
                    label: 'Reset',
                    icon: SbIcons.refresh,
                    onPressed: controller.reset,
                    isOutlined: true,
                  ),
                ),
                const SizedBox(width: SbSpacing.md),
                Expanded(
                  child: PrimaryCTA(
                    label: 'Compute Discharge',
                    icon: state.isLoading ? null : SbIcons.calculator,
                    isLoading: state.isLoading,
                    onPressed: controller.calculate,
                  ),
                ),
              ],
            ),
          ),
          if (state.errorMessage != null)
            SbSection(
              child: SbCard(
                child: Text(
                  state.errorMessage!,
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error),
                ),
              ),
            ),
          if (state.result != null)
            SbSection(
              title: 'Flow Results (${state.result!.methodology})',
              child: SbListGroup(
                children: [
                  SbListItemTile(
                    title: 'Discharge (Q)',
                    onTap: () {},
                    trailing: Text('${state.result!.dischargeQ.toStringAsFixed(3)} m³/s'),
                  ),
                  SbListItemTile(
                    title: 'Flow in LPS',
                    onTap: () {},
                    trailing: Text('${state.result!.dischargeLPS.toStringAsFixed(1)} l/s'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
