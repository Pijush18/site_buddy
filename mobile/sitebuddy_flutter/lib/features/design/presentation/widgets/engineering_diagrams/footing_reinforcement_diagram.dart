import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/theme/app_text_styles.dart';

class FootingReinforcementDiagram extends StatelessWidget {
  final double length; // mm
  final double width; // mm
  final double thickness; // mm
  final double colA; // mm
  final double colB; // mm
  final String sbc; // kN/m2
  final String qu; // kN/m2
  final String rebarX;
  final String rebarY;

  const FootingReinforcementDiagram({
    super.key,
    required this.length,
    required this.width,
    required this.thickness,
    required this.colA,
    required this.colB,
    required this.sbc,
    required this.qu,
    required this.rebarX,
    required this.rebarY,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final axisColor = isDark ? Colors.white70 : Colors.black87;
    final diagramColor = isDark ? Colors.blue.shade300 : Colors.blue.shade700;
    final colColor = isDark ? Colors.white24 : Colors.black12;

    return Container(
      padding: AppLayout.paddingMedium,

      child: AspectRatio(
        aspectRatio: 1.8, // Slightly taller for footing details
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: CustomPaint(
                painter: _FootingPainter(
                  length: length,
                  width: width,
                  colA: colA,
                  colB: colB,
                  axisColor: axisColor,
                  diagramColor: diagramColor,
                  colColor: colColor,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(left: AppSpacing.sm),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ValueTile(
                      label: 'Dim (LxB)',
                      value:
                          '${(length / 1000).toStringAsFixed(2)}x${(width / 1000).toStringAsFixed(2)} m',
                    ),
                    AppLayout.vGap8,
                    _ValueTile(
                      label: 'Thickness',
                      value: '${thickness.toInt()} mm',
                    ),
                    AppLayout.vGap12,
                    _ValueTile(
                      label: 'Net Soil Pr.',
                      value: '$qu kN/m²',
                      color: Colors.blue,
                    ),
                    AppLayout.vGap12,
                    _ValueTile(label: 'Steel X-X', value: rebarX, isBold: true),
                    AppLayout.vGap4,
                    _ValueTile(label: 'Steel Y-Y', value: rebarY, isBold: true),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ValueTile extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  final bool isBold;

  const _ValueTile({
    required this.label,
    required this.value,
    this.color,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption(context),
        ),
        Flexible(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.body(context).copyWith(color: color),
          ),
        ),
      ],
    );
  }
}

class _FootingPainter extends CustomPainter {
  final double length;
  final double width;
  final double colA;
  final double colB;
  final Color axisColor;
  final Color diagramColor;
  final Color colColor;

  _FootingPainter({
    required this.length,
    required this.width,
    required this.colA,
    required this.colB,
    required this.axisColor,
    required this.diagramColor,
    required this.colColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final diagramPaint = Paint()
      ..color = diagramColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final ratio = (width / length).clamp(0.4, 1.0);
    final drawWidth = size.width * 0.8;
    final drawHeight = drawWidth * ratio;

    final rect = Rect.fromCenter(
      center: Offset(size.width * 0.5, size.height * 0.5),
      width: drawWidth,
      height: drawHeight,
    );

    canvas.drawRect(rect, diagramPaint);

    // Reinforcement lines (schematic)
    final barPaint = Paint()
      ..color = diagramColor.withValues(alpha: 0.3)
      ..strokeWidth = 1.0;

    for (int i = 1; i < 5; i++) {
      double x = rect.left + (rect.width * i / 5);
      canvas.drawLine(
        Offset(x, rect.top + 4),
        Offset(x, rect.bottom - 4),
        barPaint,
      );

      double y = rect.top + (rect.height * i / 5);
      canvas.drawLine(
        Offset(rect.left + 4, y),
        Offset(rect.right - 4, y),
        barPaint,
      );
    }

    // Column rectangle in center
    final colPaint = Paint()
      ..color = colColor
      ..style = PaintingStyle.fill;

    final colDrawA = (colA / length) * drawWidth;
    final colDrawB = (colB / width) * drawHeight;

    final colRect = Rect.fromCenter(
      center: rect.center,
      width: colDrawA.clamp(10.0, rect.width * 0.5),
      height: colDrawB.clamp(10.0, rect.height * 0.5),
    );

    canvas.drawRect(colRect, colPaint);
    canvas.drawRect(
      colRect,
      diagramPaint
        ..strokeWidth = 1.0
        ..color = diagramColor.withValues(alpha: 0.7),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
