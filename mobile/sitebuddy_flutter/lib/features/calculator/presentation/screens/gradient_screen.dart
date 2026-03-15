import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
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

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SbCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'RESULT SUMMARY',
                  style: SbTextStyles.title(context).copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                AppLayout.vGap16,
                const Divider(),
                SbListItem(
                  title: 'Percentage',
                  trailing: Text(
                    '${result.percentage.toStringAsFixed(2)}%',
                    style: SbTextStyles.body(context).copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SbListItem(
                  title: 'Ratio',
                  trailing: Text(
                    result.ratio == double.infinity ? 'Vertical' : '1 : ${result.ratio.toStringAsFixed(2)}',
                  ),
                ),
                SbListItem(
                  title: 'Angle',
                  trailing: Text('${result.angle.toStringAsFixed(2)}°'),
                ),
                const Divider(height: AppLayout.lg),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: classificationColor.withValues(alpha: 0.1),
                    borderRadius: AppLayout.borderRadiusCard,
                    border: Border.all(color: classificationColor.withValues(alpha: 0.2)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'CLASSIFICATION',
                        style: SbTextStyles.caption(context).copyWith(
                          color: classificationColor.withValues(alpha: 0.6),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      AppLayout.vGap4,
                      Text(
                        classificationLabel,
                        style: SbTextStyles.title(context).copyWith(
                          color: classificationColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          AppLayout.vGap24,
          SbCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'SLOPE VISUALIZATION',
                  style: SbTextStyles.title(context).copyWith(color: colorScheme.primary),
                ),
                AppLayout.vGap16,
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

    return SbPage.detail(
      title: 'Gradient Tool',
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
            errorText: rError,
          ),
          AppLayout.vGap12,

          AppNumberField(
            label: 'Horizontal Run (m)',
            suffixIcon: SbIcons.arrowForward,
            onChanged: controller.updateRun,
            errorText: runError,
          ),

          AppLayout.vGap24,

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
          AppLayout.vGap24,

          if (state.failure != null) ...[
            SbCard(
              child: Text(
                state.failure!.message,
                style: SbTextStyles.body(context).copyWith(
                  color: colorScheme.error,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            AppLayout.vGap24,
          ],

          if (state.result != null) ...[
            buildResultCard(state.result!),
            AppLayout.vGap24,
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
          'FIELD REFERENCE',
          style: SbTextStyles.title(context).copyWith(color: colorScheme.primary),
          textAlign: TextAlign.center,
        ),
        AppLayout.vGap12,
        const SbCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              SbListItem(title: 'Sewer Pipes', trailing: Text('1:100 to 1:200')),
              Divider(height: 1),
              SbListItem(title: 'Road Cross Fall', trailing: Text('2% to 3%')),
              Divider(height: 1),
              SbListItem(title: 'Wheelchair Ramp', trailing: Text('1:12 (max 1:8)')),
              Divider(height: 1),
              SbListItem(title: 'Earthworks Batter', trailing: Text('1:2 to 1:4')),
            ],
          ),
        ),
        AppLayout.vGap24,
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
