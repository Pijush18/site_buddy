import 'package:flutter/material.dart';
import 'package:site_buddy/core/theme/app_text_styles.dart';
import 'package:site_buddy/shared/domain/models/design/column_enums.dart';
import 'dart:math' as math;

/// WIDGET: ColumnRebarDrawing
/// PURPOSE: Professional engineering cross-section diagram for RC Columns.
class ColumnRebarDrawing extends StatelessWidget {
  final double width; // mm (B)
  final double depth; // mm (D)
  final double cover; // mm
  final int numBars;
  final double barDia; // mm
  final double tieDia; // mm
  final double tieSpacing; // mm
  final ColumnType type;

  const ColumnRebarDrawing({
    super.key,
    required this.width,
    required this.depth,
    required this.cover,
    required this.numBars,
    required this.barDia,
    required this.tieDia,
    required this.tieSpacing,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? Colors.blue.shade300 : Colors.blue.shade700;
    final textColor = isDark ? Colors.white70 : Colors.black87;

    return AspectRatio(
      aspectRatio: 1,
      child: Column(
        children: [
          Expanded(
            child: InteractiveViewer(
              minScale: 1.0,
              maxScale: 4.0,
              child: CustomPaint(
                size: Size.infinite,
                painter: _ColumnPainter(
                  width: width,
                  depth: depth,
                  cover: cover,
                  numBars: numBars,
                  barDia: barDia,
                  tieDia: tieDia,
                  type: type,
                  primaryColor: primaryColor,
                  textColor: textColor,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              '${type.label} Section: ${width.toInt()}x${depth.toInt()} mm',
              style: AppTextStyles.labelSmall.copyWith(color: textColor),
            ),
          ),
        ],
      ),
    );
  }
}

class _ColumnPainter extends CustomPainter {
  final double width;
  final double depth;
  final double cover;
  final int numBars;
  final double barDia;
  final double tieDia;
  final ColumnType type;
  final Color primaryColor;
  final Color textColor;

  _ColumnPainter({
    required this.width,
    required this.depth,
    required this.cover,
    required this.numBars,
    required this.barDia,
    required this.tieDia,
    required this.type,
    required this.primaryColor,
    required this.textColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = textColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final rebarPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;

    final tiePaint = Paint()
      ..color = textColor.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final padding = 40.0;
    final drawAreaWidth = size.width - 2 * padding;
    final drawAreaHeight = size.height - 2 * padding;

    if (type == ColumnType.circular) {
      final radius = math.min(drawAreaWidth, drawAreaHeight) / 2;
      // Draw Concrete Outline
      canvas.drawCircle(Offset(cx, cy), radius, paint);

      // Draw Lateral Tie (Spiral/Link)
      final tieRadius =
          radius - (cover * (radius / (math.max(width, depth) / 2)));
      canvas.drawCircle(Offset(cx, cy), tieRadius, tiePaint);

      // Draw Main Rebar
      final barPlacementRadius = tieRadius;
      for (int i = 0; i < numBars; i++) {
        final angle = (2 * math.pi * i) / numBars;
        final x = cx + barPlacementRadius * math.cos(angle);
        final y = cy + barPlacementRadius * math.sin(angle);
        canvas.drawCircle(Offset(x, y), 4.0, rebarPaint);
      }
    } else {
      // Rectangular
      double aspect = width / depth;
      double w, h;
      if (aspect > 1) {
        w = drawAreaWidth;
        h = w / aspect;
      } else {
        h = drawAreaHeight;
        w = h * aspect;
      }

      final rect = Rect.fromCenter(center: Offset(cx, cy), width: w, height: h);
      canvas.drawRect(rect, paint);

      // Link (Tie)
      final scale = w / width;
      final innerRect = rect.deflate(cover * scale);
      canvas.drawRect(innerRect, tiePaint);

      // Main Rebar placement
      final bars = _calculateRectBarPositions(innerRect, numBars);
      for (var pos in bars) {
        canvas.drawCircle(pos, 4.0, rebarPaint);
      }
    }

    // Dimension lines (Simplified)
    _drawDimension(
      canvas,
      cx - drawAreaWidth / 2,
      cy + drawAreaHeight / 2 + 10,
      cx + drawAreaWidth / 2,
      cy + drawAreaHeight / 2 + 10,
      '${width.toInt()} mm',
    );
  }

  List<Offset> _calculateRectBarPositions(Rect rect, int count) {
    List<Offset> positions = [];
    if (count < 4) count = 4;

    // Corner bars
    positions.add(rect.topLeft);
    positions.add(rect.topRight);
    positions.add(rect.bottomLeft);
    positions.add(rect.bottomRight);

    if (count > 4) {
      int remaining = count - 4;
      // Distribute along edges (simplified logic)
      int sideX = (remaining / 2).floor();
      for (int i = 1; i <= sideX; i++) {
        double dx = rect.width / (sideX + 1) * i;
        positions.add(Offset(rect.left + dx, rect.top));
        positions.add(Offset(rect.left + dx, rect.bottom));
      }
    }
    return positions;
  }

  void _drawDimension(
    Canvas canvas,
    double x1,
    double y1,
    double x2,
    double y2,
    String text,
  ) {
    final p = Paint()
      ..color = textColor.withValues(alpha: 0.5)
      ..strokeWidth = 1.0;
    canvas.drawLine(Offset(x1, y1), Offset(x2, y2), p);
    // Draw tick marks
    canvas.drawLine(Offset(x1, y1 - 5), Offset(x1, y1 + 5), p);
    canvas.drawLine(Offset(x2, y2 - 5), Offset(x2, y2 + 5), p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
