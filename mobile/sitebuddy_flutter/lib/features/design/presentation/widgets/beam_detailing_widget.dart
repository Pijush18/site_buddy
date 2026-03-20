
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:site_buddy/core/theme/app_text_styles.dart';

import 'dart:math';
import 'package:flutter/material.dart';

/// WIDGET: BeamDetailingWidget
/// PURPOSE: Visual representation of beam cross-section and rebar layout.
class BeamDetailingWidget extends StatelessWidget {
  final double width;
  final double depth;
  final int numBars;
  final double barDia;
  final double stirrupSpacing;

  const BeamDetailingWidget({
    super.key,
    required this.width,
    required this.depth,
    required this.numBars,
    required this.barDia,
    required this.stirrupSpacing,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: Container(
        padding: AppLayout.paddingLarge,

        child: CustomPaint(
          painter: _DetailingPainter(
            b: width,
            d: depth,
            n: numBars,
            dia: barDia,
            spacing: stirrupSpacing,
            labelStyle: AppTextStyles.caption(context),
          ),
        ),
      ),
    );
  }
}

class _DetailingPainter extends CustomPainter {
  final double b, d, dia, spacing;
  final int n;
  final TextStyle labelStyle;

  _DetailingPainter({
    required this.b,
    required this.d,
    required this.n,
    required this.dia,
    required this.spacing,
    required this.labelStyle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (b <= 0 || d <= 0) return;

    final concretePaint = Paint()
      ..color = Colors.white24
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final rebarPaint = Paint()
      ..color = const Color(0xFF2563EB)
      ..style = PaintingStyle.fill;

    final stirrupPaint = Paint()
      ..color = Colors.white38
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // 1. Scale concrete section to fit canvas
    final scale = min(size.width / b, size.height / d) * 0.8;
    final rectWidth = b * scale;
    final rectHeight = d * scale;

    final left = (size.width - rectWidth) / 2;
    final top = (size.height - rectHeight) / 2;
    final rect = Rect.fromLTWH(left, top, rectWidth, rectHeight);

    // Draw Concrete Outer
    canvas.drawRect(rect, concretePaint);

    // Draw Stirrup (Inner rectangle)
    final stirrupRect = rect.deflate(10 * scale);
    canvas.drawRRect(
      RRect.fromRectAndRadius(stirrupRect, const Radius.circular(4)),
      stirrupPaint,
    );

    // 2. Draw Top Bars (2 hanger bars usually)
    final topBarY = stirrupRect.top + 4;
    canvas.drawCircle(Offset(stirrupRect.left + 4, topBarY), 3, rebarPaint);
    canvas.drawCircle(Offset(stirrupRect.right - 4, topBarY), 3, rebarPaint);

    // 3. Draw Bottom Tension Bars
    if (n > 0) {
      final tensionY = stirrupRect.bottom - 4;
      final gap = stirrupRect.width / (n + 1);
      for (int i = 1; i <= n; i++) {
        canvas.drawCircle(
          Offset(stirrupRect.left + i * gap, tensionY),
          max(2, dia * scale / 2),
          rebarPaint,
        );
      }
    }

    // 4. Dimensions
    _drawText(
      canvas,
      '${b.toInt()}mm',
      Offset(rect.center.dx - 15, rect.bottom + 10),
    );
    canvas.save();
    canvas.translate(rect.left - 15, rect.center.dy + 15);
    canvas.rotate(-pi / 2);
    _drawText(canvas, '${d.toInt()}mm', Offset.zero);
    canvas.restore();
  }

  void _drawText(Canvas canvas, String text, Offset offset) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: labelStyle.copyWith(color: Colors.grey),
      ),
      textDirection: TextDirection.ltr,
    );
    tp.layout();
    tp.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
