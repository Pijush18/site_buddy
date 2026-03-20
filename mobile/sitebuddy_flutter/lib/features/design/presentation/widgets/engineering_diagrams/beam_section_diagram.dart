
import 'package:flutter/material.dart';

class BeamSectionDiagram extends StatelessWidget {
  final double b;
  final double d;
  final double cover;
  final List<double> rebars;

  const BeamSectionDiagram({
    super.key,
    required this.b,
    required this.d,
    required this.cover,
    required this.rebars,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final axisColor = theme.brightness == Brightness.dark ? Colors.white70 : Colors.black87;
    final labelStyle = Theme.of(context).textTheme.labelMedium!;

    return AspectRatio(
      aspectRatio: 1.2,
      child: CustomPaint(
        painter: _BeamSectionPainter(
          b: b,
          d: d,
          cover: cover,
          rebars: rebars,
          axisColor: axisColor,
          labelStyle: labelStyle,
          diagramColor: theme.colorScheme.primary,
        ),
      ),
    );
  }
}

class _BeamSectionPainter extends CustomPainter {
  final double b;
  final double d;
  final double cover;
  final List<double> rebars;
  final Color axisColor;
  final TextStyle labelStyle;
  final Color diagramColor;

  _BeamSectionPainter({
    required this.b,
    required this.d,
    required this.cover,
    required this.rebars,
    required this.axisColor,
    required this.diagramColor,
    required this.labelStyle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = axisColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final rebarPaint = Paint()
      ..color = diagramColor
      ..style = PaintingStyle.fill;

    // Draw beam rectangle
    final rect = Rect.fromLTWH(
      size.width * 0.2,
      size.height * 0.1,
      size.width * 0.6,
      size.height * 0.8,
    );
    canvas.drawRect(rect, paint);

    // Draw dimension labels
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    // Width label
    _drawLabel(canvas, Offset(size.width * 0.5, size.height * 0.05), 'b = ${b.toInt()}mm', textPainter);

    // Depth label
    _drawLabel(canvas, Offset(size.width * 0.9, size.height * 0.5), 'D = ${d.toInt()}mm', textPainter);

    // Draw rebars (simplified visualization)
    final rebarY = rect.bottom - (cover / d) * rect.height;
    for (int i = 0; i < rebars.length; i++) {
      final rebarX = rect.left + (i + 1) * (rect.width / (rebars.length + 1));
      canvas.drawCircle(Offset(rebarX, rebarY), 4, rebarPaint);
    }
  }

  void _drawLabel(Canvas canvas, Offset position, String text, TextPainter tp) {
    tp.text = TextSpan(text: text, style: labelStyle);
    tp.layout();
    tp.paint(canvas, position - Offset(tp.width / 2, tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}







