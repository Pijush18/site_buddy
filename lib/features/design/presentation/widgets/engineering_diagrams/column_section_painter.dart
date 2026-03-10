import 'package:flutter/material.dart';
import 'dart:math';
import 'package:site_buddy/shared/domain/models/design/column_enums.dart';

class ColumnSectionPainter extends CustomPainter {
  final ColumnType type;
  final double width; // b
  final double depth; // d
  final int numBars;
  final double mainBarDia;
  final double cover;
  final bool isDark;

  ColumnSectionPainter({
    required this.type,
    required this.width,
    required this.depth,
    required this.numBars,
    required this.mainBarDia,
    required this.cover,
    this.isDark = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final outlineColor = isDark ? Colors.white24 : Colors.black26;

    final paint = Paint()
      ..color = outlineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final rebarPaint = Paint()
      ..color = const Color(0xFF2563EB)
      ..style = PaintingStyle.fill;

    final tiePaint = Paint()
      ..color = isDark ? Colors.white54 : Colors.black45
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Scale factors to fit in size
    final maxDim = max(width, depth);
    final scale = (min(size.width, size.height) * 0.8) / maxDim;

    final scaledW = width * scale;
    final scaledD = depth * scale;
    final scaledCover = cover * scale;

    if (type == ColumnType.circular) {
      final radius = scaledW / 2;
      // Draw Column Outline
      canvas.drawCircle(center, radius, paint);
      // Draw Ties (Inner circle)
      canvas.drawCircle(center, radius - scaledCover, tiePaint);

      // Draw Bars
      for (int i = 0; i < numBars; i++) {
        final angle = (2 * pi / numBars) * i;
        final barPos = Offset(
          center.dx + (radius - scaledCover) * cos(angle),
          center.dy + (radius - scaledCover) * sin(angle),
        );
        canvas.drawCircle(barPos, (mainBarDia * scale) / 2 + 2, rebarPaint);
      }
    } else {
      final rect = Rect.fromCenter(
        center: center,
        width: scaledW,
        height: scaledD,
      );
      // Draw Column Outline
      canvas.drawRect(rect, paint);
      // Draw Ties (Inner rect)
      final tieRect = rect.deflate(scaledCover);
      canvas.drawRect(tieRect, tiePaint);

      // Draw Bars (Corner bars + intermediate)
      _drawRectangularBars(
        canvas,
        tieRect,
        numBars,
        mainBarDia * scale,
        rebarPaint,
      );
    }
  }

  void _drawRectangularBars(
    Canvas canvas,
    Rect tieRect,
    int count,
    double scaledDia,
    Paint paint,
  ) {
    final barRadius = scaledDia / 2 + 2;

    // Corners
    canvas.drawCircle(tieRect.topLeft, barRadius, paint);
    canvas.drawCircle(tieRect.topRight, barRadius, paint);
    canvas.drawCircle(tieRect.bottomLeft, barRadius, paint);
    canvas.drawCircle(tieRect.bottomRight, barRadius, paint);

    int remaining = count - 4;
    if (remaining <= 0) return;

    // Distribute remaining bars along sides
    // Simplification: Assume even distribution for visualization
    int sideBars = (remaining / 2).floor();

    for (int i = 1; i <= sideBars; i++) {
      double t = i / (sideBars + 1);
      // Top and bottom sides
      canvas.drawCircle(
        Offset(tieRect.left + tieRect.width * t, tieRect.top),
        barRadius,
        paint,
      );
      canvas.drawCircle(
        Offset(tieRect.left + tieRect.width * t, tieRect.bottom),
        barRadius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant ColumnSectionPainter oldDelegate) {
    return oldDelegate.numBars != numBars ||
        oldDelegate.mainBarDia != mainBarDia ||
        oldDelegate.width != width ||
        oldDelegate.depth != depth ||
        oldDelegate.type != type;
  }
}
