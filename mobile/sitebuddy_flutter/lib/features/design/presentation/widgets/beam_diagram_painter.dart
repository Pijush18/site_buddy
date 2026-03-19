
import 'package:flutter/material.dart';
import 'package:site_buddy/shared/domain/models/design/beam_design_state.dart';

/// PAINTER: BeamDiagramPainter
/// PURPOSE: Draws SFD and BMD curves for the beam.
class BeamDiagramPainter extends CustomPainter {
  final List<DiagramPoint> points;
  final bool isBMD;
  final String label;
  final Color axisColor;
  final Color labelColor;
  final TextTheme textTheme;
  final Color primaryColor;
  final Color warningColor;

  BeamDiagramPainter({
    required this.points,
    required this.isBMD,
    required this.label,
    required this.axisColor,
    required this.labelColor,
    required this.textTheme,
    required this.primaryColor,
    required this.warningColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final paint = Paint()
      ..color = isBMD ? primaryColor : warningColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final fillPaint = Paint()
      ..color = (isBMD ? primaryColor : warningColor).withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;

    final axisPaint = Paint()
      ..color = axisColor
      ..strokeWidth = 1.0;

    // 1. Draw Axis
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      axisPaint,
    );

    // 2. Scaling
    final span = points.last.x;
    double maxValue = points.fold(
      0.0,
      (max, p) => p.value.abs() > max ? p.value.abs() : max,
    );
    if (maxValue == 0) maxValue = 1;

    final path = Path();
    path.moveTo(0, size.height / 2);

    for (var p in points) {
      final dx = (p.x / span) * size.width;
      // Invert Y for positive BM (usually drawn downwards in structural engineering)
      final dy = size.height / 2 - (p.value / maxValue) * (size.height / 2.5);
      path.lineTo(dx, dy);
    }

    path.lineTo(size.width, size.height / 2);

    // Draw Area Fill
    canvas.drawPath(path, fillPaint);
    // Draw Stroke
    canvas.drawPath(path, paint);

    // 3. Labels
    final textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: textTheme.labelSmall?.copyWith(color: labelColor),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, const Offset(5, 5));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
