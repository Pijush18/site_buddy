import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/features/transport/road/application/road_calculator.dart';

/// lib/features/transport/road/presentation/road_screen.dart
///
/// Minimal UI for Road Pavement Design.
class RoadScreen extends ConsumerWidget {
  const RoadScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(roadCalculatorProvider);
    final controller = ref.read(roadCalculatorProvider.notifier);
    final theme = Theme.of(context);

    return SbPage.scaffold(
      title: 'Road Pavement Design',
      body: SbSectionList(
        sections: [
          SbSection(
            title: 'Subgrade Properties',
            child: SbCard(
              child: Column(
                children: [
                  SbInput(
                    label: 'Subgrade CBR (%)',
                    suffixIcon: const Icon(SbIcons.ruler),
                    onChanged: controller.updateCBR,
                    hint: 'e.g. 5.0',
                  ),
                  const SizedBox(height: SbSpacing.md),
                  SbInput(
                    label: 'Design Traffic (msa)',
                    suffixIcon: const Icon(SbIcons.truck),
                    onChanged: controller.updateTraffic,
                    hint: 'e.g. 10.0',
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
                    label: 'Design Pavement',
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
              title: 'Design Results (${state.result!.designCode})',
              child: SbListGroup(
                children: [
                  SbListItemTile(
                    title: 'Total Thickness',
                    onTap: () {},
                    trailing: Text('${state.result!.totalThickness.toStringAsFixed(0)} mm'),
                  ),
                  SbListItemTile(
                    title: 'Bituminous Layer',
                    onTap: () {},
                    trailing: Text('${state.result!.bituminousThickness.toStringAsFixed(0)} mm'),
                  ),
                  SbListItemTile(
                    title: 'Granular Base (WMM)',
                    onTap: () {},
                    trailing: Text('${state.result!.baseThickness.toStringAsFixed(0)} mm'),
                  ),
                  SbListItemTile(
                    title: 'Granular Sub-base (GSB)',
                    onTap: () {},
                    trailing: Text('${state.result!.subBaseThickness.toStringAsFixed(0)} mm'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
