import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/widgets/app_number_field.dart';
import 'package:site_buddy/features/calculator/application/controllers/rebar_controller.dart';

/// SCREEN: RebarScreen
/// PURPOSE: Estimate steel rebar quantity, length, and weight based on spacing and member dimensions.
class RebarScreen extends ConsumerWidget {
  const RebarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(rebarControllerProvider);
    final controller = ref.read(rebarControllerProvider.notifier);
    final colorScheme = theme.colorScheme;

    Widget buildResultCard() {
      final res = state.result!;
      return SbCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SbListItem(
              title: 'Number of Bars',
              trailing: Text(
                res.numberOfBars.toStringAsFixed(0),
                style: SbTextStyles.body(context).copyWith(
                  color: colorScheme.primary,
                ),
              ),
            ),
            SbListItem(
              title: 'Total Length',
              trailing: Text(
                '${res.totalLength.toStringAsFixed(2)} m',
                style: SbTextStyles.body(context),
              ),
            ),
            SbListItem(
              title: 'Total Weight',
              trailing: Text(
                '${res.totalWeight.toStringAsFixed(2)} kg',
                style: SbTextStyles.body(context).copyWith(
                  color: colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return SbPage.form(
      title: 'Rebar Estimator',
      primaryAction: SbButton.primary(
        label: state.isLoading ? 'Calculating...' : 'Calculate Estimation',
        icon: state.isLoading ? null : SbIcons.calculator,
        isLoading: state.isLoading,
        onPressed: controller.calculate,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'STRUCTURAL REBAR REQUIREMENTS',
            style: SbTextStyles.title(context).copyWith(
              color: colorScheme.primary,
              letterSpacing: 1.1,
            ),
            textAlign: TextAlign.center,
          ),
          AppLayout.vGap8,

          AppNumberField(
            label: 'Member Length (m)',
            suffixIcon: SbIcons.ruler,
            onChanged: controller.updateMemberLength,
          ),
          AppLayout.vGap8,

          AppNumberField(
            label: 'Spacing (m)',
            suffixIcon: SbIcons.spacing,
            onChanged: controller.updateSpacing,
          ),
          AppLayout.vGap8,

          Row(
            children: [
              Expanded(
                child: AppNumberField(
                  label: 'Diameter (mm)',
                  suffixIcon: SbIcons.diameter,
                  onChanged: controller.updateDiameter,
                ),
              ),
              AppLayout.hGap8,
              Expanded(
                child: AppNumberField(
                  label: 'Waste (%)',
                  suffixIcon: SbIcons.percent,
                  onChanged: controller.updateWaste,
                ),
              ),
            ],
          ),

          AppLayout.vGap24,

          if (state.failure != null) ...[
            SbCard(
              child: Padding(
                padding: AppLayout.paddingMedium,
                child: Text(
                  state.failure!.message,
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
