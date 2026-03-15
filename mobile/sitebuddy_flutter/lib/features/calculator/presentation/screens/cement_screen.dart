import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/widgets/app_number_field.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/shared/widgets/action_buttons_group.dart';
import 'package:site_buddy/features/calculator/application/controllers/cement_controller.dart';

class CementScreen extends ConsumerWidget {
  const CementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(cementControllerProvider);
    final controller = ref.read(cementControllerProvider.notifier);
    final colorScheme = theme.colorScheme;

    final lError = state.failure?.message.contains('Length') == true ? state.failure?.message : null;
    final wError = state.failure?.message.contains('Width') == true ? state.failure?.message : null;
    final dError = state.failure?.message.contains('Depth') == true ? state.failure?.message : null;

    final isValid = state.length != null && state.width != null && state.depth != null;

    Widget buildResultCard() {
      final res = state.result!;
      return SbCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'RESULT SUMMARY',
              style: SbTextStyles.title(context).copyWith(
                color: colorScheme.primary,
                
                letterSpacing: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
            AppLayout.vGap16,
            const Divider(),
            SbListItem(
              title: 'Wet Volume',
              trailing: Text(
                '${res.wetVolume.toStringAsFixed(2)} m³',
                style: SbTextStyles.body(context),
              ),
            ),
            SbListItem(
              title: 'Dry Volume',
              trailing: Text(
                '${res.dryVolume.toStringAsFixed(2)} m³',
                style: SbTextStyles.body(context),
              ),
            ),
            SbListItem(
              title: 'Cement Weight',
              trailing: Text(
                '${res.cementWeight.toStringAsFixed(0)} kg',
                style: SbTextStyles.body(context),
              ),
            ),
            SbListItem(
              title: 'Number of Bags',
              trailing: Text(
                res.numberOfBags.toStringAsFixed(1),
                style: SbTextStyles.body(context).copyWith(
                  color: colorScheme.primary,
                ),
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

    return SbPage.scaffold(
      title: 'Cement Bag Estimator',
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppLayout.maxContentWidth,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'VOLUME & DIMENSIONS',
                  style: SbTextStyles.title(context).copyWith(
                    color: colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                AppLayout.vGap16,
                 AppNumberField(
                  label: 'Length (m)',
                  suffixIcon: SbIcons.ruler,
                  onChanged: controller.updateLength,
                  errorText: lError,
                ),
                AppLayout.vGap8,
                AppNumberField(
                  label: 'Width (m)',
                  suffixIcon: SbIcons.ruler,
                  onChanged: controller.updateWidth,
                  errorText: wError,
                ),
                AppLayout.vGap8,
                AppNumberField(
                  label: 'Depth (m)',
                  suffixIcon: SbIcons.height,
                  onChanged: controller.updateDepth,
                  errorText: dError,
                ),
                AppLayout.vGap24,
                Text(
                  'MIX RATIO (CEMENT : SAND : AGG)',
                  style: SbTextStyles.title(context).copyWith(
                    color: colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                AppLayout.vGap16,
                Wrap(
                  spacing: AppLayout.md,
                  runSpacing: AppLayout.md,
                  children: [
                    SizedBox(
                      width: 100,
                      child: AppNumberField(
                        label: 'Cement',
                        onChanged: controller.updateMixCement,
                        onInfoPressed: () => SbFeedback.showToast(
                          context: context,
                          message: 'Cement part of the ratio (e.g., 1)',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: AppNumberField(
                        label: 'Sand',
                        onChanged: controller.updateMixSand,
                        onInfoPressed: () => SbFeedback.showToast(
                          context: context,
                          message: 'Sand part of the ratio (e.g., 2)',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: AppNumberField(
                        label: 'Aggregate',
                        onChanged: controller.updateMixAggregate,
                        onInfoPressed: () => SbFeedback.showToast(
                          context: context,
                          message: 'Aggregate part of the ratio (e.g., 4)',
                        ),
                      ),
                    ),
                  ],
                ),
                AppLayout.vGap16,
                Wrap(
                  spacing: AppLayout.md,
                  runSpacing: AppLayout.md,
                  children: [
                    SizedBox(
                      width: 160,
                      child: AppNumberField(
                        label: 'Waste (%)',
                        suffixIcon: SbIcons.percent,
                        onChanged: controller.updateWaste,
                        onInfoPressed: () => SbFeedback.showToast(
                          context: context,
                          message: 'Percentage of material expected to be lost during application',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 160,
                      child: AppNumberField(
                        label: 'Price per Bag',
                        suffixIcon: SbIcons.payments,
                        onChanged: controller.updatePrice,
                      ),
                    ),
                  ],
                ),
                AppLayout.vGap24,
                ActionButtonsGroup(
                  children: [
                    SbButton.outline(
                      label: 'Clear All',
                      icon: SbIcons.refresh,
                      onPressed: controller.reset,
                    ),
                    SbButton.primary(
                      label: state.isLoading ? 'Calculating...' : 'Calculate',
                      icon: SbIcons.calculator,
                      isLoading: state.isLoading,
                      onPressed: isValid ? controller.calculate : null,
                    ),
                  ],
                ),
                AppLayout.vGap24,
                if (state.failure != null) ...[
                  SbCard(
                    child: Text(
                      state.failure!.message,
                      style: SbTextStyles.body(context).copyWith(
                        color: colorScheme.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  AppLayout.vGap24,
                ],
                if (state.result != null) ...[
                  buildResultCard(),
                  AppLayout.vGap24,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
