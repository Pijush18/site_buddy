import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/theme/app_text_styles.dart';

class SlabReinforcementDiagram extends StatelessWidget {
  final double lx; // m
  final double ly; // m
  final double thickness; // mm
  final String mainRebar;
  final String distRebar;
  final bool isTwoWay;

  const SlabReinforcementDiagram({
    super.key,
    required this.lx,
    required this.ly,
    required this.thickness,
    required this.mainRebar,
    required this.distRebar,
    this.isTwoWay = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final axisColor = colorScheme.onSurfaceVariant;
    final diagramColor = colorScheme.primary;

    return Container(
      padding: AppLayout.paddingMedium,

      child: AspectRatio(
        aspectRatio: 2.0, // Standard responsive ratio
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: CustomPaint(
                painter: _SlabPainter(
                  lx: lx,
                  ly: ly,
                  isTwoWay: isTwoWay,
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
                  _InfoTile(label: 'Lx', value: '${lx.toStringAsFixed(2)} m'),
                  AppLayout.vGap8,
                  _InfoTile(label: 'Ly', value: '${ly.toStringAsFixed(2)} m'),
                  AppLayout.vGap12,
                  _InfoTile(label: 'Main', value: mainRebar, isBold: true),
                  AppLayout.vGap4,
                  _InfoTile(label: 'Dist', value: distRebar),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _InfoTile({
    required this.label,
    required this.value,
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
          style: AppTextStyles.labelSmall.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        Flexible(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodyMedium.copyWith(
              fontSize: isBold ? 13 : 12,
            ),
          ),
        ),
      ],
    );
  }
}

class _SlabPainter extends CustomPainter {
  final double lx;
  final double ly;
  final bool isTwoWay;
  final Color axisColor;
  final Color diagramColor;

  _SlabPainter({
    required this.lx,
    required this.ly,
    required this.isTwoWay,
    required this.axisColor,
    required this.diagramColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final diagramPaint = Paint()
      ..color = diagramColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final rect = Rect.fromCenter(
      center: Offset(size.width * 0.5, size.height * 0.5),
      width: size.width * 0.7,
      height: size.width * 0.7 * (ly / lx).clamp(0.5, 1.5),
    );

    canvas.drawRect(rect, diagramPaint);

    // Reinforcement lines (schematic)
    final barPaint = Paint()
      ..color = diagramColor.withValues(alpha: 0.3)
      ..strokeWidth = 1.0;
    for (int i = 1; i < 5; i++) {
      double x = rect.left + (rect.width * i / 5);
      canvas.drawLine(Offset(x, rect.top), Offset(x, rect.bottom), barPaint);
    }

    if (isTwoWay) {
      // Load distribution lines (diagonal)
      final dashPaint = Paint()
        ..color = axisColor.withValues(alpha: 0.2)
        ..strokeWidth = 1.0;
      canvas.drawLine(rect.topLeft, rect.bottomRight, dashPaint);
      canvas.drawLine(rect.topRight, rect.bottomLeft, dashPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
