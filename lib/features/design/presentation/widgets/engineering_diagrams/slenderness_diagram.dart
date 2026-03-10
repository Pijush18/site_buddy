import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/theme/app_text_styles.dart';

class SlendernessDiagram extends StatelessWidget {
  final double slendernessX;
  final double slendernessY;
  final double lex;
  final double ley;
  final double b;
  final double d;
  final bool isCircular;

  const SlendernessDiagram({
    super.key,
    required this.slendernessX,
    required this.slendernessY,
    required this.lex,
    required this.ley,
    required this.b,
    required this.d,
    this.isCircular = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final axisColor = isDark ? Colors.white70 : Colors.black87;
    final diagramColor = isDark ? Colors.blue.shade300 : Colors.blue.shade600;

    return Container(
      padding: AppLayout.paddingMedium,

      child: AspectRatio(
        aspectRatio: 2.5, // Balanced ratio for slenderness visualization
        child: Row(
          children: [
            // Visual Illustration
            Expanded(
              flex: 3,
              child: CustomPaint(
                painter: _SlendernessPainter(
                  lex: lex,
                  ley: ley,
                  b: b,
                  d: d,
                  isCircular: isCircular,
                  axisColor: axisColor,
                  diagramColor: diagramColor,
                ),
              ),
            ),
            // Values Labels
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ValueLabel(
                    label: isCircular ? 'λ = le / D' : 'λx = lex / D',
                    value: slendernessX.toStringAsFixed(2),
                    color: diagramColor,
                  ),
                  AppLayout.vGap12,
                  if (!isCircular)
                    _ValueLabel(
                      label: 'λy = ley / b',
                      value: slendernessY.toStringAsFixed(2),
                      color: diagramColor,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ValueLabel extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _ValueLabel({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(color: Colors.grey),
        ),
        Text(value, style: AppTextStyles.titleMedium.copyWith(color: color)),
      ],
    );
  }
}

class _SlendernessPainter extends CustomPainter {
  final double lex;
  final double ley;
  final double b;
  final double d;
  final bool isCircular;
  final Color axisColor;
  final Color diagramColor;

  _SlendernessPainter({
    required this.lex,
    required this.ley,
    required this.b,
    required this.d,
    required this.isCircular,
    required this.axisColor,
    required this.diagramColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = axisColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final diagramPaint = Paint()
      ..color = diagramColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    // Draw simple column vertical line (representing effective length)
    final top = Offset(size.width * 0.3, size.height * 0.1);
    final bottom = Offset(size.width * 0.3, size.height * 0.9);
    canvas.drawLine(top, bottom, diagramPaint);

    // Draw dimension lines
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    // lex label
    _drawDimension(
      canvas,
      Offset(size.width * 0.1, size.height * 0.1),
      Offset(size.width * 0.1, size.height * 0.9),
      'lex',
      paint,
      textPainter,
    );

    // Cross-section view at top
    final centerX = size.width * 0.7;
    final centerY = size.height * 0.5;
    final boxSize = size.width * 0.2;

    if (isCircular) {
      canvas.drawCircle(Offset(centerX, centerY), boxSize / 2, paint);
      _drawDimension(
        canvas,
        Offset(centerX - boxSize / 2, centerY + boxSize / 2 + 10),
        Offset(centerX + boxSize / 2, centerY + boxSize / 2 + 10),
        'D',
        paint,
        textPainter,
      );
    } else {
      final rect = Rect.fromCenter(
        center: Offset(centerX, centerY),
        width: boxSize,
        height: boxSize * (d / b).clamp(0.5, 2.0),
      );
      canvas.drawRect(rect, paint);
      _drawDimension(
        canvas,
        rect.bottomLeft + const Offset(0, 10),
        rect.bottomRight + const Offset(0, 10),
        'b',
        paint,
        textPainter,
      );
      _drawDimension(
        canvas,
        rect.topRight + const Offset(10, 0),
        rect.bottomRight + const Offset(10, 0),
        'D',
        paint,
        textPainter,
      );
    }
  }

  void _drawDimension(
    Canvas canvas,
    Offset start,
    Offset end,
    String label,
    Paint paint,
    TextPainter tp,
  ) {
    canvas.drawLine(start, end, paint);
    // Arrows (simple)
    // ...
    tp.text = TextSpan(
      text: label,
      style: TextStyle(color: axisColor),
    );
    tp.layout();
    tp.paint(
      canvas,
      Offset((start.dx + end.dx) / 2 + 2, (start.dy + end.dy) / 2 - 5),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
