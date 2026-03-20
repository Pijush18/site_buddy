import 'package:site_buddy/core/design_system/sb_icons.dart';

import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/constants/app_strings.dart';
import 'package:site_buddy/core/constants/engineering_terms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/shared/widgets/action_buttons_group.dart';
import 'package:site_buddy/features/calculator/application/controllers/level_controller.dart';
import 'package:site_buddy/features/calculator/domain/entities/level_result.dart';

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

    final sError = state.failure?.message.toLowerCase().contains('start') == true ? state.failure?.message : null;
    final eError = state.failure?.message.toLowerCase().contains('end') == true ? state.failure?.message : null;

    final isValid = state.startLevel != null && state.endLevel != null;

    Widget buildResultCard(LevelResult result) {
      String directionLabel;
      switch (result.direction) {
        case LevelDirection.rise:
          directionLabel = EngineeringTerms.rise;
          break;
        case LevelDirection.fall:
          directionLabel = EngineeringTerms.fall;
          break;
        case LevelDirection.flat:
          directionLabel = EngineeringTerms.flat;
          break;
      }

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
            const SizedBox(height: SbSpacing.lg),
            Text(
              '${result.difference.toStringAsFixed(2)} m',
              style: Theme.of(context).textTheme.titleLarge!,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: SbSpacing.sm),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: SbSpacing.lg,
                vertical: SbSpacing.sm / 2,
              ),
              child: Text(
                directionLabel,
                style: Theme.of(context).textTheme.labelLarge!,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: SbSpacing.xxl),
            SbListItemTile(
              title: EngineeringTerms.absoluteDifference,
              onTap: () {}, // Detail view entry
              trailing: Text(
                '${result.absoluteDifference.toStringAsFixed(2)} m',
                style: Theme.of(context).textTheme.bodyLarge!,
              ),
            ),
          ],
        ),
      );
    }

    return SbPage.scaffold(
      title: EngineeringTerms.levelCalculator,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(SbIcons.ruler, size: 72, color: colorScheme.primary),
          const SizedBox(height: SbSpacing.lg),
          Text(
            EngineeringTerms.fieldLevelComparison,
            style: Theme.of(context).textTheme.titleMedium!,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: SbSpacing.xxl),

          SbInput(
            label: EngineeringTerms.startLevel,
            suffixIcon: const Icon(SbIcons.arrowUp),
            onChanged: controller.updateStartLevel,
            errorText: sError,
          ),
          const SizedBox(height: SbSpacing.sm),

          SbInput(
            label: EngineeringTerms.endLevel,
            suffixIcon: const Icon(SbIcons.arrowDown),
            onChanged: controller.updateEndLevel,
            errorText: eError,
          ),

          const SizedBox(height: SbSpacing.xxl),

          ActionButtonsGroup(
            children: [
              SbButton.outline(
                label: AppStrings.clearAll,
                icon: SbIcons.refresh,
                onPressed: controller.reset,
              ),
              SbButton.primary(
                label: state.isLoading ? AppStrings.calculating : AppStrings.calculate,
                icon: state.isLoading ? null : SbIcons.calculator,
                isLoading: state.isLoading,
                onPressed: isValid ? controller.calculate : null,
              ),
            ],
          ),

          const SizedBox(height: SbSpacing.xxl),

          if (state.failure != null) ...[
            SbCard(
              child: Text(
                state.failure!.message,
                style: Theme.of(context).textTheme.bodyLarge!,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: SbSpacing.xxl),
          ],

          if (state.result != null) ...[
            buildResultCard(state.result!),
            const SizedBox(height: SbSpacing.xxl),
          ],
        ],
      ),
    );
  }
}











