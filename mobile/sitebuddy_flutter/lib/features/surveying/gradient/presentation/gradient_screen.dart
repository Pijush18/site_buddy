import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/localization/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/features/surveying/gradient/application/gradient_controller.dart';
import 'package:site_buddy/features/surveying/gradient/domain/gradient_result.dart';
import 'package:site_buddy/shared/widgets/action_buttons_group.dart';

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
    final l10n = context.l10n;

    final bool isValid = state.rise != null && state.run != null;

    final rError = state.failure?.message.toLowerCase().contains('rise') == true ? state.failure?.message : null;
    final runError = state.failure?.message.toLowerCase().contains('run') == true ? state.failure?.message : null;

    Widget buildResultCard(GradientResult result) {
      String classificationLabel;
      switch (result.classification) {
        case GradientClassification.flat:
          classificationLabel = l10n.labelFlat;
          break;
        case GradientClassification.mild:
          classificationLabel = l10n.labelMild;
          break;
        case GradientClassification.moderate:
          classificationLabel = l10n.labelModerate;
          break;
        case GradientClassification.steep:
          classificationLabel = l10n.labelSteep;
          break;
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SbCard(
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
                SbListItemTile(
                  title: l10n.labelPercentage,
                  onTap: () {}, // Detail view entry
                  trailing: Text(
                    '${result.percentage.toStringAsFixed(2)}%',
                    style: theme.textTheme.labelLarge!,
                  ),
                ),
                SbListItemTile(
                  title: l10n.labelRatio,
                  onTap: () {}, // Detail view entry
                  trailing: Text(
                    result.ratio == double.infinity ? l10n.labelVertical : '1 : ${result.ratio.toStringAsFixed(2)}',
                    style: theme.textTheme.bodyLarge!,
                  ),
                ),
                SbListItemTile(
                  title: l10n.labelAngle,
                  onTap: () {}, // Detail view entry
                  trailing: Text(
                    '${result.angle.toStringAsFixed(2)}°',
                    style: theme.textTheme.bodyLarge!,
                  ),
                ),
                const Divider(),
                const SizedBox(height: AppSpacing.md),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  child: Column(
                    children: [
                      Text(
                        l10n.labelClassification,
                        style: theme.textTheme.labelMedium!,
                      ),
                      const SizedBox(height: AppSpacing.sm / 2),
                      Text(
                        classificationLabel,
                        style: theme.textTheme.titleMedium!,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          SbCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  l10n.labelSlopeVisualization,
                  style: theme.textTheme.titleMedium!,
                ),
                const SizedBox(height: AppSpacing.lg),
                SizedBox(
                  height: 120,
                  width: double.infinity,
                  child: CustomPaint(
                    painter: _SlopeTrianglePainter(
                      color: colorScheme.primary,
                      rise: result.rise,
                      run: result.run,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return SbPage.scaffold(
      title: l10n.titleGradientEstimator,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(SbIcons.trendingUp, size: 48, color: colorScheme.primary),
              const SizedBox(width: AppSpacing.sm),
              Flexible(
                child: Text(
                  l10n.labelSlopeCalculator,
                  style: theme.textTheme.titleMedium!,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          SbInput(
            label: l10n.labelVerticalRise,
            suffixIcon: const Icon(SbIcons.arrowUp),
            onChanged: controller.updateRise,
            errorText: rError,
          ),
          const SizedBox(height: AppSpacing.md),

          SbInput(
            label: l10n.labelHorizontalRun,
            suffixIcon: const Icon(SbIcons.arrowForward),
            onChanged: controller.updateRun,
            errorText: runError,
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

          const _FieldReference(),
        ],
      ),
    );
  }
}

class _FieldReference extends StatelessWidget {
  const _FieldReference();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.labelFieldReference,
          style: theme.textTheme.titleMedium!,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.sm), 
        SbCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              SbListItemTile(title: l10n.labelSewerPipes, onTap: () {}, trailing: Text(l10n.valSewerPipesRef)),
              const Divider(height: 1),
              SbListItemTile(title: l10n.labelRoadCrossFall, onTap: () {}, trailing: Text(l10n.valRoadCrossFallRef)),
              const Divider(height: 1),
              SbListItemTile(title: l10n.labelWheelchairRamp, onTap: () {}, trailing: Text(l10n.valWheelchairRampRef)),
              const Divider(height: 1),
              SbListItemTile(title: l10n.labelEarthworksBatter, onTap: () {}, trailing: Text(l10n.valEarthworksBatterRef)),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}

class _SlopeTrianglePainter extends CustomPainter {
  final Color color;
  final double rise;
  final double run;

  _SlopeTrianglePainter({
    required this.color,
    required this.rise,
    required this.run,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = color.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;
    
    if (run == 0 || rise.isNaN || run.isNaN) return;
    
    const double padding = 16.0;
    final w = size.width - padding * 2;
    final h = size.height - padding * 2;

    final boxRatio = h / w;
    final dataRatio = rise / run;
    
    double drawW = w;
    double drawH = h;
    
    if (dataRatio > boxRatio) {
      drawH = h;
      drawW = h / dataRatio;
    } else {
      drawW = w;
      drawH = w * dataRatio;
    }
    
    final dx = (size.width - drawW) / 2;
    final dy = (size.height - drawH) / 2;
    
    final path = Path();
    path.moveTo(dx, dy + drawH); // bottom left
    path.lineTo(dx + drawW, dy + drawH); // bottom right
    path.lineTo(dx + drawW, dy); // top right
    path.close();

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SlopeTrianglePainter oldDelegate) {
    return oldDelegate.rise != rise || oldDelegate.run != run || oldDelegate.color != color;
  }
}

