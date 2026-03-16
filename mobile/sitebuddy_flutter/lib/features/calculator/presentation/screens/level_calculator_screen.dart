import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/theme/app_font_sizes.dart';
import 'package:site_buddy/core/widgets/app_screen_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/widgets/app_number_field.dart';
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
            const SizedBox(height: AppSpacing.md), // Replaced AppLayout.vGap16
            Text(
              '${result.difference.toStringAsFixed(2)} m',
              style: TextStyle(
                fontSize: 32, // Preserving headlineLarge-like size
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm), // Replaced AppLayout.vGap8
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm / 2, // Replaced AppLayout.xs (4px)
              ),
              child: Text(
                directionLabel,
                style: TextStyle(
                  fontSize: AppFontSizes.tab,
                  color: directionColor,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24
            SbListItem(
              title: 'Absolute Difference',
              trailing: Text(
                '${result.absoluteDifference.toStringAsFixed(2)} m',
                style: const TextStyle(fontSize: AppFontSizes.subtitle),
              ),
            ),
          ],
        ),
      );
    }

    return AppScreenWrapper(
      title: 'Level Calculator',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(SbIcons.ruler, size: 72, color: colorScheme.primary),
          const SizedBox(height: AppSpacing.md), // Replaced AppLayout.vGap16
          const Text(
            'Field Level Comparison',
            style: TextStyle(
              fontSize: AppFontSizes.title,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24

          AppNumberField(
            label: 'Start Level (m)',
            suffixIcon: SbIcons.arrowUp,
            onChanged: controller.updateStartLevel,
            errorText: sError,
          ),
          const SizedBox(height: AppSpacing.sm), // Replaced AppLayout.vGap8

          AppNumberField(
            label: 'End Level (m)',
            suffixIcon: SbIcons.arrowDown,
            onChanged: controller.updateEndLevel,
            errorText: eError,
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
                icon: state.isLoading ? null : SbIcons.calculator,
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
            buildResultCard(state.result!),
            const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24
          ],
        ],
      ),
    );
  }
}
