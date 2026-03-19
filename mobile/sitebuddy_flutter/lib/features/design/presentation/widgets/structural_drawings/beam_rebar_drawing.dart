import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/theme/app_text_styles.dart';

/// WIDGET: BeamRebarDrawing
/// PURPOSE: Cross-section visualization for RC Beams.
class BeamRebarDrawing extends StatelessWidget {
  final double width; // mm
  final double depth; // mm
  final double cover; // mm
  final int mainBars;
  final double mainBarDia;
  final int hangerBars;
  final double hangerBarDia;
  final int stirrupLegs;
  final double stirrupDia;
  final double stirrupSpacing;

  const BeamRebarDrawing({
    super.key,
    required this.width,
    required this.depth,
    required this.cover,
    required this.mainBars,
    required this.mainBarDia,
    this.hangerBars = 2,
    this.hangerBarDia = 10,
    required this.stirrupLegs,
    required this.stirrupDia,
    required this.stirrupSpacing,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark
        ? Colors.orange.shade300
        : Colors.orange.shade700;
    final textColor = isDark ? Colors.white70 : Colors.black87;

    return AspectRatio(
      aspectRatio: 1.2,
      child: Column(
        children: [
          Expanded(
            child: InteractiveViewer(
              minScale: 1.0,
              maxScale: 4.0,
              child: CustomPaint(
                size: Size.infinite,
                painter: _BeamPainter(
                  width: width,
                  depth: depth,
                  cover: cover,
                  mainBars: mainBars,
                  hangerBars: hangerBars,
                  primaryColor: primaryColor,
                  textColor: textColor,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.sm),
            child: Text(
              'Beam Section: ${width.toInt()}x${depth.toInt()} mm',
              style: AppTextStyles.caption.copyWith(color: textColor),
            ),
          ),
        ],
      ),
    );
  }
}

class _BeamPainter extends CustomPainter {
  final double width;
  final double depth;
  final double cover;
  final int mainBars;
  final int hangerBars;
  final Color primaryColor;
  final Color textColor;

  _BeamPainter({
    required this.width,
    required this.depth,
    required this.cover,
    required this.mainBars,
    required this.hangerBars,
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

    final stirrupPaint = Paint()
      ..color = textColor.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final padding = 30.0;

    // Scale to fit
    double aspect = width / depth;
    double h = size.height - 2 * padding;
    double w = h * aspect;
    if (w > size.width - 2 * padding) {
      w = size.width - 2 * padding;
      h = w / aspect;
    }

    final rect = Rect.fromCenter(center: Offset(cx, cy), width: w, height: h);
    canvas.drawRect(rect, paint);

    // Stirrup (Link)
    final scale = w / width;
    final innerRect = rect.deflate(cover * scale);
    canvas.drawRect(innerRect, stirrupPaint);

    // Main Reinforcement (Bottom)
    final barRadius = 4.0;
    final rebarY = innerRect.bottom - 5;
    for (int i = 0; i < mainBars; i++) {
      double x;
      if (mainBars == 1) {
        x = innerRect.center.dx;
      } else {
        x = innerRect.left + 5 + (innerRect.width - 10) * (i / (mainBars - 1));
      }
      canvas.drawCircle(Offset(x, rebarY), barRadius, rebarPaint);
    }

    // Hanger Bars (Top)
    final hangerY = innerRect.top + 5;
    for (int i = 0; i < hangerBars; i++) {
      double x;
      if (hangerBars == 1) {
        x = innerRect.center.dx;
      } else {
        x =
            innerRect.left +
            5 +
            (innerRect.width - 10) * (i / (hangerBars - 1));
      }
      canvas.drawCircle(Offset(x, hangerY), barRadius, rebarPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
