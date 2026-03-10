import 'package:site_buddy/core/theme/app_layout.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/theme/app_text_styles.dart';

class BeamCrossSectionDiagram extends StatelessWidget {
  final double width;
  final double depth;
  final int numBars;
  final double barDia;
  final double stirrupSpacing;

  const BeamCrossSectionDiagram({
    super.key,
    required this.width,
    required this.depth,
    required this.numBars,
    required this.barDia,
    required this.stirrupSpacing,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final axisColor = isDark ? Colors.white70 : Colors.black87;
    final rebarColor = isDark ? Colors.blue.shade300 : Colors.blue.shade600;

    return Container(
      padding: AppLayout.paddingMedium,

      child: AspectRatio(
        aspectRatio: 2.0, // Standard responsive ratio
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Center(
                child: CustomPaint(
                  size: const Size(180, 180),
                  painter: _CrossSectionPainter(
                    b: width,
                    d: depth,
                    n: numBars,
                    dia: barDia,
                    axisColor: axisColor,
                    rebarColor: rebarColor,
                    isDark: isDark,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Label(label: 'Width', value: '${width.toInt()} mm'),
                  AppLayout.vGap8,
                  _Label(label: 'Depth', value: '${depth.toInt()} mm'),
                  AppLayout.vGap16,
                  _Label(
                    label: 'Main Steel',
                    value: '$numBars bars Ø${barDia.toInt()}',
                    isBold: true,
                  ),
                  AppLayout.vGap4,
                  _Label(
                    label: 'Stirrups',
                    value: '@ ${stirrupSpacing.toInt()} mm c/c',
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

class _Label extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _Label({required this.label, required this.value, this.isBold = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.labelSmall.copyWith(color: Colors.grey),
        ),
        Flexible(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodyMedium,
          ),
        ),
      ],
    );
  }
}

class _CrossSectionPainter extends CustomPainter {
  final double b, d, dia;
  final int n;
  final Color axisColor;
  final Color rebarColor;
  final bool isDark;

  _CrossSectionPainter({
    required this.b,
    required this.d,
    required this.n,
    required this.dia,
    required this.axisColor,
    required this.rebarColor,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (b <= 0 || d <= 0) return;

    final concretePaint = Paint()
      ..color = axisColor.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final rebarPaint = Paint()
      ..color = rebarColor
      ..style = PaintingStyle.fill;

    final stirrupPaint = Paint()
      ..color = axisColor.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Scale to fit
    final scale = min(size.width / b, size.height / d) * 0.9;
    final rectWidth = b * scale;
    final rectHeight = d * scale;

    final rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: rectWidth,
      height: rectHeight,
    );

    // Concrete
    canvas.drawRect(rect, concretePaint);

    // Stirrup
    final stirrupRect = rect.deflate(5 * scale);
    canvas.drawRRect(
      RRect.fromRectAndRadius(stirrupRect, const Radius.circular(2)),
      stirrupPaint,
    );

    // Bottom Rebars
    if (n > 0) {
      final tensionY = stirrupRect.bottom - 4;
      final gap = stirrupRect.width / (n + 1);
      for (int i = 1; i <= n; i++) {
        canvas.drawCircle(
          Offset(stirrupRect.left + i * gap, tensionY),
          max(3, dia * scale / 2),
          rebarPaint,
        );
      }
    }

    // Top Hanger Bars (Fixed 2)
    final topY = stirrupRect.top + 4;
    final hangerPaint = Paint()
      ..color = rebarColor.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(stirrupRect.left + 4, topY), 3, hangerPaint);
    canvas.drawCircle(Offset(stirrupRect.right - 4, topY), 3, hangerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
