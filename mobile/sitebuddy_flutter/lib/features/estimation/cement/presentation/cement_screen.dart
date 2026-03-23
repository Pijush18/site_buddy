import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/localization/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/shared/widgets/action_buttons_group.dart';
import 'package:site_buddy/features/estimation/cement/application/cement_controller.dart';
import 'package:site_buddy/core/logging/app_logger.dart';

class CementScreen extends ConsumerWidget {
  const CementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(cementControllerProvider);
    final controller = ref.read(cementControllerProvider.notifier);
    final l10n = context.l10n;

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
              l10n.labelEstimationResults,
              style: Theme.of(context).textTheme.titleMedium!,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            const Divider(),
            SbListItemTile(
              title: l10n.labelWetVolume,
              onTap: () {}, // Detail view entry
              trailing: Text(
                '${res.wetVolume.toStringAsFixed(2)} m³',
                style: Theme.of(context).textTheme.bodyLarge!,
              ),
            ),
            SbListItemTile(
              title: l10n.labelDryVolume,
              onTap: () {}, // Detail view entry
              trailing: Text(
                '${res.dryVolume.toStringAsFixed(2)} m³',
                style: Theme.of(context).textTheme.bodyLarge!,
              ),
            ),
            SbListItemTile(
              title: l10n.labelCementWeight,
              onTap: () {}, // Detail view entry
              trailing: Text(
                '${res.cementWeight.toStringAsFixed(0)} kg',
                style: Theme.of(context).textTheme.bodyLarge!,
              ),
            ),
            SbListItemTile(
              title: l10n.labelBags,
              onTap: () {}, // Detail view entry
              trailing: Text(
                res.numberOfBags.toStringAsFixed(1),
                style: Theme.of(context).textTheme.labelLarge!,
              ),
            ),
            if (res.totalCost != null) ...[
              const SizedBox(height: AppSpacing.sm),
              const Divider(),
              const SizedBox(height: AppSpacing.sm),
              SbListItemTile(
                title: l10n.labelEstimatedCost,
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
      title: l10n.titleCementEstimator,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.labelDimensions,
            style: Theme.of(context).textTheme.titleMedium!,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          SbInput(
            label: '${l10n.labelLength} (m)',
            suffixIcon: const Icon(SbIcons.ruler),
            onChanged: controller.updateLength,
            errorText: lError,
          ),
          const SizedBox(height: AppSpacing.md),
          SbInput(
            label: '${l10n.labelWidth} (m)',
            suffixIcon: const Icon(SbIcons.ruler),
            onChanged: controller.updateWidth,
            errorText: wError,
          ),
          const SizedBox(height: AppSpacing.md),
          SbInput(
            label: '${l10n.labelDepth} (m)',
            suffixIcon: const Icon(SbIcons.height),
            onChanged: controller.updateDepth,
            errorText: dError,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            '${l10n.labelMixRatio} (C:S:A)',
            style: Theme.of(context).textTheme.titleMedium!,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: SbInput(
                  label: l10n.labelCement,
                  onChanged: controller.updateMixCement,
                  onInfoPressed: () => SbFeedback.showToast(
                    context: context,
                    message: l10n.msgCementRatioInfo,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: SbInput(
                  label: l10n.labelSand,
                  onChanged: controller.updateMixSand,
                  onInfoPressed: () => SbFeedback.showToast(
                    context: context,
                    message: l10n.msgSandRatioInfo,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: SbInput(
                  label: l10n.labelAggregate,
                  onChanged: controller.updateMixAggregate,
                  onInfoPressed: () => SbFeedback.showToast(
                    context: context,
                    message: l10n.msgAggregateRatioInfo,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: SbInput(
                  label: l10n.labelWastage,
                  suffixIcon: const Icon(SbIcons.percent),
                  onChanged: controller.updateWaste,
                  onInfoPressed: () => SbFeedback.showToast(
                    context: context,
                    message: l10n.msgWastageInfo,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: SbInput(
                  label: l10n.labelPricePerBag,
                  suffixIcon: const Icon(SbIcons.payments),
                  onChanged: controller.updatePrice,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          ActionButtonsGroup(
            children: [
              SecondaryButton(isOutlined: true, 
                label: l10n.actionClearAll,
                icon: SbIcons.refresh,
                onPressed: controller.reset,
              ),
              PrimaryCTA(
                label: l10n.actionCalculate,
                icon: SbIcons.calculator,
                isLoading: state.isLoading,
                onPressed: isValid ? controller.calculate : null,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          if (state.failure != null) ...[
            SbCard(
              child: Text(
                state.failure!.message,
                style: Theme.of(context).textTheme.bodyLarge!,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
          if (state.result != null) ...[
            buildResultCard(),
            const SizedBox(height: AppSpacing.md),
            PrimaryCTA(
              label: l10n.actionExportPdf,
              icon: Icons.picture_as_pdf,
              onPressed: () {
                AppLogger.info('Export PDF clicked - implementation pending', tag: 'CementUI');
              },
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ],
      ),
    );
  }
}

