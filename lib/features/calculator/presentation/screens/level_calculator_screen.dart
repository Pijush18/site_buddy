import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/widgets/app_number_field.dart';
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

    Widget buildResultCard(LevelResult result) {
      String directionLabel;
      Color directionColor;
      switch (result.direction) {
        case LevelDirection.rise:
          directionLabel = 'RISE';
          directionColor = colorScheme.primary;
          break;
        case LevelDirection.fall:
          directionLabel = 'FALL';
          directionColor = colorScheme.error;
          break;
        case LevelDirection.flat:
          directionLabel = 'FLAT';
          directionColor = colorScheme.onSurfaceVariant;
          break;
      }

      return SbCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Difference',
              style: SbTextStyles.title(context).copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            AppLayout.vGap16,
            Text(
              '${result.difference.toStringAsFixed(2)} m',
              style: SbTextStyles.headlineLarge(context).copyWith(
                color: colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
            AppLayout.vGap24,
            Text(
              'Absolute: ${result.absoluteDifference.toStringAsFixed(2)} m',
              style: SbTextStyles.body(context),
              textAlign: TextAlign.center,
            ),
            AppLayout.vGap16,
            Align(
              alignment: Alignment.center,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppLayout.pMedium,
                  vertical: AppLayout.pSmall,
                ),

                child: Text(
                  directionLabel,
                  style: SbTextStyles.caption(context).copyWith(
                    color: directionColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return SbPage.form(
      title: 'Level Calculator',
      primaryAction: SbButton.primary(
        label: state.isLoading ? 'Calculating...' : 'Calculate',
        icon: state.isLoading ? null : SbIcons.calculator,
        isLoading: state.isLoading,
        onPressed: controller.calculate,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(SbIcons.ruler, size: 72, color: colorScheme.primary),
          AppLayout.vGap16,
          Text(
            'Field Level Comparison',
            style: SbTextStyles.title(context),
            textAlign: TextAlign.center,
          ),
          AppLayout.vGap24,

          AppNumberField(
            label: 'Start Level (m)',
            suffixIcon: SbIcons.arrowUp,
            onChanged: controller.updateStartLevel,
          ),
          AppLayout.vGap8,

          AppNumberField(
            label: 'End Level (m)',
            suffixIcon: SbIcons.arrowDown,
            onChanged: controller.updateEndLevel,
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

          if (state.result != null) ...[
            buildResultCard(state.result!),
            AppLayout.vGap24,
          ],
        ],
      ),
    );
  }
}
