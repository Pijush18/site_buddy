import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/theme/app_font_sizes.dart';
import 'package:site_buddy/core/widgets/app_screen_wrapper.dart';
import 'package:site_buddy/core/constants/app_strings.dart';
import 'package:site_buddy/core/constants/engineering_terms.dart';
import 'package:site_buddy/core/constants/screen_titles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/widgets/app_number_field.dart';
import 'package:site_buddy/features/calculator/application/controllers/gradient_controller.dart';
import 'package:site_buddy/features/calculator/domain/entities/gradient_result.dart';
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

    final bool isValid = state.rise != null && state.run != null;

    final rError = state.failure?.message.toLowerCase().contains('rise') == true ? state.failure?.message : null;
    final runError = state.failure?.message.toLowerCase().contains('run') == true ? state.failure?.message : null;

    Widget buildResultCard(GradientResult result) {
      String classificationLabel;
      Color classificationColor;
      switch (result.classification) {
        case GradientClassification.flat:
          classificationLabel = EngineeringTerms.flat;
          classificationColor = colorScheme.outline;
          break;
        case GradientClassification.mild:
          classificationLabel = EngineeringTerms.mild;
          classificationColor = colorScheme.primary;
          break;
        case GradientClassification.moderate:
          classificationLabel = EngineeringTerms.moderate;
          classificationColor = colorScheme.secondary;
          break;
        case GradientClassification.steep:
          classificationLabel = EngineeringTerms.steep;
          classificationColor = colorScheme.error;
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
                  title: EngineeringTerms.percentage,
                  onTap: () {}, // Detail view entry
                  trailing: Text(
                    '${result.percentage.toStringAsFixed(2)}%',
                    style: TextStyle(
                      fontSize: AppFontSizes.subtitle,
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SbListItemTile(
                  title: EngineeringTerms.ratio,
                  onTap: () {}, // Detail view entry
                  trailing: Text(
                    result.ratio == double.infinity ? EngineeringTerms.vertical : '1 : ${result.ratio.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: AppFontSizes.subtitle),
                  ),
                ),
                SbListItemTile(
                  title: EngineeringTerms.angle,
                  onTap: () {}, // Detail view entry
                  trailing: Text(
                    '${result.angle.toStringAsFixed(2)}°',
                    style: const TextStyle(fontSize: AppFontSizes.subtitle),
                  ),
                ),
                const Divider(),
                const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.lg
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    children: [
                      Text(
                        EngineeringTerms.classification,
                        style: TextStyle(
                          fontSize: AppFontSizes.tab,
                          color: classificationColor.withValues(alpha: 0.6),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm / 2), // Replaced AppLayout.vGap4
                      Text(
                        classificationLabel,
                        style: TextStyle(
                          fontSize: AppFontSizes.title,
                          fontWeight: FontWeight.w600,
                          color: classificationColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24
          SbCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  EngineeringTerms.slopeVisualization,
                  style: TextStyle(
                    fontSize: AppFontSizes.title,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: AppSpacing.md), // Replaced AppLayout.vGap16
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

    return AppScreenWrapper(
      title: ScreenTitles.gradientTool,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(SbIcons.trendingUp, size: 48, color: colorScheme.primary),
              const SizedBox(width: AppSpacing.sm), // Replaced AppLayout.hGap12
              const Flexible(
                child: Text(
                  EngineeringTerms.slopeCalculator,
                  style: TextStyle(
                    fontSize: AppFontSizes.title,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24

          AppNumberField(
            label: EngineeringTerms.verticalRise,
            suffixIcon: SbIcons.arrowUp,
            onChanged: controller.updateRise,
            errorText: rError,
          ),
          const SizedBox(height: AppSpacing.sm), // Replaced AppLayout.vGap12

          AppNumberField(
            label: EngineeringTerms.horizontalRun,
            suffixIcon: SbIcons.arrowForward,
            onChanged: controller.updateRun,
            errorText: runError,
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
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          EngineeringTerms.fieldReference,
          style: TextStyle(
            fontSize: AppFontSizes.title,
            fontWeight: FontWeight.w600,
            color: colorScheme.primary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.sm), // Replaced AppLayout.vGap12
        SbCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              SbListItemTile(title: EngineeringTerms.sewerPipes, onTap: () {}, trailing: const Text(EngineeringTerms.sewerPipesRef)),
              const Divider(height: 1),
              SbListItemTile(title: EngineeringTerms.roadCrossFall, onTap: () {}, trailing: const Text(EngineeringTerms.roadCrossFallRef)),
              const Divider(height: 1),
              SbListItemTile(title: EngineeringTerms.wheelchairRamp, onTap: () {}, trailing: const Text(EngineeringTerms.wheelchairRampRef)),
              const Divider(height: 1),
              SbListItemTile(title: EngineeringTerms.earthworksBatter, onTap: () {}, trailing: const Text(EngineeringTerms.earthworksBatterRef)),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24
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
