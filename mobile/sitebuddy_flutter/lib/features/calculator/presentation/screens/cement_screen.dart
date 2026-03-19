import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/theme/app_font_sizes.dart';
import 'package:site_buddy/core/constants/app_strings.dart';
import 'package:site_buddy/core/constants/engineering_terms.dart';
import 'package:site_buddy/core/constants/screen_titles.dart';
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
              EngineeringTerms.resultSummary,
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
            SbListItemTile(
              title: EngineeringTerms.wetVolume,
              onTap: () {}, // Detail view entry
              trailing: Text(
                '${res.wetVolume.toStringAsFixed(2)} m³',
                style: const TextStyle(fontSize: AppFontSizes.subtitle),
              ),
            ),
            SbListItemTile(
              title: EngineeringTerms.dryVolume,
              onTap: () {}, // Detail view entry
              trailing: Text(
                '${res.dryVolume.toStringAsFixed(2)} m³',
                style: const TextStyle(fontSize: AppFontSizes.subtitle),
              ),
            ),
            SbListItemTile(
              title: EngineeringTerms.cementWeight,
              onTap: () {}, // Detail view entry
              trailing: Text(
                '${res.cementWeight.toStringAsFixed(0)} kg',
                style: const TextStyle(fontSize: AppFontSizes.subtitle),
              ),
            ),
            SbListItemTile(
              title: EngineeringTerms.numberOfBags,
              onTap: () {}, // Detail view entry
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
              SbListItemTile(
                title: EngineeringTerms.estimatedCost,
                onTap: () {}, // Detail view entry
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
      title: ScreenTitles.cementBagEstimator,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            EngineeringTerms.volumeAndDimensions,
            style: TextStyle(
              fontSize: AppFontSizes.title,
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md), // Replaced AppLayout.vGap16
          AppNumberField(
            label: EngineeringTerms.wallLength, // Reuse Wall Length or add generic Length
            suffixIcon: SbIcons.ruler,
            onChanged: controller.updateLength,
            errorText: lError,
          ),
          const SizedBox(height: AppSpacing.sm), // Replaced AppLayout.vGap8
          AppNumberField(
            label: EngineeringTerms.width, // I should check if EngineeringTerms.width has (m)
            suffixIcon: SbIcons.ruler,
            onChanged: controller.updateWidth,
            errorText: wError,
          ),
          const SizedBox(height: AppSpacing.sm), // Replaced AppLayout.vGap8
          AppNumberField(
            label: EngineeringTerms.depth,
            suffixIcon: SbIcons.height,
            onChanged: controller.updateDepth,
            errorText: dError,
          ),
          const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24
          Text(
            EngineeringTerms.ratioFormat,
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
                  label: EngineeringTerms.cement,
                  onChanged: controller.updateMixCement,
                  onInfoPressed: () => SbFeedback.showToast(
                    context: context,
                    message: EngineeringTerms.cementRatioInfo,
                  ),
                ),
              ),
              SizedBox(
                width: 100,
                child: AppNumberField(
                  label: EngineeringTerms.sand,
                  onChanged: controller.updateMixSand,
                  onInfoPressed: () => SbFeedback.showToast(
                    context: context,
                    message: EngineeringTerms.sandRatioInfo,
                  ),
                ),
              ),
              SizedBox(
                width: 100,
                child: AppNumberField(
                  label: EngineeringTerms.aggregate,
                  onChanged: controller.updateMixAggregate,
                  onInfoPressed: () => SbFeedback.showToast(
                    context: context,
                    message: EngineeringTerms.aggregateRatioInfo,
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
                  label: EngineeringTerms.wastePercent,
                  suffixIcon: SbIcons.percent,
                  onChanged: controller.updateWaste,
                  onInfoPressed: () => SbFeedback.showToast(
                    context: context,
                    message: EngineeringTerms.wasteInfo,
                  ),
                ),
              ),
              SizedBox(
                width: 160,
                child: AppNumberField(
                  label: EngineeringTerms.pricePerBag,
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
                label: AppStrings.clearAll,
                icon: SbIcons.refresh,
                onPressed: controller.reset,
              ),
              SbButton.primary(
                label: state.isLoading ? AppStrings.calculating : AppStrings.calculate,
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
