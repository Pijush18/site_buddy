import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/localization/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/shared/widgets/action_buttons_group.dart';
import 'package:site_buddy/features/surveying/level/application/level_controller.dart';
import 'package:site_buddy/features/surveying/level/domain/level_result.dart';

/// SCREEN: LevelCalculatorScreen
/// PURPOSE: UI for comparing two field levels (Rise/Fall).
class LevelCalculatorScreen extends ConsumerWidget {
  const LevelCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(levelControllerProvider);
    final controller = ref.read(levelControllerProvider.notifier);
    final colorScheme = theme.colorScheme;
    final l10n = context.l10n;

    final sError = state.failure?.message.toLowerCase().contains('start') == true ? state.failure?.message : null;
    final eError = state.failure?.message.toLowerCase().contains('end') == true ? state.failure?.message : null;

    final isValid = state.startLevel != null && state.endLevel != null;

    Widget buildResultCard(LevelResult result) {
      String directionLabel;
      switch (result.direction) {
        case LevelDirection.rise:
          directionLabel = l10n.labelRise;
          break;
        case LevelDirection.fall:
          directionLabel = l10n.labelFall;
          break;
        case LevelDirection.flat:
          directionLabel = l10n.labelFlat;
          break;
      }

      return SbCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.labelEstimationResults,
              style: theme.textTheme.titleMedium!,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            const Divider(),
            const SizedBox(height: AppSpacing.lg),
            Text(
              '${result.difference.toStringAsFixed(2)} m',
              style: theme.textTheme.titleLarge!,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm / 2,
              ),
              child: Text(
                directionLabel,
                style: theme.textTheme.labelLarge!,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            SbListItemTile(
              title: l10n.labelDifference,
              onTap: () {}, // Detail view entry
              trailing: Text(
                '${result.absoluteDifference.toStringAsFixed(2)} m',
                style: theme.textTheme.bodyLarge!,
              ),
            ),
          ],
        ),
      );
    }

    return SbPage.scaffold(
      title: l10n.titleLevelEstimator,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(SbIcons.ruler, size: 72, color: colorScheme.primary),
          const SizedBox(height: AppSpacing.lg),
          Text(
            l10n.labelComparison,
            style: theme.textTheme.titleMedium!,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),

          SbInput(
            label: '${l10n.labelStart} (m)',
            suffixIcon: const Icon(SbIcons.arrowUp),
            onChanged: controller.updateStartLevel,
            errorText: sError,
          ),
          const SizedBox(height: AppSpacing.md),

          SbInput(
            label: '${l10n.labelEnd} (m)',
            suffixIcon: const Icon(SbIcons.arrowDown),
            onChanged: controller.updateEndLevel,
            errorText: eError,
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
                icon: state.isLoading ? null : SbIcons.calculator,
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
                style: theme.textTheme.bodyLarge!,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],

          if (state.result != null) ...[
            buildResultCard(state.result!),
            const SizedBox(height: AppSpacing.lg),
          ],
        ],
      ),
    );
  }
}

