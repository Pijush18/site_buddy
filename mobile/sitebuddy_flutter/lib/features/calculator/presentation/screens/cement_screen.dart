import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/constants/app_strings.dart';
import 'package:site_buddy/core/constants/engineering_terms.dart';
import 'package:site_buddy/core/constants/screen_titles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/shared/widgets/action_buttons_group.dart';
import 'package:site_buddy/features/calculator/application/controllers/cement_controller.dart';

class CementScreen extends ConsumerWidget {
  const CementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(cementControllerProvider);
    final controller = ref.read(cementControllerProvider.notifier);

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
              style: Theme.of(context).textTheme.titleMedium!,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: SbSpacing.lg),
            const Divider(),
            SbListItemTile(
              title: EngineeringTerms.wetVolume,
              onTap: () {}, // Detail view entry
              trailing: Text(
                '${res.wetVolume.toStringAsFixed(2)} m³',
                style: Theme.of(context).textTheme.bodyLarge!,
              ),
            ),
            SbListItemTile(
              title: EngineeringTerms.dryVolume,
              onTap: () {}, // Detail view entry
              trailing: Text(
                '${res.dryVolume.toStringAsFixed(2)} m³',
                style: Theme.of(context).textTheme.bodyLarge!,
              ),
            ),
            SbListItemTile(
              title: EngineeringTerms.cementWeight,
              onTap: () {}, // Detail view entry
              trailing: Text(
                '${res.cementWeight.toStringAsFixed(0)} kg',
                style: Theme.of(context).textTheme.bodyLarge!,
              ),
            ),
            SbListItemTile(
              title: EngineeringTerms.numberOfBags,
              onTap: () {}, // Detail view entry
              trailing: Text(
                res.numberOfBags.toStringAsFixed(1),
                style: Theme.of(context).textTheme.labelLarge!,
              ),
            ),
            if (res.totalCost != null) ...[
              const SizedBox(height: SbSpacing.sm),
              const Divider(),
              const SizedBox(height: SbSpacing.sm),
              SbListItemTile(
                title: EngineeringTerms.estimatedCost,
                onTap: () {}, // Detail view entry
                trailing: Text(
                  '\$ ${res.totalCost!.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.labelLarge!,
                ),
              ),
            ],
          ],
        ),
      );
    }

    return SbPage.scaffold(
      title: ScreenTitles.cementBagEstimator,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            EngineeringTerms.volumeAndDimensions,
            style: Theme.of(context).textTheme.titleMedium!,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: SbSpacing.xl),
          SbInput(
            label: EngineeringTerms.wallLength,
            suffixIcon: const Icon(SbIcons.ruler),
            onChanged: controller.updateLength,
            errorText: lError,
          ),
          const SizedBox(height: SbSpacing.sm),
          SbInput(
            label: EngineeringTerms.width,
            suffixIcon: const Icon(SbIcons.ruler),
            onChanged: controller.updateWidth,
            errorText: wError,
          ),
          const SizedBox(height: SbSpacing.sm),
          SbInput(
            label: EngineeringTerms.depth,
            suffixIcon: const Icon(SbIcons.height),
            onChanged: controller.updateDepth,
            errorText: dError,
          ),
          const SizedBox(height: SbSpacing.xl),
          Text(
            EngineeringTerms.ratioFormat,
            style: Theme.of(context).textTheme.titleMedium!,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: SbSpacing.md),
          Wrap(
            spacing: SbSpacing.lg,
            runSpacing: SbSpacing.lg,
            children: [
              SizedBox(
                width: 100,
                child: SbInput(
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
                child: SbInput(
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
                child: SbInput(
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
          const SizedBox(height: SbSpacing.lg),
          Wrap(
            spacing: SbSpacing.lg,
            runSpacing: SbSpacing.lg,
            children: [
              SizedBox(
                width: 160,
                child: SbInput(
                  label: EngineeringTerms.wastePercent,
                  suffixIcon: const Icon(SbIcons.percent),
                  onChanged: controller.updateWaste,
                  onInfoPressed: () => SbFeedback.showToast(
                    context: context,
                    message: EngineeringTerms.wasteInfo,
                  ),
                ),
              ),
              SizedBox(
                width: 160,
                child: SbInput(
                  label: EngineeringTerms.pricePerBag,
                  suffixIcon: const Icon(SbIcons.payments),
                  onChanged: controller.updatePrice,
                ),
              ),
            ],
          ),
          const SizedBox(height: SbSpacing.xl),
          ActionButtonsGroup(
            children: [
              SecondaryButton(isOutlined: true, 
                label: AppStrings.clearAll,
                icon: SbIcons.refresh,
                onPressed: controller.reset,
              ),
              PrimaryCTA(
                label: state.isLoading ? AppStrings.calculating : AppStrings.calculate,
                icon: SbIcons.calculator,
                isLoading: state.isLoading,
                onPressed: isValid ? controller.calculate : null,
              ),
            ],
          ),
          const SizedBox(height: SbSpacing.xl),
          if (state.failure != null) ...[
            SbCard(
              child: Text(
                state.failure!.message,
                style: Theme.of(context).textTheme.bodyLarge!,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: SbSpacing.xl),
          ],
          if (state.result != null) ...[
            buildResultCard(),
            const SizedBox(height: SbSpacing.md),
            PrimaryCTA(
              label: 'Export PDF',
              icon: Icons.picture_as_pdf,
              onPressed: () {
                debugPrint("Export PDF clicked - TODO: implement");
              },
            ),
            const SizedBox(height: SbSpacing.xxl),
          ],
        ],
      ),
    );
  }
}
