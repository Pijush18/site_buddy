import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/widgets/app_number_field.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/features/calculator/application/controllers/sand_controller.dart';

/// SCREEN: SandScreen
/// PURPOSE: UI for calculating sand volume based on area dimensions and rates.
class SandScreen extends ConsumerWidget {
  const SandScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(sandControllerProvider);
    final controller = ref.read(sandControllerProvider.notifier);
    final colorScheme = theme.colorScheme;

    Widget buildResultCard() {
      final res = state.result!;
      return SbCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Volume Results', style: SbTextStyles.title(context)),
            AppLayout.vGap8,
            Text(
              '${res.dryVolume.toStringAsFixed(2)} m³',
              style: SbTextStyles.headline(context).copyWith(
                color: colorScheme.primary,
              ),
            ),
            AppLayout.vGap16,
            SbListItem(
              title: 'Wet Volume',
              trailing: Text(
                '${res.wetVolume.toStringAsFixed(2)} m³',
                style: SbTextStyles.body(context),
              ),
            ),
            SbListItem(
              title: 'Sand (ft³)',
              trailing: Text(
                res.cubicFeet.toStringAsFixed(2),
                style: SbTextStyles.body(context),
              ),
            ),
            if (res.totalCost != null) ...[
              AppLayout.vGap8,
              const Divider(),
              AppLayout.vGap8,
              SbListItem(
                title: 'Estimated Cost',
                trailing: Text(
                  '\$ ${res.totalCost!.toStringAsFixed(2)}',
                  style: SbTextStyles.body(context).copyWith(
                    color: colorScheme.primary,
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    }

    return SbPage.form(
      title: 'Sand Quantity Estimator',
      primaryAction: SbButton.primary(
        label: state.isLoading ? 'Calculating...' : 'Calculate',
        icon: SbIcons.calculator,
        isLoading: state.isLoading,
        onPressed: controller.calculate,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'VOLUME & RATE',
            style: SbTextStyles.title(context).copyWith(
              color: theme.colorScheme.primary,
              letterSpacing: 1.1,
            ),
            textAlign: TextAlign.center,
          ),
          AppLayout.vGap12,

          AppNumberField(
            label: 'Length (m)',
            suffixIcon: SbIcons.ruler,
            onChanged: controller.updateLength,
          ),
          AppLayout.vGap12,

          AppNumberField(
            label: 'Width (m)',
            suffixIcon: SbIcons.ruler,
            onChanged: controller.updateWidth,
          ),
          AppLayout.vGap12,

          AppNumberField(
            label: 'Depth (m)',
            suffixIcon: SbIcons.height,
            onChanged: controller.updateDepth,
          ),
          AppLayout.vGap12,

          AppNumberField(
            label: 'Rate per m³ (optional)',
            suffixIcon: SbIcons.payments,
            onChanged: controller.updateRate,
          ),

          AppLayout.vGap24,

          if (state.error != null) ...[
            SbCard(
              child: Padding(
                padding: AppLayout.paddingMedium,
                child: Text(
                  state.error!,
                  style: SbTextStyles.body(context).copyWith(
                    color: colorScheme.error,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            AppLayout.vGap24,
          ],

          if (state.result != null) ...[buildResultCard(), AppLayout.vGap24],
        ],
      ),
    );
  }
}
