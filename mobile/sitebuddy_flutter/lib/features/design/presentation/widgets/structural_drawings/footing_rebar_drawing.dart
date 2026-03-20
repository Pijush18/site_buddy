import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:flutter/material.dart';


/// WIDGET: FootingRebarDrawing
/// PURPOSE: Plan layout for RC Footing reinforcement.
class FootingRebarDrawing extends StatelessWidget {
  final double length; // mm
  final double width; // mm
  final double thickness; // mm
  final double colA; // mm
  final double colB; // mm
  final double barDia; // mm
  final double spacing; // mm

  const FootingRebarDrawing({
    super.key,
    required this.length,
    required this.width,
    required this.thickness,
    required this.colA,
    required this.colB,
    required this.barDia,
    required this.spacing,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark
        ? Colors.purple.shade300
        : Colors.purple.shade700;
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
                painter: _FootingPainter(
                  length: length,
                  width: width,
                  colA: colA,
                  colB: colB,
                  primaryColor: primaryColor,
                  textColor: textColor,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: SbSpacing.sm),
            child: Text(
              'Footing Detail: ${length.toInt()}x${width.toInt()} mm',
              style: Theme.of(context).textTheme.labelMedium!,
            ),
          ),
        ],
      ),
    );
  }
}

class _FootingPainter extends CustomPainter {
  final double length;
  final double width;
  final double colA;
  final double colB;
  final Color primaryColor;
  final Color textColor;

  _FootingPainter({
    required this.length,
    required this.width,
    required this.colA,
    required this.colB,
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
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final cx = size.width / 2;
    final cy = size.height / 2;
    const padding = 30.0;

    double aspect = length / width;
    double w = size.width - 2 * padding;
    double h = w / aspect;
    if (h > size.height - 2 * padding) {
      h = size.height - 2 * padding;
      w = h * aspect;
    }

    final rect = Rect.fromCenter(center: Offset(cx, cy), width: w, height: h);
    canvas.drawRect(rect, paint);

    // Column center
    final scale = w / length;
    final colRect = Rect.fromCenter(
      center: Offset(cx, cy),
      width: colA * scale,
      height: colB * scale,
    );
    canvas.drawRect(colRect, paint);

    // Cross hatch for column
    canvas.drawLine(colRect.topLeft, colRect.bottomRight, paint);
    canvas.drawLine(colRect.topRight, colRect.bottomLeft, paint);

    // Reinforcement Grid
    int barsX = 8;
    int barsY = 8;

    for (int i = 1; i < barsX; i++) {
      double x = rect.left + (rect.width / barsX) * i;
      canvas.drawLine(
        Offset(x, rect.top + 5),
        Offset(x, rect.bottom - 5),
        rebarPaint,
      );
    }
    for (int i = 1; i < barsY; i++) {
      double y = rect.top + (rect.height / barsY) * i;
      canvas.drawLine(
        Offset(rect.left + 5, y),
        Offset(rect.right - 5, y),
        rebarPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}








