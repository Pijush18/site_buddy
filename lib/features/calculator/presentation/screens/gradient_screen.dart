import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/widgets/app_number_field.dart';
import 'package:site_buddy/features/calculator/application/controllers/gradient_controller.dart';
import 'package:site_buddy/features/calculator/domain/entities/gradient_result.dart';

/// SCREEN: GradientScreen
/// PURPOSE: UI for calculating slope and gradient based on rise and run.
class GradientScreen extends ConsumerWidget {
  const GradientScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(gradientControllerProvider);
    final controller = ref.read(gradientControllerProvider.notifier);
    final colorScheme = theme.colorScheme;

    Widget buildResultCard(GradientResult result) {
      String classificationLabel;
      Color classificationColor;
      switch (result.classification) {
        case GradientClassification.flat:
          classificationLabel = 'FLAT';
          classificationColor = colorScheme.outline;
          break;
        case GradientClassification.mild:
          classificationLabel = 'MILD';
          classificationColor = colorScheme.primary;
          break;
        case GradientClassification.moderate:
          classificationLabel = 'MODERATE';
          classificationColor = colorScheme.secondary;
          break;
        case GradientClassification.steep:
          classificationLabel = 'STEEP';
          classificationColor = colorScheme.error;
          break;
      }

      return SbCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '${result.percentage.toStringAsFixed(2)}%',
              style: SbTextStyles.headlineLarge(context).copyWith(
                color: colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
            AppLayout.vGap16,
            Text(
              'Ratio: ${result.ratio}',
              style: SbTextStyles.body(context),
              textAlign: TextAlign.center,
            ),
            AppLayout.vGap8,
            Text(
              'Angle: ${result.angle.toStringAsFixed(1)}°',
              style: SbTextStyles.body(context),
              textAlign: TextAlign.center,
            ),
            AppLayout.vGap16,
            Align(
              alignment: Alignment.center,
              child: Container(
                padding: AppLayout.paddingMedium,

                child: Text(
                  classificationLabel,
                  style: SbTextStyles.caption(context).copyWith(
                    color: classificationColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return SbPage.form(
      title: 'Gradient Tool',
      primaryAction: SbButton.primary(
        label: state.isLoading ? 'Calculating...' : 'Calculate',
        icon: state.isLoading ? null : SbIcons.calculator,
        isLoading: state.isLoading,
        onPressed: controller.calculate,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(SbIcons.trendingUp, size: 48, color: colorScheme.primary),
              AppLayout.hGap12,
              Flexible(
                child: Text(
                  'Slope & Gradient Calculator',
                  style: SbTextStyles.title(context),
                ),
              ),
            ],
          ),
          AppLayout.vGap24,

          AppNumberField(
            label: 'Vertical Rise (m)',
            suffixIcon: SbIcons.arrowUp,
            onChanged: controller.updateRise,
          ),
          AppLayout.vGap12,

          AppNumberField(
            label: 'Horizontal Run (m)',
            suffixIcon: SbIcons.arrowForward,
            onChanged: controller.updateRun,
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
