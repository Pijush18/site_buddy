import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/features/transport/road/application/road_calculator.dart';

/// lib/features/transport/road/presentation/road_screen.dart
///
/// Advanced UI for IRC Flexible Pavement Design.
class RoadScreen extends ConsumerWidget {
  const RoadScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(roadCalculatorProvider);
    final controller = ref.read(roadCalculatorProvider.notifier);
    final theme = Theme.of(context);

    return SbPage.scaffold(
      title: 'Advanced Road Design',
      body: SbSectionList(
        sections: [
          SbSection(
            title: 'Design Parameters (IRC:37)',
            child: SbCard(
              child: Column(
                children: [
                  SbInput(
                    label: 'Subgrade CBR (%)',
                    suffixIcon: const Icon(SbIcons.ruler),
                    onChanged: controller.updateCBR,
                    hint: 'e.g. 5.0',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SbInput(
                    label: 'Design Traffic (msa)',
                    suffixIcon: const Icon(SbIcons.truck),
                    onChanged: controller.updateMSA,
                    hint: 'e.g. 20.0',
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
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: PrimaryCTA(
                    label: 'Design Pavement',
                    icon: state.isLoading ? null : SbIcons.calculator,
                    isLoading: state.isLoading,
                    onPressed: controller.calculatePavement,
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
          if (state.result != null) ...[
            SbSection(
              title: 'Pavement Composition',
              child: SbCard(
                child: Column(
                  children: [
                    Text(
                      'Safety: ${state.result!.safetyClassification}',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: state.result!.safetyClassification.contains('SAFE') 
                          ? Colors.green 
                          : Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(),
                    ...state.result!.layers.map((l) => SbListItemTile(
                      title: l.name,
                      onTap: () {},
                      trailing: Text(
                        '${l.thickness.toStringAsFixed(0)} mm',
                        style: TextStyle(
                          color: l.isLocked ? theme.colorScheme.outline : null,
                          fontStyle: l.isLocked ? FontStyle.italic : null,
                        ),
                      ),
                    )),
                  ],
                ),
              ),
            ),
            SbSection(
              title: 'Design Summary',
              child: SbListGroup(
                children: [
                  SbListItemTile(
                    title: 'Total Crust Thickness',
                    onTap: () {},
                    trailing: Text('${state.result!.totalThickness.toStringAsFixed(0)} mm'),
                  ),
                  SbListItemTile(
                    title: 'Design MSA',
                    onTap: () {},
                    trailing: Text('${state.result!.msaDesign} msa'),
                  ),
                  SbListItemTile(
                    title: 'Subgrade CBR',
                    onTap: () {},
                    trailing: Text('${state.result!.cbrProvided}%'),
                  ),
                ],
              ),
            ),
          ]
        ],
      ),
    );
  }
}
