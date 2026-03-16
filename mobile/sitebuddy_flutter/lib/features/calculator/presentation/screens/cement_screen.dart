import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/theme/app_font_sizes.dart';
import 'package:site_buddy/core/widgets/app_screen_wrapper.dart';
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
    final state = ref.watch(cementControllerProvider);
    final controller = ref.read(cementControllerProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;

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
              style: TextStyle(
                fontSize: AppFontSizes.title,
                fontWeight: FontWeight.w600,
                color: colorScheme.primary,
                letterSpacing: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md), // Replaced AppLayout.vGap16
            const Divider(),
            SbListItem(
              title: 'Wet Volume',
              trailing: Text(
                '${res.wetVolume.toStringAsFixed(2)} m³',
                style: const TextStyle(fontSize: AppFontSizes.subtitle),
              ),
            ),
            SbListItem(
              title: 'Dry Volume',
              trailing: Text(
                '${res.dryVolume.toStringAsFixed(2)} m³',
                style: const TextStyle(fontSize: AppFontSizes.subtitle),
              ),
            ),
            SbListItem(
              title: 'Cement Weight',
              trailing: Text(
                '${res.cementWeight.toStringAsFixed(0)} kg',
                style: const TextStyle(fontSize: AppFontSizes.subtitle),
              ),
            ),
            SbListItem(
              title: 'Number of Bags',
              trailing: Text(
                res.numberOfBags.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: AppFontSizes.subtitle,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.primary,
                ),
              ),
            ),
            if (res.totalCost != null) ...[
              const SizedBox(height: AppSpacing.sm), // Replaced AppLayout.vGap8
              const Divider(),
              const SizedBox(height: AppSpacing.sm), // Replaced AppLayout.vGap8
              SbListItem(
                title: 'Estimated Cost',
                trailing: Text(
                  '\$ ${res.totalCost!.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: AppFontSizes.subtitle,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.primary,
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    }

    return AppScreenWrapper(
      title: 'Cement Bag Estimator',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'VOLUME & DIMENSIONS',
            style: TextStyle(
              fontSize: AppFontSizes.title,
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md), // Replaced AppLayout.vGap16
          AppNumberField(
            label: 'Length (m)',
            suffixIcon: SbIcons.ruler,
            onChanged: controller.updateLength,
            errorText: lError,
          ),
          const SizedBox(height: AppSpacing.sm), // Replaced AppLayout.vGap8
          AppNumberField(
            label: 'Width (m)',
            suffixIcon: SbIcons.ruler,
            onChanged: controller.updateWidth,
            errorText: wError,
          ),
          const SizedBox(height: AppSpacing.sm), // Replaced AppLayout.vGap8
          AppNumberField(
            label: 'Depth (m)',
            suffixIcon: SbIcons.height,
            onChanged: controller.updateDepth,
            errorText: dError,
          ),
          const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24
          Text(
            'MIX RATIO (CEMENT : SAND : AGG)',
            style: TextStyle(
              fontSize: AppFontSizes.title,
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md), // Replaced AppLayout.vGap16
          Wrap(
            spacing: AppSpacing.md, // Replaced AppLayout.md
            runSpacing: AppSpacing.md, // Replaced AppLayout.md
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
          const SizedBox(height: AppSpacing.md), // Replaced AppLayout.vGap16
          Wrap(
            spacing: AppSpacing.md, // Replaced AppLayout.md
            runSpacing: AppSpacing.md, // Replaced AppLayout.md
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
          const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24
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
          const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24
          if (state.failure != null) ...[
            SbCard(
              child: Text(
                state.failure!.message,
                style: TextStyle(
                  fontSize: AppFontSizes.subtitle,
                  color: colorScheme.error,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24
          ],
          if (state.result != null) ...[
            buildResultCard(),
            const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24
          ],
        ],
      ),
    );
  }
}
