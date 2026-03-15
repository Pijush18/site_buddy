import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/theme/app_text_styles.dart';

class BeamSectionDiagram extends StatelessWidget {
  final double span; // mm
  final double width; // mm
  final double depth; // mm
  final String mu; // kNm
  final String ast; // mm2
  final String stirrupInfo;

  const BeamSectionDiagram({
    super.key,
    required this.span,
    required this.width,
    required this.depth,
    required this.mu,
    required this.ast,
    required this.stirrupInfo,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final axisColor = isDark ? Colors.white70 : Colors.black87;
    final diagramColor = isDark ? Colors.blue.shade300 : Colors.blue.shade600;

    return Container(
      height: 200,
      padding: AppLayout.paddingMedium,

      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: CustomPaint(
              painter: _BeamPainter(
                span: span,
                width: width,
                depth: depth,
                axisColor: axisColor,
                diagramColor: diagramColor,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InfoItem(label: 'Mu', value: '$mu kNm', color: diagramColor),
                AppLayout.vGap8,
                _InfoItem(label: 'Ast', value: '$ast mm²', color: diagramColor),
                AppLayout.vGap8,
                _InfoItem(
                  label: 'Stirrups',
                  value: stirrupInfo,
                  color: Colors.green,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _InfoItem({
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
        Text(value, style: AppTextStyles.bodyMedium.copyWith(color: color)),
      ],
    );
  }
}

class _BeamPainter extends CustomPainter {
  final double span;
  final double width;
  final double depth;
  final Color axisColor;
  final Color diagramColor;

  _BeamPainter({
    required this.span,
    required this.width,
    required this.depth,
    required this.axisColor,
    required this.diagramColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final axisPaint = Paint()
      ..color = axisColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final diagramPaint = Paint()
      ..color = diagramColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    // Draw beam longitudinal view
    final beamRect = Rect.fromLTWH(
      size.width * 0.1,
      size.height * 0.4,
      size.width * 0.8,
      size.height * 0.2,
    );
    canvas.drawRect(beamRect, diagramPaint);

    // Supports
    canvas.drawPath(
      Path()
        ..moveTo(beamRect.left, beamRect.bottom)
        ..lineTo(beamRect.left - 5, beamRect.bottom + 10)
        ..lineTo(beamRect.left + 5, beamRect.bottom + 10)
        ..close(),
      axisPaint,
    );
    canvas.drawPath(
      Path()
        ..moveTo(beamRect.right, beamRect.bottom)
        ..lineTo(beamRect.right - 5, beamRect.bottom + 10)
        ..lineTo(beamRect.right + 5, beamRect.bottom + 10)
        ..close(),
      axisPaint,
    );

    // Span label
    final tp = TextPainter(textDirection: TextDirection.ltr);
    tp.text = TextSpan(
      text: 'L = ${(span / 1000).toStringAsFixed(2)} m',
      style: TextStyle(color: axisColor),
    );
    tp.layout();
    tp.paint(canvas, Offset(size.width * 0.4, beamRect.top - 15));

    // Cross section view
    // (Simplified)
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
