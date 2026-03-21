import 'package:site_buddy/core/design_system/sb_radius.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';

import 'package:flutter/material.dart';
import 'package:site_buddy/core/theme/app_colors.dart';

class ColumnInteractionDiagram extends StatelessWidget {
  final double pu;
  final double mu;
  final double interactionRatio;

  const ColumnInteractionDiagram({
    super.key,
    required this.pu,
    required this.mu,
    required this.interactionRatio,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final axisColor = colorScheme.onSurfaceVariant;
    final color = interactionRatio <= 1.0 
        ? AppColors.success(context) 
        : colorScheme.error;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(SbSpacing.lg),
      child: AspectRatio(
        aspectRatio: 1.5,
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  // Axis Labels
                  Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      'Vertical: Pu (kN)',
                      style: Theme.of(context).textTheme.labelMedium!,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: RotatedBox(
                      quarterTurns: 1,
                      child: Text(
                        'Horizontal: Mu (kNm)',
                        style: Theme.of(context).textTheme.labelMedium!,
                      ),
                    ),
                  ),

                  // Realistic P-M curve
                  Center(
                    child: CustomPaint(
                      size: const Size(200, 160),
                      painter: _InteractionCurvePainter(
                        axisColor: axisColor,
                        curveColor: colorScheme.primary,
                      ),
                    ),
                  ),

                  // Design Point
                  Center(
                    child: _DesignPoint(
                      ratio: interactionRatio,
                      color: color,
                      pu: pu,
                      mu: mu,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: SbSpacing.lg),
            Text(
              interactionRatio <= 1.0
                  ? 'Design point is within the safe envelope.'
                  : 'Design point exceeds the capacity envelope!',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelMedium!,
            ),
          ],
        ),
      ),
    );
  }
}

class _DesignPoint extends StatelessWidget {
  final double ratio;
  final Color color;
  final double pu;
  final double mu;

  const _DesignPoint({
    required this.ratio,
    required this.color,
    required this.pu,
    required this.mu,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    double x = (ratio > 1.2 ? 100.0 : ratio * 80.0);
    double y = (ratio > 1.2 ? 80.0 : ratio * 60.0);

    return Transform.translate(
      offset: Offset(x - 40, -y + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: colorScheme.surface, width: 2),
            ),
          ),
          SizedBox(height: SbSpacing.xs),
          Container(
            padding: const EdgeInsets.all(SbSpacing.xs),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: SbRadius.borderSmall,
            ),
            child: Text(
              'Pu=${pu.toInt()}, Mu=${mu.toInt()}',
              style: Theme.of(context).textTheme.labelMedium!,
            ),
          ),
        ],
      ),
    );
  }
}

class _InteractionCurvePainter extends CustomPainter {
  final Color axisColor;
  final Color curveColor;

  _InteractionCurvePainter({
    required this.axisColor,
    required this.curveColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = curveColor.withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;

    final outlinePaint = Paint()
      ..color = curveColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final axisPaint = Paint()
      ..color = axisColor.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawLine(
      Offset(0, size.height),
      Offset(size.width, size.height),
      axisPaint,
    );
    canvas.drawLine(const Offset(0, 0), Offset(0, size.height), axisPaint);

    final path = Path();
    path.moveTo(0, 10);
    path.quadraticBezierTo(
      size.width * 0.4,
      0,
      size.width * 0.6,
      size.height * 0.3,
    );
    path.quadraticBezierTo(
      size.width * 0.9,
      size.height * 0.6,
      size.width,
      size.height * 0.8,
    );
    path.quadraticBezierTo(
      size.width * 0.8,
      size.height * 0.9,
      size.width * 0.6,
      size.height,
    );
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
    canvas.drawPath(path, outlinePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}










